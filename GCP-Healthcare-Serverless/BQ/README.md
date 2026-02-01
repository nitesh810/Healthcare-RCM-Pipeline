# BigQuery SQL Layer (BQ/)

This folder contains all **BigQuery SQL files** used in the project.

These SQL scripts are executed automatically by the Cloud Run pipeline controller:

Cloud_Run_Service/main.py  
(Triggered by Cloud Scheduler daily)

---

## Why this folder exists

Instead of writing SQL inside Python code, Keeping SQL in separate files so:
- Code stays clean
- SQL is easy to read
- SQL can be changed without rewriting Python

---

## Medallion Architecture

This project follows:

Bronze → Silver → Gold

### Bronze (RAW)
Folder:
`BQ/Bronze/`

Purpose:
- Create bronze tables schema
- Load raw data from GCS landing

Tables:
- bronze_patients
- bronze_encounters
- bronze_transactions
- bronze_claims
- bronze_cpt_codes

---

### Silver (Clean / CDM)
Folder:
`BQ/Silver/`

Purpose:
- Clean raw bronze data
- Convert datatypes
- Remove duplicates
- Build facts and SCD2 dimension

Tables:
- dim_patient (SCD2)
- fact_encounter
- fact_transaction
- fact_claim

---

### Gold (Business / KPI)
Folder:
`BQ/Gold/`

Purpose:
- Create business-ready reporting tables
- KPI tables for dashboards

Tables:
- gold_revenue_kpis
- gold_patients_summary

---

## How SQL scripts are executed

Execution order is controlled from:

Cloud_Run_Service/config/sql_config.json

Example:
- bronze_sql_files
- silver_sql_files
- gold_sql_files

Cloud Run service:
1) Reads the SQL file
2) Sends it to BigQuery
3) BigQuery executes the query
---

> "Iimplemented BigQuery transformations using file-based SQL scripts organized by Medallion Architecture and executed them through a serverless Cloud Run controller."



