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
 
Cloud Run will run SQL scripts that create tables.

---

## 3) Cloud Run Deployment from GitHub

Deployment method:
Cloud Run → Continuously deploy from a repository (GitHub)

Steps:
1) Push this project code to GitHub repo
2) Go to Cloud Run → Create Service
3) Choose: "Continuously deploy from a repository"
4) Connect GitHub repo
5) Choose root directory: `Cloud_Run_Service/`
6) Service name: `rcm-pipeline-controller`
7) Deploy

Cloud Build will run in background automatically and deploy Cloud Run service.

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

## Cloud Build – CI/CD Flow for Cloud Run (Background Process)

```
Developer Changes Code
(main branch in GitHub)
        │
        │  Only when files are modified:
        │  - main.py
        │  - config/sql_config.json
        │  - SQL files inside BQ/
        │  - Dockerfile / requirements
        ▼
┌──────────────────────────────────────┐
│        Cloud Build Trigger           │
│  (GitHub → Cloud Build Connection)   │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│ Build Steps                          │
│ 1. Pull latest repository            │
│ 2. Build Docker image                │
│ 3. Run container build checks        │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│ Push Image to Artifact Registry      │
│ revcycle-pipeline-image              │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│ Deploy NEW VERSION to Cloud Run      │
│ Service: rcm-pipeline-controller     │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│ Cloud Run Service Updated            │
│ Scheduler triggers latest version    │
└──────────────────────────────────────┘
```

### Important Behavior

- **New Cloud Run deployment happens only when code changes**
- If no file is modified →  
  - Cloud Build does NOT create new image  
  - Existing Cloud Run version continues running

#### Files that cause new deployment

- `Cloud_Run_Service/main.py`
- `config/sql_config.json`
- Any SQL inside `BQ/Bronze`, `BQ/Silver`, `BQ/Gold`
- `Dockerfile`
- `requirements.txt`

#### Files that do NOT trigger deployment

- GCS CSV data changes  
- BigQuery table data changes  
- Scheduler configuration

---

> "Used GitHub-based Cloud Run deployment and Scheduler-based orchestration to run a serverless ETL pipeline on GCP using BigQuery Medallion Architecture."



