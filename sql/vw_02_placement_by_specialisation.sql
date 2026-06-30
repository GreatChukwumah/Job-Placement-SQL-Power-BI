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
