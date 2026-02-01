# Silver Layer (revcycle_silver)

Silver layer = **clean + consistent layer**.

In Silver:
- Clean raw bronze data
- Convert datatypes properly (string to int/date/timestamp)
- Remove duplicates
- Prepare CDM(Common Data Model) like tables (Facts + Dimensions)
- Patient dimension uses SCD Type 2 (history tracking)

---

## Dataset
`revcycle_silver`

---

## Silver Tables

### dim_patient (SCD2)
Keeps history when patient details change.

Columns:
- effective_start_ts
- effective_end_ts
- is_current

SQL:
- scd2_dim_patient.sql

---

### fact_encounter
All patient visits (OPD/IPD).

SQL:
- fact_encounter.sql

---

### fact_transaction
All billing/transactions per encounter.

SQL:
- fact_transaction.sql

---

### fact_claim
Insurance claim details.

SQL:
- fact_claim.sql

---

## Execution Order

1) create_silver_tables.sql
2) scd2_dim_patient.sql
3) fact_encounter.sql
4) fact_transaction.sql
5) fact_claim.sql

Cloud Run reads these SQL files from config/sql_config.json and executes them in BigQuery.

