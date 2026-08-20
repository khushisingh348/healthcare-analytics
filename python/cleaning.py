import pandas as pd

# ==========================================
# 1. LOAD DATA
# ==========================================

df = pd.read_csv("healthcare_dataset.csv")

print("Original Shape:", df.shape)


# ==========================================
# 2. REMOVE DUPLICATES
# ==========================================

print("Duplicate Rows:", df.duplicated().sum())

df = df.drop_duplicates()

print("Shape After Removing Duplicates:", df.shape)


# ==========================================
# 3. CLEAN COLUMN NAMES
# ==========================================

df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
)

print("\nCleaned Columns:")
print(df.columns.tolist())


# ==========================================
# 4. CLEAN TEXT COLUMNS
# ==========================================

text_columns = [
    "gender",
    "blood_type",
    "medical_condition",
    "doctor",
    "hospital",
    "insurance_provider",
    "admission_type",
    "medication",
    "test_results"
]

for column in text_columns:
    df[column] = df[column].astype(str).str.strip()


# ==========================================
# 5. STANDARDIZE CATEGORICAL VALUES
# ==========================================

df["gender"] = df["gender"].str.title()

df["blood_type"] = df["blood_type"].str.upper()

df["medical_condition"] = df["medical_condition"].str.title()

df["admission_type"] = df["admission_type"].str.title()

df["medication"] = df["medication"].str.title()

df["test_results"] = df["test_results"].str.title()


# ==========================================
# 6. CONVERT DATE COLUMNS
# ==========================================

df["date_of_admission"] = pd.to_datetime(
    df["date_of_admission"],
    errors="coerce"
)

df["discharge_date"] = pd.to_datetime(
    df["discharge_date"],
    errors="coerce"
)


# ==========================================
# 7. CREATE LENGTH OF STAY
# ==========================================

df["length_of_stay"] = (
    df["discharge_date"] -
    df["date_of_admission"]
).dt.days


# ==========================================
# 8. CREATE PATIENT/VISIT ID
# ==========================================

df.insert(
    0,
    "patient_visit_id",
    range(1, len(df) + 1)
)


# ==========================================
# 9. CREATE AGE GROUP
# ==========================================

bins = [0, 18, 30, 45, 60, 75, 120]

labels = [
    "0-18",
    "19-30",
    "31-45",
    "46-60",
    "61-75",
    "76+"
]

df["age_group"] = pd.cut(
    df["age"],
    bins=bins,
    labels=labels,
    include_lowest=True
)


# ==========================================
# 10. CREATE DATE ATTRIBUTES
# ==========================================

df["admission_year"] = (
    df["date_of_admission"].dt.year
)

df["admission_month"] = (
    df["date_of_admission"].dt.month
)

df["admission_month_name"] = (
    df["date_of_admission"].dt.strftime("%B")
)

df["admission_quarter"] = (
    "Q" +
    df["date_of_admission"]
    .dt.quarter
    .astype(str)
)

# ==========================================
# MOVE ALL NEW CALCULATED COLUMNS TO THE END
# ==========================================

new_columns = [
    "patient_visit_id",
    "length_of_stay",
    "age_group",
    "admission_year",
    "admission_month",
    "admission_month_name",
    "admission_quarter"
]

original_columns = [
    col for col in df.columns
    if col not in new_columns
]

df = df[original_columns + new_columns]

# ==========================================
# BILLING QUALITY FLAG
# ==========================================

df["billing_status"] = df["billing_amount"].apply(
    lambda x: "Negative / Adjustment" if x < 0 else "Valid Billing"
)
df["valid_billing_amount"] = df["billing_amount"].apply(
    lambda x: x if x >= 0 else 0
)
# ==========================================
# 11. CHECK MISSING VALUES AFTER CLEANING
# ==========================================

print("\nMissing Values After Cleaning:")

print(df.isnull().sum())


# ==========================================
# 12. FINAL DATASET INFORMATION
# ==========================================

print("\nFinal Shape:")
print(df.shape)

print("\nFinal Data Types:")
print(df.dtypes)


# ==========================================
# 13. SAVE CLEANED CSV
# ==========================================

df.to_csv(
    "healthcare_cleaned.csv",
    index=False
)

print("\nCleaned CSV saved successfully!")

# ==========================================
# SAVE EXCEL FILE
# ==========================================

df.to_excel(
    "healthcare_cleaned.xlsx",
    index=False
)

print("Cleaned Excel file saved successfully!")

# ==========================================
# FINAL MESSAGE
# ==========================================

print("\n==========================================")
print("DATA CLEANING COMPLETED")
print("==========================================")
