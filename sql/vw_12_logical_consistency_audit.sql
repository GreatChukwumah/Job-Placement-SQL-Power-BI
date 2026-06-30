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
