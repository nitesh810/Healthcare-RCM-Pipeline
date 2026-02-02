# SCD Type 2 Design (dim_patient)

This document explains how SCD Type 2 is implemented for patient dimension.

Target table:
revcycle_silver.dim_patient

SCD2 goal:
Track history of patient attributes when they change over time.
Example change:
- full_name updated
- gender updated
- dob corrections

Columns used in dim_patient:
- hospital_id
- patient_id
- patient_sk (surrogate key)
- full_name, gender, dob
- record_hash (hash of attributes)
- effective_start_date
- effective_end_date
- is_current

How it works:
1) Compute record_hash for each patient record from bronze
2) Match with current record in dim_patient
3) If hash differs → expire old record (set is_current = false, end_date = run_date-1)
4) Insert new record with new hash (is_current = true, end_date = 9999-12-31)

SCD2 logic (business):
- is_current tells the latest version of patient data
- effective dates track validity period
- patient_sk helps maintain historical joins with facts

Why record_hash:
- avoids comparing every field manually
- faster and cleaner merge logic

Typical query usage:
To get current patient record:
SELECT * FROM revcycle_silver.dim_patient WHERE is_current = TRUE;

To see patient history:
SELECT * FROM revcycle_silver.dim_patient WHERE patient_id = <id> ORDER BY effective_start_date;

