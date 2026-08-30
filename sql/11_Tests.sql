USE UK_Road_Safety_Analytics;

-- check row counts --
SELECT COUNT(*) AS collision_count
FROM collision;

SELECT COUNT(*) AS vehicle_count
FROM vehicle;

SELECT COUNT(*) AS
    casualty_count
FROM casualty;

-- duplicate primary key check--
SELECT
    collision_index,
    COUNT(*) AS
        duplicate_count
FROM collision
GROUP BY collision_index
HAVING COUNT(*) > 1;


SELECT
    collision_index,
    vehicle_reference,
    COUNT(*) AS duplicate_count
FROM vehicle
GROUP BY
    collision_index,
    vehicle_reference
HAVING COUNT(*) > 1;


SELECT
    collision_index,
    casualty_reference,
    COUNT(*) AS duplicate_count
FROM casualty
GROUP BY
    collision_index,
    casualty_reference
HAVING COUNT(*) > 1;

-- orphan vehicle check --
SELECT COUNT(*) AS orphan_vehicles
FROM vehicle v
LEFT JOIN collision c
    ON v.collision_index = c.collision_index
WHERE c.collision_index IS NULL;

-- orphan casualty to collision check--
SELECT COUNT(*) AS orphan_casualties
FROM casualty ca
LEFT JOIN collision c
    ON ca.collision_index = c.collision_index
WHERE c.collision_index IS NULL;

-- orphan casualty to vehicle check --
-- composite fk relationship--

SELECT COUNT(*) AS casualties_without_vehicle
FROM casualty ca
LEFT JOIN vehicle v
    ON ca.collision_index = v.collision_index
   AND ca.vehicle_reference = v.vehicle_reference
WHERE v.collision_index IS NULL;

-- stored vehicle count vs actual vehicle count --

SELECT
    c.collision_index,
    c.number_of_vehicles AS stored_vehicle_count,
    COUNT(v.vehicle_reference) AS actual_vehicle_count
FROM collision c
LEFT JOIN vehicle v
    ON c.collision_index = v.collision_index
GROUP BY
    c.collision_index,
    c.number_of_vehicles
HAVING c.number_of_vehicles <> COUNT(v.vehicle_reference);



-- stored casualty count vs actual casualty count --

SELECT
    c.collision_index,
    c.number_of_casualties AS stored_casualty_count,
    COUNT(ca.casualty_reference) AS actual_casualty_count
FROM collision c
LEFT JOIN casualty ca
    ON c.collision_index = ca.collision_index
GROUP BY
    c.collision_index,
    c.number_of_casualties
HAVING c.number_of_casualties <> COUNT(ca.casualty_reference);



-- flag validation--

SELECT
    'collision_injury_based' AS validation_rule,
    COUNT(*) AS invalid_count
FROM collision
WHERE collision_injury_based NOT IN (0, 1)

UNION ALL

SELECT
    'escooter_flag',
    COUNT(*)
FROM vehicle
WHERE escooter_flag NOT IN (0, 1)

UNION ALL

SELECT
    'casualty_injury_based',
    COUNT(*)
FROM casualty
WHERE casualty_injury_based NOT IN (0, 1);



-- adjusted severity range validation--

SELECT
    'collision adjusted severity' AS validation_rule,
    COUNT(*) AS invalid_count
FROM collision
WHERE collision_adjusted_severity_serious NOT BETWEEN 0 AND 1
   OR collision_adjusted_severity_slight NOT BETWEEN 0 AND 1

UNION ALL

SELECT
    'casualty adjusted severity',
    COUNT(*)
FROM casualty
WHERE casualty_adjusted_severity_serious NOT BETWEEN 0 AND 1
   OR casualty_adjusted_severity_slight NOT BETWEEN 0 AND 1;



-- View validation--

SELECT
    'vw_collision_summary' AS view_name,
    (SELECT COUNT(*) FROM collision) AS base_table_count,
    (SELECT COUNT(*) FROM vw_collision_summary) AS view_count,
    CASE
        WHEN (SELECT COUNT(*) FROM collision)
             =
             (SELECT COUNT(*) FROM vw_collision_summary)
        THEN 'PASS'
        ELSE 'FAIL'
    END AS test_result

UNION ALL

SELECT
    'vw_casualty_detail',
    (SELECT COUNT(*) FROM casualty),
    (SELECT COUNT(*) FROM vw_casualty_detail),
    CASE
        WHEN (SELECT COUNT(*) FROM casualty)
             =
             (SELECT COUNT(*) FROM vw_casualty_detail)
        THEN 'PASS'
        ELSE 'FAIL'
    END;



-- stored function + procedure validation--
-- Test known age-group boundaries--

SELECT
    fn_age_group(NULL) AS null_age,
    fn_age_group(10) AS age_10,
    fn_age_group(18) AS age_18,
    fn_age_group(30) AS age_30,
    fn_age_group(50) AS age_50,
    fn_age_group(70) AS age_70,
    fn_age_group(80) AS age_80;


-- Test function against real vehicle data--

SELECT
    collision_index,
    vehicle_reference,
    age_of_driver,
    fn_age_group(age_of_driver) AS calculated_age_group
FROM vehicle
WHERE age_of_driver IS NOT NULL
LIMIT 20;


-- Test stored procedure--

CALL sp_collision_summary_by_year(2024);



-- trigger+audit trail validation--
-- Everything is rolled back after testing--
SET @test_collision_index = (
    SELECT collision_index
    FROM collision
    ORDER BY collision_index
    LIMIT 1
);

SELECT @test_collision_index;


START TRANSACTION;


INSERT INTO data_quality_issue (
    collision_index,
    issue_type,
    description
)
VALUES (
    @test_collision_index,
    'Trigger test',
    'Temporary issue created to validate audit trigger'
);


SET @test_issue_id = LAST_INSERT_ID();


-- First status change --

UPDATE data_quality_issue
SET status = 'In Review'
WHERE issue_id = @test_issue_id;


-- Second status change--

UPDATE data_quality_issue
SET
    status = 'Resolved',
    resolved_at = CURRENT_TIMESTAMP
WHERE issue_id = @test_issue_id;


-- The trigger should have automatically created 2 audit rows--

SELECT
    COUNT(*) AS audit_rows
FROM data_quality_issue_audit
WHERE issue_id = @test_issue_id;


SELECT
    audit_id,
    issue_id,
    old_status,
    new_status,
    changed_at
FROM data_quality_issue_audit
WHERE issue_id = @test_issue_id
ORDER BY audit_id;


ROLLBACK;


-- Verifying that the test data was removed---

SELECT
    COUNT(*) AS remaining_test_issues
FROM data_quality_issue
WHERE issue_id = @test_issue_id;


SELECT
    COUNT(*) AS remaining_test_audit_rows
FROM data_quality_issue_audit
WHERE issue_id = @test_issue_id;

-- date check--

SELECT
    COUNT(*) AS null_collision_dates
FROM collision
WHERE collision_date IS NULL;