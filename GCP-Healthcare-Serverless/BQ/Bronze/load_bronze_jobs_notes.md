# Bronze Load Jobs Notes

Bronze layer is the **raw ingestion layer**.

This project uses:
✅ GCS landing CSV files as the source  
✅ Cloud Scheduler triggers pipeline daily  
✅ Cloud Run service loads files into BigQuery Bronze tables  

---

## 1) GCS Landing Inputs

### A) Hospital landing files (daily)
Folder structure:

- hospital-a
  - landing/hospital-a/patients/patients_YYYYMMDD.csv
  - landing/hospital-a/encounters/encounters_YYYYMMDD.csv
  - landing/hospital-a/transactions/transactions_YYYYMMDD.csv

- hospital-b
  - landing/hospital-b/patients/patients_YYYYMMDD.csv
  - landing/hospital-b/encounters/encounters_YYYYMMDD.csv
  - landing/hospital-b/transactions/transactions_YYYYMMDD.csv

### B) Claims data (monthly)
- landing/claims/YYYY/MM/claim_hospital_a_YYYYMM.csv
- landing/claims/YYYY/MM/claim_hospital_b_YYYYMM.csv

Example:
- gs://revcycle-lite-bucket/landing/claims/2025/03/*.csv

### C) CPT codes (reference)
- landing/cptcodes/cpt_codes.csv

Example:
- gs://revcycle-lite-bucket/landing/cptcodes/cpt_codes.csv

---

## 2) BigQuery Bronze Outputs

Dataset:
- revcycle_bronze

Tables:
- bronze_patients
- bronze_encounters
- bronze_transactions
- bronze_claims
- bronze_cpt_codes

---

## 3) How Bronze Load Works

Cloud Run controller does 2 actions:

### A) Create bronze schemas (fixed)
Runs:
- BQ/Bronze/create_bronze_tables.sql

This uses:
✅ CREATE OR REPLACE
so schema stays consistent.

### B) Load landing CSV files into bronze tables
Uses BigQuery Load Job:
- autodetect=True
- WRITE_TRUNCATE

Meaning:
✅ Bronze gets refreshed each run  
✅ No duplicates  
✅ Easy to explain in interview  

---

## 4) Why WRITE_TRUNCATE?

Because:
- Claims data comes as monthly snapshot
- Hospital landing files are treated as daily snapshot for demo

So bronze is always clean and consistent.

---

> "Bronze layer stores raw data loaded from GCS landing. I refresh Bronze tables on every run using BigQuery load jobs and fixed schemas created using CREATE OR REPLACE."

