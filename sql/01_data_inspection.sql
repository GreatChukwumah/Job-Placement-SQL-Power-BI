--DATA INSPECTION AND CLEANING

SELECT *
FROM Job_Placement_Data


-- 0. Quick check that all 13 columns are present and named as expected
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Job_Placement_Data';


-- 1. Row count (confirming no records were lost in import)
SELECT COUNT(*) AS total_rows FROM Job_Placement_Data;

-- 2. A check for nulls across all columns
SELECT
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN ssc_percentage IS NULL THEN 1 ELSE 0 END) AS null_ssc_pct,
    SUM(CASE WHEN ssc_board IS NULL THEN 1 ELSE 0 END) AS null_ssc_board,
    SUM(CASE WHEN hsc_percentage IS NULL THEN 1 ELSE 0 END) AS null_hsc_pct,
    SUM(CASE WHEN hsc_board IS NULL THEN 1 ELSE 0 END) AS null_hsc_board,
    SUM(CASE WHEN hsc_subject IS NULL THEN 1 ELSE 0 END) AS null_hsc_subject,
    SUM(CASE WHEN degree_percentage IS NULL THEN 1 ELSE 0 END) AS null_degree_pct,
    SUM(CASE WHEN undergrad_degree IS NULL THEN 1 ELSE 0 END) AS null_undergrad,
    SUM(CASE WHEN work_experience IS NULL THEN 1 ELSE 0 END) AS null_work_exp,
    SUM(CASE WHEN emp_test_percentage IS NULL THEN 1 ELSE 0 END) AS null_emp_test,
    SUM(CASE WHEN specialisation IS NULL THEN 1 ELSE 0 END) AS null_specialisation,
    SUM(CASE WHEN mba_percent IS NULL THEN 1 ELSE 0 END) AS null_mba_pct,
    SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS null_status
FROM Job_Placement_Data;

-- 3. Distinct values in every categorical column (checking for typos/casing issues)
SELECT DISTINCT gender FROM Job_Placement_Data;
SELECT DISTINCT ssc_board FROM Job_Placement_Data;
SELECT DISTINCT hsc_board FROM Job_Placement_Data;
SELECT DISTINCT hsc_subject FROM Job_Placement_Data;
SELECT DISTINCT undergrad_degree FROM Job_Placement_Data;
SELECT DISTINCT work_experience FROM Job_Placement_Data;
SELECT DISTINCT specialisation FROM Job_Placement_Data;
SELECT DISTINCT status FROM Job_Placement_Data;

-- 4. Check for impossible percentage values (below 0 or above 100)
SELECT * FROM Job_Placement_Data
WHERE ssc_percentage NOT BETWEEN 0 AND 100
   OR hsc_percentage NOT BETWEEN 0 AND 100
   OR degree_percentage NOT BETWEEN 0 AND 100
   OR emp_test_percentage NOT BETWEEN 0 AND 100
   OR mba_percent NOT BETWEEN 0 AND 100;


-- 5. Check for full-row duplicates (since there's no ID column)
SELECT gender, ssc_percentage, ssc_board, hsc_percentage, hsc_board,
       hsc_subject, degree_percentage, undergrad_degree, work_experience,
       emp_test_percentage, specialisation, mba_percent, status,
       COUNT(*) AS occurrence_count
FROM Job_Placement_Data
GROUP BY gender, ssc_percentage, ssc_board, hsc_percentage, hsc_board,
         hsc_subject, degree_percentage, undergrad_degree, work_experience,
         emp_test_percentage, specialisation, mba_percent, status
HAVING COUNT(*) > 1;

--Let's create that ID column shall we?
   ALTER TABLE Job_Placement_Data
ADD candidate_id INT IDENTITY(1,1);

/* This Data has no need for a schema in view of its values, it will be redundant to do that*/
