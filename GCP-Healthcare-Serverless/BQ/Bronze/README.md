# Bronze Layer (revcycle_bronze)

Bronze layer = **raw ingestion layer** in BigQuery.

Bronze contains raw data loaded from GCS landing without transformations.

---

## Dataset
`revcycle_bronze`

---

## Bronze Tables

### 1) bronze_patients
Raw patients data for both hospitals.

Source:
- gs://revcycle-lite-bucket/landing/hospital-a/patients/*.csv
- gs://revcycle-lite-bucket/landing/hospital-b/patients/*.csv

---

### 2) bronze_encounters
Raw encounter data for both hospitals.

Source:
- gs://revcycle-lite-bucket/landing/hospital-a/encounters/*.csv
- gs://revcycle-lite-bucket/landing/hospital-b/encounters/*.csv

---

### 3) bronze_transactions
Raw transaction data for both hospitals.

Source:
- gs://revcycle-lite-bucket/landing/hospital-a/transactions/*.csv
- gs://revcycle-lite-bucket/landing/hospital-b/transactions/*.csv

---

### 4) bronze_claims
Monthly claims snapshot data.

Source:
- gs://revcycle-lite-bucket/landing/claims/YYYY/MM/*.csv

---

### 5) bronze_cpt_codes
Reference CPT codes file.

Source:
- gs://revcycle-lite-bucket/landing/cptcodes/cpt_codes.csv

---

## Notes
- Tables are created using `CREATE OR REPLACE` (schema always updated if changes happen)
- Tables are loaded using BigQuery Load Job
- `WRITE_TRUNCATE` is used to refresh bronze each pipeline run
