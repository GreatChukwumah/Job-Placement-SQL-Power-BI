CREATE VIEW vw_01_overall_placement_rate AS
SELECT
    COUNT(*) AS TotalPlacements,
    SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) NumOfPlaced,
    SUM(CASE WHEN status = 'Not Placed' THEN 1 ELSE 0 END) NumOfNotPlaced,
    ROUND(SUM(CASE WHEN status = 'Placed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) PlacenmentRatePCT
FROM Job_Placement_Data
