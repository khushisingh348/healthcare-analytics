CREATE DATABASE healthcare_analysis;
USE healthcare_analysis;
SELECT DATABASE();
CREATE TABLE healthcare (
    patient_visit_id INT PRIMARY KEY,
    patient_id VARCHAR(50),
    age INT,
    gender VARCHAR(20),
    blood_type VARCHAR(10),
    medical_condition VARCHAR(100),
    date_of_admission DATE,
    doctor VARCHAR(150),
    hospital VARCHAR(200),
    insurance_provider VARCHAR(100),
    billing_amount DECIMAL(12,2),
    room_number INT,
    admission_type VARCHAR(50),
    discharge_date DATE,
    medication VARCHAR(100),
    test_results VARCHAR(100)
);
SHOW TABLES;
DESCRIBE healthcare;
USE healthcare_analysis;

SELECT COUNT(*) AS total_records
FROM healthcare_cleaned;

SELECT *
FROM healthcare_cleaned
LIMIT 10;

DESCRIBE healthcare_cleaned;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'healthcare_analysis'
  AND TABLE_NAME = 'healthcare_cleaned'
ORDER BY ORDINAL_POSITION;

SELECT COUNT(*) AS total_records
FROM healthcare_cleaned;

SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'healthcare_analysis'
  AND TABLE_NAME = 'healthcare_cleaned';

SELECT *
FROM healthcare_cleaned
LIMIT 10;

SELECT
    COUNT(DISTINCT Gender) AS unique_genders,
    COUNT(DISTINCT Medical_Condition) AS unique_conditions,
    COUNT(DISTINCT Hospital) AS unique_hospitals,
    COUNT(DISTINCT Insurance_Provider) AS unique_insurance_providers
FROM healthcare_cleaned;

SELECT Hospital, COUNT(*) AS patient_count
FROM healthcare_cleaned
GROUP BY Hospital
ORDER BY patient_count DESC
LIMIT 20;

SELECT
    Gender,
    COUNT(*) AS patient_count
FROM healthcare_cleaned
GROUP BY Gender
ORDER BY patient_count DESC;

SELECT
    CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 45 THEN '31-45'
        WHEN Age BETWEEN 46 AND 60 THEN '46-60'
        WHEN Age >= 61 THEN '61+'
        ELSE 'Unknown'
    END AS age_group,
    COUNT(*) AS patient_count
FROM healthcare_cleaned
GROUP BY
    CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 45 THEN '31-45'
        WHEN Age BETWEEN 46 AND 60 THEN '46-60'
        WHEN Age >= 61 THEN '61+'
        ELSE 'Unknown'
    END
ORDER BY patient_count DESC;

SELECT
    ROUND(AVG(Age), 2) AS average_age,
    MIN(Age) AS minimum_age,
    MAX(Age) AS maximum_age
FROM healthcare_cleaned;

SELECT
    Blood_Type,
    COUNT(*) AS patient_count
FROM healthcare_cleaned
GROUP BY Blood_Type
ORDER BY patient_count DESC;

SELECT
    Medical_Condition,
    COUNT(*) AS patient_count
FROM healthcare_cleaned
GROUP BY Medical_Condition
ORDER BY patient_count DESC;

SELECT
    Medical_Condition,
    COUNT(*) AS patient_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM healthcare_cleaned),
        2
    ) AS percentage
FROM healthcare_cleaned
GROUP BY Medical_Condition
ORDER BY patient_count DESC;

SELECT
    Admission_Type,
    COUNT(*) AS patient_count
FROM healthcare_cleaned
GROUP BY Admission_Type
ORDER BY patient_count DESC;

SELECT
    Admission_Type,
    COUNT(*) AS patient_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM healthcare_cleaned),
        2
    ) AS percentage
FROM healthcare_cleaned
GROUP BY Admission_Type
ORDER BY patient_count DESC;

SELECT
    YEAR(Date_of_Admission) AS admission_year,
    COUNT(*) AS admissions
FROM healthcare_cleaned
GROUP BY YEAR(Date_of_Admission)
ORDER BY admission_year;

