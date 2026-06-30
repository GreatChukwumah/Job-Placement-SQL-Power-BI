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

--QUERIES

-- 1. OVERALL PLACEMENT RATE

CREATE VIEW vw_01_overall_placement_rate AS
SELECT
    COUNT(*) AS TotalPlacements,
    SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) NumOfPlaced,
    SUM(CASE WHEN status = 'Not Placed' THEN 1 ELSE 0 END) NumOfNotPlaced,
    ROUND(SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) PlacenmentRatePCT
FROM Job_Placement_Data

--2. PLACEMENT RATE BY SPECIALIZATION

CREATE VIEW vw_02_placement_by_specialisation AS
SELECT
    specialisation,
    COUNT(specialisation) AS TotalPlacements,
    SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) NumOfPlaced,
    SUM(CASE WHEN status = 'Not Placed' THEN 1 ELSE 0 END) NumOfNotPlaced,
    ROUND(
        SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) * 100.0 / COUNT(specialisation), 1
        ) AS SpecialisationPlacenmentRatePct
FROM Job_Placement_Data
GROUP BY specialisation;


--3. PLACEMENT RATE BY WORK EXPERIENCE

CREATE VIEW vw_03_placement_by_work_experience AS
SELECT
    work_experience,
    COUNT(specialisation) AS TotalPlacements,
    SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) NumOfPlaced,
    SUM(CASE WHEN status = 'Not Placed' THEN 1 ELSE 0 END) NumOfNotPlaced,
    ROUND(
        SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) * 100.0 / COUNT(specialisation), 1
        ) AS SpecialisationPlacenmentRatePct
FROM Job_Placement_Data
GROUP BY work_experience;


--4. PLACEMENT RATE BY ACADEMIC BACKGROUND

CREATE VIEW vw_04_placement_by_academic_background AS
SELECT
    hsc_subject,
    undergrad_degree,
    COUNT(*) AS total_candidates,
    SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) AS placed_count,
    ROUND(
        SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 1
    ) AS placement_rate_pct
FROM Job_Placement_Data
GROUP BY hsc_subject, undergrad_degree;


--5. AVERAGE SCORES BY PLACEMENT STATUS
/*Average Scores candidates must have in each level of cetification if they are to get placed*/

CREATE VIEW vw_05_avg_scores_by_status AS
SELECT
    status,
    COUNT(*) AS candidate_count,
    ROUND(AVG(ssc_percentage), 1)      AS avg_ssc_pct,
    ROUND(AVG(hsc_percentage), 1)      AS avg_hsc_pct,
    ROUND(AVG(degree_percentage), 1)   AS avg_degree_pct,
    ROUND(AVG(emp_test_percentage), 1) AS avg_emp_test_pct,
    ROUND(AVG(mba_percent), 1)         AS avg_mba_pct
FROM Job_Placement_Data
GROUP BY status;


--6. EMPLOYABILITY SCORE BAND ANALYSIS

CREATE VIEW vw_06_emp_test_score_bands AS
SELECT
    CASE 
        WHEN emp_test_percentage < 50 THEN '0-49'
        WHEN emp_test_percentage < 60 THEN '50-59'
        WHEN emp_test_percentage < 70 THEN '60-69'
        WHEN emp_test_percentage < 80 THEN '70-79'
        WHEN emp_test_percentage < 90 THEN '80-89'
        ELSE '90-100'
    END AS emp_test_score_band,
    COUNT(*) AS total_candidates,
    SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) AS placed_count,
    ROUND(
        SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 1
    ) AS placement_rate_pct
FROM Job_Placement_Data
GROUP BY 
    CASE 
        WHEN emp_test_percentage < 50 THEN '0-49'
        WHEN emp_test_percentage < 60 THEN '50-59'
        WHEN emp_test_percentage < 70 THEN '60-69'
        WHEN emp_test_percentage < 80 THEN '70-79'
        WHEN emp_test_percentage < 90 THEN '80-89'
        ELSE '90-100'
    END;


--7. TOP 10 CANDIDATES BY MBA PERCENTAGE

