# infra/

This folder contains **infrastructure and deployment notes**.

It is written in simple steps so you can deploy this project without changing anything.

This project is **serverless** and uses:
- GCS (Landing Layer)
- Cloud Scheduler (Trigger)
- Cloud Run (Pipeline Controller)
- BigQuery (Bronze/Silver/Gold)

---

## 1) GCS Bucket Setup (Landing Layer)

Bucket Name:
`revcycle-lite-bucket`

Create folder structure in bucket:

landing/
  hospital-a/
    patients/
    encounters/
    transactions/
  hospital-b/
    patients/
    encounters/
    transactions/
  claims/
    2025/
      03/
  cptcodes/

Upload files into correct paths:
- landing/hospital-a/patients/*.csv
- landing/hospital-a/encounters/*.csv
- landing/hospital-a/transactions/*.csv
- landing/hospital-b/patients/*.csv
- landing/hospital-b/encounters/*.csv
- landing/hospital-b/transactions/*.csv
- landing/claims/2025/03/claim_hospital_a_202503.csv
- landing/claims/2025/03/claim_hospital_b_202503.csv
- landing/cptcodes/cpt_codes.csv

---

## 2) BigQuery Setup (Create datasets only)

Create these datasets manually (only once):
- revcycle_bronze
- revcycle_silver
- revcycle_gold

Important:
✅ You do NOT need to create tables manually  
Cloud Run will run SQL scripts that create tables using CREATE OR REPLACE.

---

## 3) Cloud Run Deployment from GitHub

Deployment method:
✅ Cloud Run → Continuously deploy from a repository (GitHub)

Steps:
1) Push this project code to GitHub repo
2) Go to Cloud Run → Create Service
3) Choose: "Continuously deploy from a repository"
4) Connect GitHub repo
5) Choose root directory: `Cloud_Run_Service/`
6) Service name: `rcm-pipeline-controller`
7) Deploy

Cloud Build will run in background automatically and deploy Cloud Run service.

After deployment you will get a service URL like:
https://rcm-pipeline-controller-xxxxx-uc.a.run.app

---

## 4) Cloud Scheduler Setup (Daily trigger)

Cloud Scheduler triggers Cloud Run daily.

Scheduler details:
- Name: rcm-daily-trigger
- Frequency: every day
- Target: HTTP
- Method: POST
- URL: Cloud Run Service URL

Request body (optional):
{}
Content-Type:
application/json

---

## 5) Check pipeline output

After scheduler triggers pipeline, check in BigQuery:

Bronze tables:
- revcycle_bronze.bronze_patients
- revcycle_bronze.bronze_encounters
- revcycle_bronze.bronze_transactions
- revcycle_bronze.bronze_claims
- revcycle_bronze.bronze_cpt_codes

Silver tables:
- revcycle_silver.dim_patient
- revcycle_silver.fact_encounter
- revcycle_silver.fact_transaction
- revcycle_silver.fact_claim

Gold tables:
- revcycle_gold.gold_revenue_kpis
- revcycle_gold.gold_patients_summary

---

> "I used GitHub-based Cloud Run deployment and Scheduler-based orchestration to run a serverless ETL pipeline on GCP using BigQuery Medallion Architecture."
