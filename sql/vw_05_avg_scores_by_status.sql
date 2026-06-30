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
