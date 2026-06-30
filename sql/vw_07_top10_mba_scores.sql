
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
