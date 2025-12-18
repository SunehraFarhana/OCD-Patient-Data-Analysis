# OCD Patient Data Analysis
Documentation of a comprehensive portfolio project that uses Python, SQL, and Tableau to interpret and visualize healthcare data.

---
## Table of Contents
1. [Project Overview](#project-overview)
2. [Dataset Summary](#dataset-summary)
3. [Data Cleaning in **Python**](#data-cleaning-in-python)
4. [Exploratory Data Analysis in **MySQL Workbench**](#exploratory-data-analysis-in-mysql-workbench)
5. [Visualizations in **Tableau Public**](#visualizations-in-tableau-public)
6. [Project Insight and Recommendations](#project-insight-and-recommendations)
7. [Conclusion](#conclusion)

---
## Project Overview
This project aims to analyze a healthcare dataset that contains comprehensive data from 1,500 patients diagnosed with Obsessive-Compulsive Disorder (OCD). The goal of this project is to uncover meaningful insights about the severity of OCD symptoms, and its relation to clinical and demographic factors.

---
## Dataset Summary
The Kaggle dataset can be found [**here**](https://www.kaggle.com/datasets/ohinhaque/ocd-patient-dataset-demographics-and-clinical-data/). This csv file has 1500 rows and 17 columns.
- **Demographic Data:** Patient ID, Age, Gender, Ethnicity, Marital Status, Education Level
- **Clinical Data:** OCD Diagnosis Date, Duration of Symptoms (months), Previous Diagnoses, Family History of OCD, Obsession Type, Compulsion Type, Y-BOCS Score (Obsessions), Y-BOCS Score (Compulsions), Depression Diagnosis, Anxiety Diagnosis, Medications

---
## Data Cleaning in Python
This dataset was fairly clean, so only a few adjustments needed to be made.

1. Standardize the column names by converting all letters to lowercase, removing any leading/trailing whitespace and parentheses, and replacing dashes/spaces with underscores.
```python
# Standardize column names
df.columns = (df.columns
    .str.lower()
    .str.strip()
    .str.replace(" ", "_")
    .str.replace("-", "_")
    .str.replace("(", "")
    .str.replace(")", "")
)

df.columns
```

2. Standardize the rows by making sure all words are in title case, any inputs of F/M are changed to Female/Male, any inputs of Y/N are changed to Yes/No, and the abbreviated form of medications are used.
```python
# Maintain consistency in gender column
df['gender'] = df['gender'].str.title().replace({'M': 'Male', 'F': 'Female'})

# Maintain consistency in depression_diagnosis and anxiety_diagnosis columns
df['depression_diagnosis'] = df['depression_diagnosis'].str.title().replace({'Y': 'Yes', 'N': 'No'})
df['anxiety_diagnosis'] = df['anxiety_diagnosis'].str.title().replace({'Y': 'Yes', 'N': 'No'})

# Maintain consistency in medications column
df['medications'] = df['medications'].replace({'Benzodiazepine': 'BZD'})
```

An in-depth [**Jupyter Notebook**](https://github.com/SunehraFarhana/OCD-Patient-Data-Analysis/blob/4e8fa1112cfa177646a6fe915c7f3a1919d2acb2/ocd_patient_cleaning.ipynb) detailing every step of the data cleaning process is available in this repository.

---
## Exploratory Data Analysis in MySQL Workbench
1. What is the most common medication taken by patients?
```sql
SELECT
    medications,
    COUNT(patient_id) AS patient_count
FROM ocd_patient_schema.cleaned_ocd_patient_dataset
GROUP BY 1
ORDER BY 2;
```
<img width="162" height="106" alt="ocd_patient_sql_1" src="https://github.com/user-attachments/assets/9f57dc81-33ca-4f6b-b47b-012e3a749322" />

2. The dataset contains each patient's **Y-BOCS (Yale-Brown Obsessive Compulsive Scale) Scores**, which measures the severity of their obsessions and compulsions, so that their symptoms may be classified as subclinical, mild, moderate, severe, or extreme. Sort the obsession scores into categories. What is the number of patients in each category?
```sql
SELECT
    y_bocs_score_obsessions_category,
    COUNT(*) AS patient_count
FROM (
    SELECT
        CASE
            WHEN y_bocs_score_obsessions BETWEEN 0 AND 7 THEN 'Subclinical'
            WHEN y_bocs_score_obsessions BETWEEN 8 AND 15 THEN 'Mild'
            WHEN y_bocs_score_obsessions BETWEEN 16 AND 23 THEN 'Moderate'
            WHEN y_bocs_score_obsessions BETWEEN 24 AND 31 THEN 'Severe'
            WHEN y_bocs_score_obsessions BETWEEN 32 AND 40 THEN 'Extreme'
            ELSE 'Invalid Score'
        END AS y_bocs_score_obsessions_category
    FROM ocd_patient_schema.cleaned_ocd_patient_dataset
) AS obsessions_category_table
GROUP BY y_bocs_score_obsessions_category
ORDER BY 
    CASE
        WHEN y_bocs_score_obsessions_category = 'Subclinical' THEN 1
        WHEN y_bocs_score_obsessions_category = 'Mild' THEN 2
        WHEN y_bocs_score_obsessions_category = 'Moderate' THEN 3
        WHEN y_bocs_score_obsessions_category = 'Severe' THEN 4
        WHEN y_bocs_score_obsessions_category = 'Extreme' THEN 5
        ELSE 6
    END;
```
<img width="288" height="120" alt="ocd_patient_sql_2" src="https://github.com/user-attachments/assets/a7ac2632-e203-4476-a255-42c205e990e0" />

3. What is the average obsession score and compulsion score by ethnicity?
```sql
SELECT
  ethnicity,
  COUNT(patient_id) AS patient_count,
  ROUND(AVG(y_bocs_score_obsessions),2) AS avg_obsession_by_ethnicity,
  ROUND(AVG(y_bocs_score_compulsions),2) AS avg_compulsion_by_ethnicity
FROM ocd_patient_schema.cleaned_ocd_patient_dataset
GROUP BY 1
ORDER BY 2;
```
<img width="475" height="106" alt="ocd_patient_sql_3" src="https://github.com/user-attachments/assets/06100f42-d64e-4c6b-bfef-59371a594104" />

4. What is the most common obsession type by each gender?
```sql
WITH obsession_by_gender AS (
    SELECT
        gender,
        obsession_type,
        COUNT(*) AS patient_count
    FROM ocd_patient_schema.cleaned_ocd_patient_dataset
    GROUP BY gender, obsession_type
)
SELECT
    gender,
    obsession_type,
    patient_count
FROM obsession_by_gender
ORDER BY 1, 3 DESC;
```
<img width="228" height="196" alt="ocd_patient_sql_4" src="https://github.com/user-attachments/assets/fd1ec1cf-5aa8-4ac2-a3df-f35d34f6c627" />

An in-depth [**SQL file**](https://github.com/SunehraFarhana/OCD-Patient-Data-Analysis/blob/29351dc5ead63f46b6a46c8cefd48583cb24d497/ocd_patient_queries.sql) detailing every step of the querying process is available in this repository.

---
## Visualizations in Tableau Public
The Tableau Public visualizations can be found [**here**](https://public.tableau.com/views/ocd_patient_visualizations/Dashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link). The data was organized into an interactive dashboard that allows clinicians or mental health researchers to  observe OCD trends among this sample set of patients. Viewers can easily toggle between the age group, gender, and ethnicity filters. They can also filter by OCD diagnosis date, obsession/compulsion category, medication taken, or whether there is a family history of OCD, by clicking its respective section on the dashboard.

<img width="1249" height="649" alt="ocd_patient_visualizations_dashboard" src="https://github.com/user-attachments/assets/8e17bd6c-03d3-4f20-b99d-6717137712ec" />

For example, a medical professional who wants to observe the effectiveness of benzodiazepine on older patients could simply click "BZD" on the Medications bar graph, and then select "Elderly" underneath the Age Group filter. The entire dashboard would adjust to only show the clinical data of patients within these categories, including the intensity of their obsessive and compulsive behavior.

---
## Project Insight and Recommendations
The most common obsession type by gender is harm-related. Also, the heat map comparing obsession types to compulsion types shows a strong correlation between harm-related behavior, and counting and praying. Since this is a prevalent problem, clinics must prioritize finding a safe way for patients to treat these impulses.

In addition, a majority of patients fell into the "Extreme" categories of obsession and compulsion. Also, benzodiazepine was the most common medication. Therefore, medical professionals must allocate enough resources towards treating extreme cases of OCD.

OCD researchers would be interested to know that according to this dataset, African patients had the lowest obsession and compulsion scores among ethnicities, men had lower obsession scores than women, and young adults had lower compulsion scores compared to older patients. It should be investigated if any environmental factors within these demographics resulted in less severe cases of OCD.

---
## Conclusion
This project illustrates OCD patient data in a way that is easy to interpret and filter through. The clinical and demographic data revealed what obsessive and compulsive behaviors are most popular among patients, and which demographics experienced OCD with lower severity. Medical professionals and researchers may use this data to determine the best way to treat individuals with OCD.
