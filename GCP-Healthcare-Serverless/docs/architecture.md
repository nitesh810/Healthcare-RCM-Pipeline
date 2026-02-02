# Architecture

This project uses a serverless pipeline architecture.

---

## Architecture Flow

GCS Landing → Cloud Scheduler → Cloud Run → BigQuery Bronze → Silver → Gold

---

## ASCII Diagram

```
┌──────────────────────────────────────────────────────────────────┐
│                     GCS LANDING LAYER                            │
│  gs://revcycle-lite-bucket/landing/                              │
│                                                                  │
│  ├── hospital-a/                                                 │
│  │     ├── patients/*.csv                                        │
│  │     ├── encounters/*.csv                                      │
│  │     └── transactions/*.csv                                    │
│  │                                                               │
│  ├── hospital-b/                                                 │
│  │     ├── patients/*.csv                                        │
│  │     ├── encounters/*.csv                                      │
│  │     └── transactions/*.csv                                    │
│  │                                                               │
│  ├── claims/YYYY/MM/*.csv                                        │
│  └── cptcodes/cpt_codes.csv                                      │
└──────────────────────────────────────────────────────────────────┘
                              │
                              │ Daily Trigger
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                        CLOUD SCHEDULER                           │
│                     Job: rcm-daily-trigger                       │
└──────────────────────────────────────────────────────────────────┘
                              │ HTTP POST
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                        CLOUD RUN SERVICE                         │
│                  rcm-pipeline-controller                         │
│                Cloud_Run_Service/main.py                         │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                     BIGQUERY – BRONZE LAYER                      │
│                   Dataset: revcycle_bronze                       │
│                (Raw copy of source files)                        │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                     BIGQUERY – SILVER LAYER                      │
│                   Dataset: revcycle_silver                       │
│          SCD2 Dimensions | Facts | Cleansed Model                │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                      BIGQUERY – GOLD LAYER                       │
│                    Dataset: revcycle_gold                        │
│            KPIs | Aggregates | Reporting Mart                    │
└──────────────────────────────────────────────────────────────────┘
```

## Key Notes

- All source data comes from GCS landing layer
- Cloud Scheduler triggers daily pipeline run
- Cloud Run executes BigQuery loads and SQL scripts
- Bronze/Silver/Gold tables are created using `CREATE OR REPLACE`





