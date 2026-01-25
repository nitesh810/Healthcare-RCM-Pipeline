# File: GCP-HEALTHCARE-SERVERLESS/Cloud_Run_Service/main.py

# Deployment:
# Cloud Run → Continuously deploy from a repository (GitHub)
# Cloud Build runs in background automatically

# Final Pipeline Flow:
# GCS Landing → Cloud Scheduler → Cloud Run → BigQuery Bronze → Silver → Gold

import os
import json
from datetime import datetime
from google.cloud import bigquery

PROJECT_ID = "revcycle-lite-gcp"
BUCKET_NAME = "revcycle-lite-bucket"
BRONZE_DATASET = "revcycle_bronze"

# path to config file
SQL_CONFIG_PATH = os.path.join(os.path.dirname(__file__), "config", "sql_config.json")

# ✅ SIMPLE: project root directory
# __file__ = Cloud_Run_Service/main.py
# dirname(__file__) = Cloud_Run_Service/
# dirname(dirname(__file__)) = project root folder
ROOT_DIR = os.path.dirname(os.path.dirname(__file__))


def rcm_pipeline_controller(request):
    current_time = datetime.utcnow().isoformat()

    try:
        bq = bigquery.Client(project=PROJECT_ID)

        # read config json
        with open(SQL_CONFIG_PATH, "r", encoding="utf-8") as f:
            config = json.load(f)

        # 0) Create bronze tables schema (create or replace)
        for sql_file in config["bronze_sql_files"]:
            sql_path = os.path.join(ROOT_DIR, sql_file)   
            with open(sql_path, "r", encoding="utf-8") as f:
                sql_text = f.read()
            bq.query(sql_text).result()

        # 1) Bronze load (GCS -> BigQuery Bronze)
        for job in config["bronze_load"]:
            gcs_uri = config["gcs_inputs"][job["source"]]
            target_table = f"{PROJECT_ID}.{BRONZE_DATASET}.{job['target_table']}"

            job_config = bigquery.LoadJobConfig(
                source_format=bigquery.SourceFormat.CSV,
                skip_leading_rows=int(job.get("skip_leading_rows", 1)),
                autodetect=True,
                write_disposition=job.get("write_disposition", "WRITE_TRUNCATE")
            )

            bq.load_table_from_uri(
                gcs_uri,
                target_table,
                job_config=job_config
            ).result()

        # 2) Silver SQL execution
        for sql_file in config["silver_sql_files"]:
            sql_path = os.path.join(ROOT_DIR, sql_file)   # ✅ simplified path
            with open(sql_path, "r", encoding="utf-8") as f:
                sql_text = f.read()
            bq.query(sql_text).result()

        # 3) Gold SQL execution
        for sql_file in config["gold_sql_files"]:
            sql_path = os.path.join(ROOT_DIR, sql_file)   # ✅ simplified path
            with open(sql_path, "r", encoding="utf-8") as f:
                sql_text = f.read()
            bq.query(sql_text).result()

        return (
            json.dumps({
                "status": "SUCCESS",
                "time_utc": current_time,
                "message": "Pipeline completed: GCS -> Bronze -> Silver -> Gold"
            }),
            200,
            {"Content-Type": "application/json"}
        )

    except Exception as e:
        return (
            json.dumps({
                "status": "FAILED",
                "time_utc": current_time,
                "error": str(e)
            }),
            500,
            {"Content-Type": "application/json"}
        )
