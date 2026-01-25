# GCP Healthcare RCM Serverless Data Engineering Project

This project builds a **serverless data lakehouse pipeline on GCP** for **Healthcare Revenue Cycle Management (RCM)**.

The goal is to ingest raw healthcare and claims data from GCS landing layer, process it using BigQuery, and generate business-ready KPI tables for reporting.

---

## Domain: Revenue Cycle Management (RCM)

RCM covers the full lifecycle from:
- patient visit (encounter)
- services performed
- billing / payments (transactions)
- insurance claim processing (claims)

---

## Services Used (Serverless Only)

- **GCS**: Landing layer (raw CSV files)
- **Cloud Scheduler**: daily trigger
- **Cloud Run**: pipeline controller (GitHub deploy)
- **BigQuery**: Bronze/Silver/Gold datasets and transformations
- **Cloud Logging**: monitoring logs

---

## Data Sources (GCS)

### 1) Hospital EMR CSV data (daily)
For each hospital:
- patients
- encounters
- transactions

Folder structure:
- landing/hospital-a/patients/*.csv
- landing/hospital-a/encounters/*.csv
- landing/hospital-a/transactions/*.csv
- landing/hospital-b/... (same)

### 2) Claims CSV (monthly)
- claim_hospital_a_YYYYMM.csv
- claim_hospital_b_YYYYMM.csv

### 3) CPT Codes (reference)
- cpt_codes.csv

---

## Medallion Architecture

- Bronze: raw ingestion
- Silver: cleaned + CDM
- Gold: KPI tables

---

## Final Output (Gold tables)

- gold_revenue_kpis
- gold_patients_summary

These tables are used for dashboards and reporting.
