# Architecture

This project uses a serverless pipeline architecture.

---

## Architecture Flow

GCS Landing → Cloud Scheduler → Cloud Run → BigQuery Bronze → Silver → Gold

---

## ASCII Diagram

GCS Landing Layer  
gs://revcycle-lite-bucket/landing/  
                                  
hospital-a/patients/*.csv                        
hospital-a/encounters/*.csv                     
hospital-a/transactions/*.csv                    
hospital-b/...                                   
claims/YYYY/MM/*.csv                             
cptcodes/cpt_codes.csv                           
          |
          | Daily trigger
          v
Cloud Scheduler                     
Job: rcm-daily-trigger              
          |
          | HTTP POST
          v
Cloud Run Pipeline Controller    
Service: rcm-pipeline-controller 
Code: Cloud_Run_Service/main.py  
          |
          v
BigQuery Bronze (RAW)   
Dataset: revcycle_bronze
          |
          v
BigQuery Silver (Clean/CDM)              
Dataset: revcycle_silver                 
          |
          v
BigQuery Gold (Business KPIs)            
Dataset: revcycle_gold                   

---

## Key Notes

- All source data comes from GCS landing layer
- Cloud Scheduler triggers daily pipeline run
- Cloud Run executes BigQuery loads and SQL scripts
- Bronze/Silver/Gold tables are created using `CREATE OR REPLACE`



