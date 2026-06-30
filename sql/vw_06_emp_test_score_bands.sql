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
