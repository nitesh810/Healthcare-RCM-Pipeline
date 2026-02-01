-- SCD TYPE 2 - DIM PATIENT

-- Keep history when patient details change (phone/email/address etc.)

-- Source: bronze_patients
-- Target: silver dim_patient


-- current record = is_current = TRUE
-- old record closed by updating effective_end_ts and is_current=FALSE


MERGE `revcycle-lite-gcp.revcycle_silver.dim_patient` T
USING (
  SELECT
    hospital_id,
    SAFE_CAST(patient_id AS INT64) AS patient_id,
    full_name,
    gender,
    SAFE_CAST(dob AS DATE) AS dob,
    phone,
    email,
    address,
    SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at,
    TO_HEX(MD5(CONCAT(
      hospital_id, '|',
      CAST(patient_id AS STRING), '|',
      IFNULL(full_name, ''), '|',
      IFNULL(gender, ''), '|',
      IFNULL(CAST(dob AS STRING), ''), '|',
      IFNULL(phone, ''), '|',
      IFNULL(email, ''), '|',
      IFNULL(address, '')
    ))) AS record_hash
  FROM `revcycle-lite-gcp.revcycle_bronze.bronze_patients`
  WHERE patient_id IS NOT NULL
) S
ON T.hospital_id = S.hospital_id
AND T.patient_id = S.patient_id
AND T.is_current = TRUE

-- Case 1: If patient exists and data changed -> close old record
WHEN MATCHED AND T.record_hash != S.record_hash THEN
  UPDATE SET
    effective_end_ts = S.updated_at,
    is_current = FALSE

-- Case 2: If patient not found as current -> insert new record
WHEN NOT MATCHED THEN
  INSERT (
    patient_sk,
    hospital_id,
    patient_id,
    full_name,
    gender,
    dob,
    phone,
    email,
    address,
    effective_start_ts,
    effective_end_ts,
    is_current,
    record_hash
  )
  VALUES (
    FARM_FINGERPRINT(CONCAT(S.hospital_id, '-', CAST(S.patient_id AS STRING), '-', CAST(S.updated_at AS STRING))),
    S.hospital_id,
    S.patient_id,
    S.full_name,
    S.gender,
    S.dob,
    S.phone,
    S.email,
    S.address,
    S.updated_at,
    TIMESTAMP('9999-12-31'),
    TRUE,
    S.record_hash
  );

-- FARM_FINGERPRINT generates a deterministic INT64 surrogate key from a concatenated string of hospital_id, patient_id, and updated_at.
-- It ensures every SCD2 version gets a unique patient_sk, which is used as the dimension primary key for fact table joins.
