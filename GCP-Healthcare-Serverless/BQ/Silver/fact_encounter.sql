-- SILVER FACT ENCOUNTER
-- Source: bronze_encounters
-- Target: silver fact_encounter


CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_silver.fact_encounter` AS
SELECT DISTINCT
  hospital_id,
  SAFE_CAST(encounter_id AS INT64) AS encounter_id,
  SAFE_CAST(patient_id AS INT64) AS patient_id,
  SAFE_CAST(encounter_date AS DATE) AS encounter_date,
  encounter_type,
  department,
  provider_name,
  diagnosis_code,
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at,
  SAFE_CAST(ingestion_ts AS TIMESTAMP) AS ingestion_ts
FROM `revcycle-lite-gcp.revcycle_bronze.bronze_encounters`
WHERE encounter_id IS NOT NULL;
