# File: GCP-HEALTHCARE-SERVERLESS/Cloud_Run_Service/main.py

# Deployment:
# Cloud Run → Continuously deploy from a repository (GitHub)
# Cloud Build runs in background automatically

# Pipeline Flow:
# GCS Landing → Cloud Scheduler → Cloud Run → BigQuery Bronze → Silver → Gold

import json
from datetime import datetime
from google.cloud import bigquery

PROJECT_ID = "revcycle-lite-gcp"

bq = bigquery.Client(project=PROJECT_ID)

def rcm_pipeline_controller(request):

    current_time = datetime.utcnow().isoformat()

    try:
        # 1. READ CONFIG
        with open("config/sql_config.json", "r") as f:
            config = json.load(f) # reads a JSON file and converts it into a Python dictionary so the program can access values using keys.

        bronze_dataset = config["datasets"]["bronze"]

        # 2. CREATE BRONZE TABLES
        for file in config["bronze_sql_files"]:
            with open(file, "r") as f:
                sql = f.read()
            bq.query(sql).result()

        # 3. LOAD CSV → BRONZE
        for job in config["bronze_load"]:

            gcs_uri = config["gcs_inputs"][job["source"]]

            table_id = (
                PROJECT_ID +
                "." +
                bronze_dataset +
                "." +
                job["target_table"]
            )

            load_config = bigquery.LoadJobConfig(
                source_format="CSV",
                skip_leading_rows=1,
                autodetect=True,
                write_disposition="WRITE_TRUNCATE"
                # WRITE_TRUNCATE deletes existing table data before loading new data.
                # used it in bronze layer to ensure table always reflects latest source files without duplicates.
            )

            bq.load_table_from_uri(
                gcs_uri,
                table_id,
                job_config=load_config
            ).result()
            
        # 4. RUN SILVER SQL
        for file in config["silver_sql_files"]:
            with open(file, "r") as f:
                sql = f.read()
            bq.query(sql).result()

        # 5. RUN GOLD SQL
        for file in config["gold_sql_files"]:
            with open(file, "r") as f:
                sql = f.read()
            bq.query(sql).result()

        return json.dumps({
            "status": "SUCCESS",
            "time": current_time,
            "message": "Bronze → Silver → Gold completed"
        }), 200


    except Exception as e:
        return json.dumps({
            "status": "FAILED",
            "error": str(e)
        }), 500