CREATE VIEW vw_07_top10_mba_scores AS
SELECT TOP 10
    candidate_id,
    gender,
    specialisation,
    work_experience,
    mba_percent,
    status
FROM Job_Placement_Data
ORDER BY mba_percent DESC;


-- 8. PERCENTILE RANK OF EMPLOYABILITY TEST SCORES

CREATE VIEW vw_08_emp_test_percentile AS
SELECT
    candidate_id,
    gender,
    specialisation,
    emp_test_percentage,
    status,
    ROUND(
        PERCENT_RANK() OVER (ORDER BY emp_test_percentage) * 100, 1
    ) AS emp_test_percentile
FROM Job_Placement_Data;


-- 9. PLACEMENT RATE BY GENDER

CREATE VIEW vw_09_placement_by_gender AS
SELECT
    gender,
    COUNT(*) AS total_candidates,
    SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) AS placed_count,
    ROUND(
        SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 1
    ) AS placement_rate_pct
FROM Job_Placement_Data
GROUP BY gender;

--10. PLACEMENT RATE BY EXAM BOARD TYPE

CREATE VIEW vw_10_placement_by_board AS
SELECT
    ssc_board,
    hsc_board,
    COUNT(*) AS total_candidates,
    SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) AS placed_count,
    ROUND(
        SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 1
    ) AS placement_rate_pct
FROM Job_Placement_Data
GROUP BY ssc_board, hsc_board;


--11. ROW-LEVEL COMPLETENESS SCORE

CREATE VIEW vw_11_completeness_score AS
SELECT
    candidate_id,
    gender,
    status,
    (
        CASE WHEN gender               IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN ssc_percentage       IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN ssc_board            IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN hsc_percentage       IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN hsc_board            IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN hsc_subject          IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN degree_percentage    IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN undergrad_degree     IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN work_experience      IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN emp_test_percentage  IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN specialisation       IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN mba_percent          IS NOT NULL THEN 1 ELSE 0 END +
        CASE WHEN status               IS NOT NULL THEN 1 ELSE 0 END
    ) AS fields_populated,
    ROUND(
        (
            CASE WHEN gender               IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN ssc_percentage       IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN ssc_board            IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN hsc_percentage       IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN hsc_board            IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN hsc_subject          IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN degree_percentage    IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN undergrad_degree     IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN work_experience      IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN emp_test_percentage  IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN specialisation       IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN mba_percent          IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN status               IS NOT NULL THEN 1 ELSE 0 END
        ) * 100.0 / 13, 1
    ) AS completeness_score_pct
FROM Job_Placement_Data;



--12. LOGICAL CONSISTENCY AUDIT

CREATE VIEW vw_12_logical_consistency_audit AS
SELECT
    candidate_id,
    ssc_percentage,
    hsc_percentage,
    degree_percentage,
    emp_test_percentage,
    mba_percent,
    work_experience,
    status,

    -- FLAG 1: any percentage outside the valid 0-100 range
    CASE 
        WHEN ssc_percentage NOT BETWEEN 0 AND 100
             OR hsc_percentage NOT BETWEEN 0 AND 100
             OR degree_percentage NOT BETWEEN 0 AND 100
             OR emp_test_percentage NOT BETWEEN 0 AND 100
             OR mba_percent NOT BETWEEN 0 AND 100
        THEN 1 ELSE 0
    END AS flag_invalid_percentage,

    -- FLAG 2: status is neither 'Placed' nor 'Not Placed'
    -- (catches stray typos/casing/whitespace variants that might
    -- slip in if this table is ever appended to in the future)
    CASE 
        WHEN status NOT IN ('Placed', 'Not Placed') THEN 1 ELSE 0 
    END AS flag_invalid_status,

    -- FLAG 3: categorical fields outside their known valid sets
    CASE 
        WHEN gender NOT IN ('M', 'F')
             OR work_experience NOT IN ('Yes', 'No')
             OR specialisation NOT IN ('Mkt&Fin', 'Mkt&HR')
        THEN 1 ELSE 0
    END AS flag_invalid_category

FROM Job_Placement_Data;
