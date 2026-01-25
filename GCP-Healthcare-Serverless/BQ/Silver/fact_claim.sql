-- SILVER FACT CLAIM
-- Source: Bronze claims (raw)
-- Target: Silver fact_claim (clean)


CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_silver.fact_claim` AS
SELECT
  claim_id,
  hospital_id,
  SAFE_CAST(patient_id AS INT64) AS patient_id,
  SAFE_CAST(encounter_id AS INT64) AS encounter_id,
  SAFE_CAST(claim_date AS DATE) AS claim_date,
  cpt_code,
  SAFE_CAST(claim_amount AS FLOAT64) AS claim_amount,
  SAFE_CAST(approved_amount AS FLOAT64) AS approved_amount,
  status,
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at,
  SAFE_CAST(ingestion_ts AS TIMESTAMP) AS ingestion_ts
FROM `revcycle-lite-gcp.revcycle_bronze.bronze_claims`
WHERE claim_id IS NOT NULL;
