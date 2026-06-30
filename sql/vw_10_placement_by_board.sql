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
