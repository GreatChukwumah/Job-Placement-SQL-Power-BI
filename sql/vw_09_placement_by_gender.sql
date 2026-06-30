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