SELECT
    ROUND(AVG(DATEDIFF(Discharge_Date, Date_of_Admission)), 2) AS avg_length_of_stay,
    MIN(DATEDIFF(Discharge_Date, Date_of_Admission)) AS min_length_of_stay,
    MAX(DATEDIFF(Discharge_Date, Date_of_Admission)) AS max_length_of_stay
FROM healthcare_cleaned;

SELECT
    ROUND(SUM(Billing_Amount), 2) AS total_billing,
    ROUND(AVG(Billing_Amount), 2) AS average_bill,
    ROUND(MIN(Billing_Amount), 2) AS minimum_bill,
    ROUND(MAX(Billing_Amount), 2) AS maximum_bill
FROM healthcare_cleaned;

SELECT
    Medical_Condition,
    COUNT(*) AS patient_count,
    ROUND(SUM(Billing_Amount), 2) AS total_billing,
    ROUND(AVG(Billing_Amount), 2) AS average_bill
FROM healthcare_cleaned
GROUP BY Medical_Condition
ORDER BY total_billing DESC;

SELECT
    Insurance_Provider,
    COUNT(*) AS patient_count,
    ROUND(SUM(Billing_Amount), 2) AS total_billing,
    ROUND(AVG(Billing_Amount), 2) AS average_bill
FROM healthcare_cleaned
GROUP BY Insurance_Provider
ORDER BY total_billing DESC;
SELECT
    Doctor,
    COUNT(*) AS patient_count
FROM healthcare_cleaned
GROUP BY Doctor
ORDER BY patient_count DESC
LIMIT 10;

SELECT
    Hospital,
    COUNT(*) AS patient_count
FROM healthcare_cleaned
GROUP BY Hospital
ORDER BY patient_count DESC
LIMIT 10;
SELECT
    Hospital,
    COUNT(*) AS patient_count,
    ROUND(SUM(Billing_Amount), 2) AS total_billing
FROM healthcare_cleaned
GROUP BY Hospital
ORDER BY total_billing DESC
LIMIT 10;
SELECT
    Medication,
    COUNT(*) AS patient_count
FROM healthcare_cleaned
GROUP BY Medication
ORDER BY patient_count DESC;

SELECT
    Test_Results,
    COUNT(*) AS patient_count
FROM healthcare_cleaned
GROUP BY Test_Results
ORDER BY patient_count DESC;

SELECT
    Medical_Condition,
    Test_Results,
    COUNT(*) AS patient_count
FROM healthcare_cleaned
GROUP BY Medical_Condition, Test_Results
ORDER BY Medical_Condition, patient_count DESC;

SELECT
    COUNT(*) AS total_patients,
    ROUND(AVG(Age), 2) AS average_age,
    ROUND(AVG(DATEDIFF(Discharge_Date, Date_of_Admission)), 2) AS avg_length_of_stay,
    ROUND(SUM(Billing_Amount), 2) AS total_billing,
    ROUND(AVG(Billing_Amount), 2) AS average_billing
FROM healthcare_cleaned;

CREATE OR REPLACE VIEW vw_condition_analysis AS
SELECT
    Medical_Condition,
    COUNT(*) AS patient_count,
    ROUND(SUM(Billing_Amount), 2) AS total_billing,
    ROUND(AVG(Billing_Amount), 2) AS average_billing
FROM healthcare_cleaned
GROUP BY Medical_Condition;

SELECT *
FROM vw_condition_analysis
ORDER BY patient_count DESC;

CREATE OR REPLACE VIEW vw_admission_analysis AS
SELECT
    Admission_Type,
    COUNT(*) AS patient_count
FROM healthcare_cleaned
GROUP BY Admission_Type;

SELECT *
FROM vw_admission_analysis
ORDER BY patient_count DESC;

CREATE OR REPLACE VIEW vw_insurance_analysis AS
SELECT
    Insurance_Provider,
    COUNT(*) AS patient_count,
    ROUND(SUM(Billing_Amount), 2) AS total_billing,
    ROUND(AVG(Billing_Amount), 2) AS average_billing
FROM healthcare_cleaned
GROUP BY Insurance_Provider;

SELECT *
FROM vw_insurance_analysis
ORDER BY total_billing DESC;