USE UK_Road_Safety_Analytics;

-- yearly collision summary procedure --
DROP PROCEDURE IF EXISTS sp_collision_summary_by_year;

DELIMITER $

CREATE PROCEDURE sp_collision_summary_by_year(
    IN p_year INT
)
BEGIN

    SELECT
        p_year AS collision_year,
        COUNT(*) AS total_collisions,
        SUM(c.collision_severity = 1) AS fatal_collisions,
        SUM(c.collision_severity = 2) AS serious_collisions,
        SUM(c.collision_severity = 3) AS slight_collisions,
        ROUND(
            SUM(c.collision_severity IN (1, 2))
            * 100.0 / NULLIF(COUNT(*),0),
            2
        ) AS serious_or_fatal_percentage
    FROM collision c
    WHERE c.collision_date >= STR_TO_DATE(CONCAT(p_year, '-01-01'), '%Y-%m-%d')
    AND c.collision_date < STR_TO_DATE(CONCAT(p_year + 1, '-01-01'), '%Y-%m-%d');

END $

DELIMITER ;


CALL sp_collision_summary_by_year(2024);


CALL sp_collision_summary_by_year(2021);

CALL sp_collision_summary_by_year(2022);


-- function to classify age groups --

DROP FUNCTION IF EXISTS fn_age_group;

DELIMITER $

CREATE FUNCTION fn_age_group(
    p_age TINYINT UNSIGNED
)


RETURNS VARCHAR(20)
DETERMINISTIC

BEGIN

    IF p_age IS NULL THEN
        RETURN 'Unknown';

    ELSEIF p_age BETWEEN 0 AND 15 THEN
        RETURN '0-15';

    ELSEIF p_age BETWEEN 16 AND 24 THEN
        RETURN '16-24';

    ELSEIF p_age BETWEEN 25 AND 44 THEN
        RETURN '25-44';

    ELSEIF p_age BETWEEN 45 AND 64 THEN
        RETURN '45-64';

    ELSEIF p_age BETWEEN 65 AND 74 THEN
        RETURN '65-74';

    ELSE
        RETURN '75+';

    END IF;

END $

DELIMITER ;


SELECT age_of_driver,fn_age_group(age_of_driver) AS age_group
FROM vehicle
WHERE age_of_driver IS NOT NULL
LIMIT 20;

SELECT age_of_casualty, fn_age_group(age_of_casualty) AS age_group
FROM casualty
WHERE age_of_casualty IS NOT NULL
LIMIT 20;

SELECT fn_age_group(30);
-- trigger --


DROP TRIGGER IF EXISTS trg_data_quality_issue_status_audit;

DELIMITER $

CREATE TRIGGER trg_data_quality_issue_status_audit
AFTER UPDATE ON data_quality_issue
FOR EACH ROW

BEGIN

    IF OLD.status <> NEW.status THEN

        INSERT INTO data_quality_issue_audit (
            issue_id,
            old_status,
            new_status
        )
        VALUES (
            NEW.issue_id,
            OLD.status,
            NEW.status
        );

    END IF;

END $

DELIMITER ;


 -- testing the trigger--

START TRANSACTION;

INSERT INTO data_quality_issue (
    collision_index,
    issue_type,
    description
)
VALUES (
    '2025471574127',
    'Unusual driver age',
    'Trigger demonstration for driver age above 100'
);

SET @test_issue_id = LAST_INSERT_ID();

-- open in review--
UPDATE data_quality_issue
SET status = 'In Review'
WHERE issue_id = @test_issue_id;


-- In Review to  Resolved--
UPDATE data_quality_issue
SET
    status = 'Resolved',
    resolved_at = CURRENT_TIMESTAMP
WHERE issue_id = @test_issue_id;


-- Check automatically generated audit records--

SELECT
    audit_id,
    issue_id,
    old_status,
    new_status,
    changed_at
FROM data_quality_issue_audit
WHERE issue_id = @test_issue_id
ORDER BY audit_id;

ROLLBACK ;

SELECT *
FROM data_quality_issue
WHERE issue_id = @test_issue_id;

SELECT *
FROM data_quality_issue_audit
WHERE issue_id = @test_issue_id;

