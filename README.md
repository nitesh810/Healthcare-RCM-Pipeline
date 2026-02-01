# GCP Healthcare RCM Serverless Data Engineering Project (Medallion)

This is an **end-to-end serverless project on Google Cloud Platform (GCP)** for **Healthcare Revenue Cycle Management (RCM)**.

It demonstrates a ETL pipeline using:

✅ GCS Landing Layer (CSV files)  
✅ Cloud Scheduler (orchestration trigger)  
✅ Cloud Run (pipeline controller deployed from GitHub)  
✅ BigQuery (Bronze → Silver → Gold)  

---

## Project Architecture

Pipeline Flow:

GCS Landing → Cloud Scheduler → Cloud Run → BigQuery Bronze → Silver → Gold

### ASCII Architecture
```txt
+-------------------------------+
| GCS Landing (CSV files)       |
+---------------+---------------+
                |
                v
+-------------------------------+
| Cloud Scheduler (daily POST)  |
+---------------+---------------+
                |
                v
+-------------------------------+
| Cloud Run Pipeline Controller |
| (deploy from GitHub)          |
+---------------+---------------+
                |
                v
+-------------------------------+
| BigQuery Bronze (raw)         |
+---------------+---------------+
                |
                v
+-------------------------------+
| BigQuery Silver (clean/CDM)   |
+---------------+---------------+
                |
                v
+-------------------------------+
| BigQuery Gold (KPIs)          |
+-------------------------------+
