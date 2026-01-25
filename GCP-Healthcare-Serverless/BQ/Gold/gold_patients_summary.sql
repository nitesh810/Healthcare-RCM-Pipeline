-- GOLD: PATIENTS SUMMARY
--
-- Business table for reporting:
-- One row per patient with billing + claim summary.


CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_gold.gold_patients_summary` AS
SELECT
  p.hospital_id,
  p.patient_id,
  p.full_name,

  -- total number of encounters per patient
  COUNT(DISTINCT e.encounter_id) AS total_encounters,

  -- billing totals from transactions
  SUM(t.billed_amount) AS total_billed_amount,
  SUM(t.paid_amount) AS total_paid_amount,

  -- insurance claim totals
  SUM(c.claim_amount) AS total_claimed_amount,
  SUM(c.approved_amount) AS total_approved_amount,

  -- last encounter date
  MAX(e.encounter_date) AS last_encounter_date

FROM `revcycle-lite-gcp.revcycle_silver.dim_patient` p
LEFT JOIN `revcycle-lite-gcp.revcycle_silver.fact_encounter` e
  ON p.hospital_id = e.hospital_id
 AND p.patient_id = e.patient_id
LEFT JOIN `revcycle-lite-gcp.revcycle_silver.fact_transaction` t
  ON e.hospital_id = t.hospital_id
 AND e.encounter_id = t.encounter_id
 AND e.patient_id = t.patient_id
LEFT JOIN `revcycle-lite-gcp.revcycle_silver.fact_claim` c
  ON e.hospital_id = c.hospital_id
 AND e.encounter_id = c.encounter_id
 AND e.patient_id = c.patient_id

WHERE p.is_current = TRUE
GROUP BY p.hospital_id, p.patient_id, p.full_name;
