-- SCD TYPE 2 - DIM PATIENT (Robust Version)
-- Keep history when patient details change
-- Source: bronze_patients
-- Target: silver dim_patient

-- Step 1: Prepare source with hash
WITH source_data AS (
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
)

-- Step 2: MERGE into dim_patient
MERGE `revcycle-lite-gcp.revcycle_silver.dim_patient` AS T
USING source_data AS S
ON T.hospital_id = S.hospital_id
   AND T.patient_id = S.patient_id
   AND T.is_current = TRUE

-- Case 1: Close old record if data changed
WHEN MATCHED AND T.record_hash != S.record_hash THEN
  UPDATE SET
    effective_end_ts = S.updated_at,
    is_current = FALSE

-- Case 2: Insert new record if no current record exists or data changed
WHEN NOT MATCHED BY TARGET OR (T.record_hash != S.record_hash) THEN
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
    FARM_FINGERPRINT(CONCAT(
      S.hospital_id, '-', CAST(S.patient_id AS STRING), '-', CAST(S.updated_at AS STRING)
    )),
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

-- 1. FARM_FINGERPRINT generates deterministic INT64 surrogate key.
-- 2. New record is always inserted with is_current = TRUE.
-- 3. Old record is always closed with is_current = FALSE.
-- 4. record_hash ensures SCD2 changes are detected.

-- FARM_FINGERPRINT generates a deterministic INT64 surrogate key from a concatenated string of hospital_id, patient_id, and updated_at.
-- It ensures every SCD2 version gets a unique patient_sk, which is used as the dimension primary key for fact table joins.
