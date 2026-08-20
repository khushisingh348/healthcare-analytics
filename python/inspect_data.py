import pandas as pd

# Load dataset
df = pd.read_csv("healthcare_dataset.csv")

print("=" * 60)
print("HOSPITAL DATASET INSPECTION")
print("=" * 60)

# 1. Dataset shape
print("\n1. DATASET SHAPE")
print(df.shape)

# 2. Column names
print("\n2. COLUMN NAMES")
print(df.columns.tolist())

# 3. Data types
print("\n3. DATA TYPES")
print(df.dtypes)

# 4. Missing values
print("\n4. MISSING VALUES")
print(df.isnull().sum())

# 5. Duplicate records
print("\n5. DUPLICATE RECORDS")
print(df.duplicated().sum())

# 6. First 5 records
print("\n6. FIRST 5 RECORDS")
print(df.head())

# 7. Numerical statistics
print("\n7. NUMERICAL STATISTICS")
print(df.describe())

# 8. Unique values in categorical columns
print("\n8. UNIQUE VALUES")

categorical_columns = [
    "Gender",
    "Blood Type",
    "Medical Condition",
    "Admission Type",
    "Medication",
    "Test Results"
]

for column in categorical_columns:
    print(f"\n{column}:")
    print(df[column].unique())

print("\n" + "=" * 60)
print("INSPECTION COMPLETED")
print("=" * 60)