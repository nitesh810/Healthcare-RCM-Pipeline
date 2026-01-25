# Gold Layer (revcycle_gold)

Gold layer = **business-ready tables** for reporting & dashboards.

Gold tables are created from Silver facts/dimensions and store:
- KPIs
- aggregations
- summary tables

---

## Dataset
`revcycle_gold`

---

## Gold Tables

### 1) gold_revenue_kpis
KPI table per hospital:
- total_claims
- total_claimed_amount
- total_approved_amount
- approval_rate
- status counts

SQL:
- gold_revenue_kpis.sql

---

### 2) gold_patients_summary
Patient level summary:
- total encounters
- total billed/paid amounts
- total claim/approved amounts
- last encounter date

SQL:
- gold_patients_summary.sql

---

## Execution Order

1) create_gold_tables.sql
2) gold_revenue_kpis.sql
3) gold_patients_summary.sql

Cloud Run reads this execution order from:
Cloud_Run_Service/config/sql_config.json
