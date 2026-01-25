-- SILVER FACT TRANSACTION
-- Source: bronze_transactions
-- Target: silver fact_transaction


CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_silver.fact_transaction` AS
SELECT DISTINCT
  hospital_id,
  SAFE_CAST(transaction_id AS INT64) AS transaction_id,
  SAFE_CAST(encounter_id AS INT64) AS encounter_id,
  SAFE_CAST(patient_id AS INT64) AS patient_id,
  cpt_code,
  procedure_desc,
  SAFE_CAST(billed_amount AS FLOAT64) AS billed_amount,
  SAFE_CAST(paid_amount AS FLOAT64) AS paid_amount,
  SAFE_CAST(transaction_date AS DATE) AS transaction_date,
  payment_status,
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at,
  SAFE_CAST(ingestion_ts AS TIMESTAMP) AS ingestion_ts
FROM `revcycle-lite-gcp.revcycle_bronze.bronze_transactions`
WHERE transaction_id IS NOT NULL;
