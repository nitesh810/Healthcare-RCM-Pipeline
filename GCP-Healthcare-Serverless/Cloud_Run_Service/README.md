# Cloud_Run_Service (Cloud Run Pipeline Controller)

This folder contains the **Cloud Run Function** that runs the complete pipeline.

Deployment:

Cloud Run → Continuously deploy from a repository (GitHub).       
Cloud Build runs in background automatically.

Trigger:

Cloud Scheduler triggers this Cloud Run endpoint daily (HTTP POST).

---

## What this service does

Pipeline Flow:
GCS Landing → Cloud Scheduler → Cloud Run → BigQuery Bronze → Silver → Gold

### Step 1: Bronze load (GCS → BigQuery)
Loads these GCS landing files:

#### Hospital data (CSV)
- hospital-a patients/encounters/transactions
- hospital-b patients/encounters/transactions

#### Claims data (CSV)
Monthly snapshot:
- claim_hospital_a_YYYYMM.csv
- claim_hospital_b_YYYYMM.csv

#### CPT codes (CSV)
Reference:
- cpt_codes.csv

---

## BigQuery output

Bronze dataset:
- revcycle_bronze

Silver dataset:
- revcycle_silver

Gold dataset:
- revcycle_gold

---

## Config-driven pipeline

The service reads config from:
Cloud_Run_Service/config/sql_config.json

Config controls:
- GCS input paths
- Bronze load tables
- SQL file execution order




