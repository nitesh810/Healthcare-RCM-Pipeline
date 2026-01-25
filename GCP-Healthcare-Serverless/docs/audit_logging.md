# Audit Logging (Optional Enhancement)

Audit logging helps in:
- tracking pipeline runs
- debugging failures
- monitoring number of rows loaded

This project is kept simple and serverless.
Audit logging is optional but interview-friendly.

---

## What can be logged?

For each pipeline run, you can log:

- batch_id / run_id
- start_time
- end_time
- status (SUCCESS / FAILED)
- step_name
- rows_loaded
- error_message

---

## Where to store logs?

Option 1: BigQuery audit table
- audit_dataset.etl_audit_log

Option 2: Cloud Logging
- logs are automatically available from Cloud Run

---

## Example BigQuery audit table schema

Columns:
- run_id STRING
- step_name STRING
- status STRING
- rows_loaded INT64
- start_time TIMESTAMP
- end_time TIMESTAMP
- error_message STRING

---

## Interview line

> "Audit logging can be implemented using BigQuery audit tables and Cloud Logging to track run status, step-level metrics, and debugging information."
