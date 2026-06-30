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
