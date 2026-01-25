-- BRONZE TABLES (RAW LAYER)
-- Dataset: revcycle_bronze

CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_bronze.bronze_claims` (
  claim_id STRING,
  hospital_id STRING,
  patient_id INT64,
  encounter_id INT64,
  claim_date DATE,
  cpt_code STRING,
  claim_amount FLOAT64,
  approved_amount FLOAT64,
  status STRING,
  updated_at STRING,
  ingestion_ts STRING
);


-- CPT Codes (reference)
CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_bronze.bronze_cpt_codes` (
  cpt_code STRING,
  procedure_desc STRING,
  category STRING
);


-- Patients (hospital-a + hospital-b landing)
CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_bronze.bronze_patients` (
  hospital_id STRING,
  patient_id INT64,
  full_name STRING,
  gender STRING,
  dob DATE,
  phone STRING,
  email STRING,
  address STRING,
  updated_at STRING,
  ingestion_ts STRING
);


-- Encounters (hospital-a + hospital-b landing)
CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_bronze.bronze_encounters` (
  hospital_id STRING,
  encounter_id INT64,
  patient_id INT64,
  encounter_date DATE,
  encounter_type STRING,
  department STRING,
  provider_name STRING,
  diagnosis_code STRING,
  updated_at STRING,
  ingestion_ts STRING
);


-- Transactions (hospital-a + hospital-b landing)
CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_bronze.bronze_transactions` (
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
  updated_at STRING,
  ingestion_ts STRING
);
