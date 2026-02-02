# GCP Healthcare RCM Serverless Data Engineering Project (Medallion)

This is an **end-to-end serverless project on Google Cloud Platform (GCP)** for **Healthcare Revenue Cycle Management (RCM)**.

It demonstrates a ETL pipeline using:

GCS Landing Layer (CSV files)  
Cloud Scheduler (orchestration trigger)  
Cloud Run (pipeline controller deployed from GitHub)  
BigQuery (Bronze → Silver → Gold)  

---

## Project Architecture

Pipeline Flow:

GCS Landing → Cloud Scheduler → Cloud Run → BigQuery Bronze → Silver → Gold


## Architecture Flow

```
+---------------------------+
|        GCS LANDING        |
|  hospital-a / hospital-b  |
|  - patients.csv           |
|  - encounters.csv         |
|  - transactions.csv       |
|  claims/*.csv             |
|  cpt_codes.csv            |
+------------+--------------+
             |
             v
+---------------------------+
|     Cloud Scheduler       |
|   (daily HTTP trigger)    |
+------------+--------------+
             |
             v
+---------------------------+
|        Cloud Run          |
|   Pipeline Controller     |
|      (main.py)            |
+------------+--------------+
             |
             v
+---------------------------+
|   BigQuery BRONZE         |
|  revcycle_bronze          |
|  - bronze_patients        |
|  - bronze_encounters      |
|  - bronze_transactions    |
|  - bronze_claims          |
|  - bronze_cpt_codes       |
+------------+--------------+
             |
             v
+---------------------------+
|   BigQuery SILVER         |
|  revcycle_silver          |
|  - dim_patient (SCD2)     |
|  - fact_encounter         |
|  - fact_transaction       |
|  - fact_claim             |
+------------+--------------+
             |
             v
+---------------------------+
|    BigQuery GOLD          |
|  revcycle_gold            |
|  - gold_revenue_kpis      |
|  - gold_patients_summary  |
+---------------------------+
```


