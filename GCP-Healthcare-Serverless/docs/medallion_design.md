# Medallion Architecture Design

This project uses a 3-layer medallion design:

Bronze → Silver → Gold

---

## Bronze Layer (Raw)

Dataset: `revcycle_bronze`

Stores raw data loaded from GCS landing.

Tables:
- bronze_patients
- bronze_encounters
- bronze_transactions
- bronze_claims
- bronze_cpt_codes

Characteristics:
- raw format
- no business logic
- refreshed every run (WRITE_TRUNCATE)

---

## Silver Layer (Clean / CDM)

Dataset: `revcycle_silver`

Purpose:
- clean raw data
- fix datatype conversions
- remove duplicates
- build standard facts and dimensions

Tables:
- dim_patient (SCD2)
- fact_encounter
- fact_transaction
- fact_claim

---

## Gold Layer (Business)

Dataset: `revcycle_gold`

Purpose:
- aggregation / KPI tables
- reporting layer

Tables:
- gold_revenue_kpis
- gold_patients_summary

---

## Interview line

> "I designed the pipeline using a Medallion Architecture in BigQuery. Bronze stores raw ingested data, Silver contains cleaned CDM tables, and Gold contains KPI tables for dashboards."
