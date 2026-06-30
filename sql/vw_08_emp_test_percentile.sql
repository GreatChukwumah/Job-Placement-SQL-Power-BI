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
