-- SILVER LAYER TABLES (CLEAN / CDM)
-- Dataset: revcycle_silver



-- Dimension: Patient (SCD2)
CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_silver.dim_patient` (
  patient_sk INT64,
  hospital_id STRING,
  patient_id INT64,
  full_name STRING,
  gender STRING,
  dob DATE,
  phone STRING,
  email STRING,
  address STRING,
  effective_start_ts TIMESTAMP,
  effective_end_ts TIMESTAMP,
  is_current BOOL,
  record_hash STRING
);


-- Fact: Encounter
CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_silver.fact_encounter` (
  hospital_id STRING,
  encounter_id INT64,
  patient_id INT64,
  encounter_date DATE,
  encounter_type STRING,
  department STRING,
  provider_name STRING,
  diagnosis_code STRING,
  updated_at TIMESTAMP,
  ingestion_ts TIMESTAMP
);


-- Fact: Transaction
CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_silver.fact_transaction` (
  hospital_id STRING,
  transaction_id INT64,
  encounter_id INT64,
  patient_id INT64,
  cpt_code STRING,
  procedure_desc STRING,
  billed_amount FLOAT64,
  paid_amount FLOAT64,
  transaction_date DATE,
  payment_status STRING,
  updated_at TIMESTAMP,
  ingestion_ts TIMESTAMP
);


-- Fact: Claim
CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_silver.fact_claim` (
  claim_id STRING,
  hospital_id STRING,
  patient_id INT64,
  encounter_id INT64,
  claim_date DATE,
  cpt_code STRING,
  claim_amount FLOAT64,
  approved_amount FLOAT64,
  status STRING,
  updated_at TIMESTAMP,
  ingestion_ts TIMESTAMP
);
