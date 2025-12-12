-- 1. What is the number of patients diagnosed with OCD per month?
SELECT
	DATE_FORMAT(ocd_diagnosis_date, '%Y-%m-01 00:00:00') AS month,
	COUNT(patient_id) AS patient_count
FROM ocd_patient_schema.cleaned_ocd_patient_dataset
GROUP BY 1
ORDER BY 1;


# -- 2. What is the most common medication taken by patients?
SELECT
    medications,
	COUNT(patient_id) AS patient_count
FROM ocd_patient_schema.cleaned_ocd_patient_dataset
GROUP BY 1
ORDER BY 2;


-- 3. What is the number of patients with a family history of OCD?
SELECT
    family_history_of_ocd,
	COUNT(patient_id) AS patient_count
FROM ocd_patient_schema.cleaned_ocd_patient_dataset
GROUP BY 1
ORDER BY 2;


-- 4. What is the average obsession and compulsion score by gender?
SELECT
	gender,
	COUNT(patient_id) AS patient_count,
	ROUND(AVG(y_bocs_score_obsessions),2) AS avg_obsession_by_gender,
    ROUND(AVG(y_bocs_score_compulsions),2) AS avg_compulsion_by_gender
FROM ocd_patient_schema.cleaned_ocd_patient_dataset
GROUP BY 1
ORDER BY 2;


-- 5. What is the average obsession score and compulsion score by ethnicity?
SELECT
	ethnicity,
	COUNT(patient_id) AS patient_count,
	ROUND(AVG(y_bocs_score_obsessions),2) AS avg_obsession_by_ethnicity,
    ROUND(AVG(y_bocs_score_compulsions),2) AS avg_compulsion_by_ethnicity
FROM ocd_patient_schema.cleaned_ocd_patient_dataset
GROUP BY 1
ORDER BY 2;


-- 6. Sort the obsession scores into categories.
-- What is the number of patients in each category?
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


-- 7. Sort the compulsion scores into categories.
-- What is the number of patients in each category?
SELECT
    y_bocs_score_compulsions_category,
    COUNT(*) AS patient_count
FROM (
    SELECT
        CASE
            WHEN y_bocs_score_compulsions BETWEEN 0 AND 7 THEN 'Subclinical'
            WHEN y_bocs_score_compulsions BETWEEN 8 AND 15 THEN 'Mild'
            WHEN y_bocs_score_compulsions BETWEEN 16 AND 23 THEN 'Moderate'
            WHEN y_bocs_score_compulsions BETWEEN 24 AND 31 THEN 'Severe'
            WHEN y_bocs_score_compulsions BETWEEN 32 AND 40 THEN 'Extreme'
            ELSE 'Invalid Score'
        END AS y_bocs_score_compulsions_category
    FROM ocd_patient_schema.cleaned_ocd_patient_dataset
) AS compulsions_category_table
GROUP BY y_bocs_score_compulsions_category
ORDER BY 
    CASE
        WHEN y_bocs_score_compulsions_category = 'Subclinical' THEN 1
        WHEN y_bocs_score_compulsions_category = 'Mild' THEN 2
        WHEN y_bocs_score_compulsions_category = 'Moderate' THEN 3
        WHEN y_bocs_score_compulsions_category = 'Severe' THEN 4
        WHEN y_bocs_score_compulsions_category = 'Extreme' THEN 5
        ELSE 6
    END;


# -- 8. What is the most common obsession type and its average obsession score?
SELECT
	obsession_type,
	COUNT(patient_id) AS patient_count,
	ROUND(AVG(y_bocs_score_obsessions),2) AS avg_obsession_by_type
FROM ocd_patient_schema.cleaned_ocd_patient_dataset
GROUP BY 1
ORDER BY 2;


# -- 9. What is the most common compulsion type and its average compulsion score?
SELECT
    compulsion_type,
	COUNT(patient_id) AS patient_count,
	ROUND(AVG(y_bocs_score_compulsions),2) AS avg_compulsion_by_type
FROM ocd_patient_schema.cleaned_ocd_patient_dataset
GROUP BY 1
ORDER BY 2;


# -- 10. What is the most common obsession type by each gender?
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
ORDER BY 1, 3;


# -- 11. What is the most common compulsion type by each gender?
WITH compulsion_by_gender AS (
    SELECT
        gender,
        compulsion_type,
        COUNT(*) AS patient_count
    FROM ocd_patient_schema.cleaned_ocd_patient_dataset
    GROUP BY gender, compulsion_type
)
SELECT
    gender,
    compulsion_type,
    patient_count
FROM compulsion_by_gender
ORDER BY 1, 3;


# -- 12. What is the most common obsession type by each ethnicity?
WITH obsession_by_ethnicity AS (
    SELECT
        ethnicity,
        obsession_type,
        COUNT(*) AS patient_count
    FROM ocd_patient_schema.cleaned_ocd_patient_dataset
    GROUP BY ethnicity, obsession_type
)
SELECT
    ethnicity,
    obsession_type,
    patient_count
FROM obsession_by_ethnicity
ORDER BY 1, 3 DESC;


# -- 13. What is the most common compulsion type by each ethnicity?
WITH compulsion_by_ethnicity AS (
    SELECT
        ethnicity,
        compulsion_type,
        COUNT(*) AS patient_count
    FROM ocd_patient_schema.cleaned_ocd_patient_dataset
    GROUP BY ethnicity, compulsion_type
)
SELECT
    ethnicity,
    compulsion_type,
    patient_count
FROM compulsion_by_ethnicity
ORDER BY 1, 3 DESC;