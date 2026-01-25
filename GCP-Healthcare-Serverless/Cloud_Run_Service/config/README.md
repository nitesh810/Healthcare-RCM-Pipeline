# config folder

This folder contains configuration files used by the Cloud Run service.

---

## sql_config.json

This file is read by:
Cloud_Run_Service/main.py

It contains:
- GCS input paths for landing data
- Bronze table load mapping
- SQL file execution order for Bronze schema
- SQL file execution order for Silver transforms
- SQL file execution order for Gold KPIs

So the pipeline is config-driven and easy to maintain.
