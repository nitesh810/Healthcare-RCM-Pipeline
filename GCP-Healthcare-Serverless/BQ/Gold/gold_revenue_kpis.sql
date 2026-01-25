-- GOLD: REVENUE KPIs
--
-- Business KPI table per hospital for dashboards.


CREATE OR REPLACE TABLE `revcycle-lite-gcp.revcycle_gold.gold_revenue_kpis` AS
SELECT
  hospital_id,
  COUNT(*) AS total_claims,
  SUM(claim_amount) AS total_claimed_amount,
  SUM(approved_amount) AS total_approved_amount,
  COUNTIF(status = 'APPROVED') AS approved_claims,
  COUNTIF(status = 'REJECTED') AS rejected_claims,
  COUNTIF(status = 'PENDING') AS pending_claims,
  SAFE_DIVIDE(COUNTIF(status='APPROVED'), COUNT(*)) AS approval_rate
FROM `revcycle-lite-gcp.revcycle_silver.fact_claim`
GROUP BY hospital_id;
