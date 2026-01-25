-- GOLD LAYER TABLES (BUSINESS / KPIs)
-- Dataset: revcycle_gold

-- Gold Revenue KPIs
CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_gold.gold_revenue_kpis` (
  hospital_id STRING,
  total_claims INT64,
  total_claimed_amount FLOAT64,
  total_approved_amount FLOAT64,
  approved_claims INT64,
  rejected_claims INT64,
  pending_claims INT64,
  approval_rate FLOAT64
);


-- Gold Patients Summary
CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_gold.gold_patients_summary` (
  hospital_id STRING,
  patient_id INT64,
  full_name STRING,
  total_encounters INT64,
  total_billed_amount FLOAT64,
  total_paid_amount FLOAT64,
  total_claimed_amount FLOAT64,
  total_approved_amount FLOAT64,
  last_encounter_date DATE
);
