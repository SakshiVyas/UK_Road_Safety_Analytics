USE UK_Road_Safety_Analytics;


-- test transaction update + rollback --

START TRANSACTION ;
UPDATE vehicle
SET generic_make_model = 'DEMO'
WHERE generic_make_model IS NULL
ORDER BY  collision_index , vehicle_reference
LIMIT 1;

SELECT collision_index,
       vehicle_reference ,
       generic_make_model
FROM vehicle
WHERE generic_make_model = 'DEMO';

ROLLBACK ;

SELECT
    collision_index,
    vehicle_reference,
    generic_make_model
FROM vehicle
WHERE generic_make_model ='DEMO';

-- complete CRUD --

START TRANSACTION;

-- CREATE--
INSERT INTO collision (
    collision_index,
    collision_ref_no,
    police_force,
    collision_severity,
    number_of_vehicles,
    number_of_casualties,
    collision_date,
    collision_time,
    local_authority_ons_district,
    local_authority_highway,
    road_type,
    did_police_officer_attend_scene_of_accident,
    collision_injury_based,
    collision_adjusted_severity_serious,
    collision_adjusted_severity_slight
)
VALUES (
    'TEST000000001',
    'TEST00001',
    1,
    3,
    1,
    1,
    '2025-01-01',
    '12:00:00',
    'TEST00001',
    'TEST00001',
    6,
    1,
    1,
    0.00000000000,
    1.00000000000
);


INSERT INTO vehicle (
    collision_index,
    vehicle_reference,
    vehicle_type,
    escooter_flag
)
VALUES (
    'TEST000000001',
    1,
    9,
    0
);


INSERT INTO casualty (
    collision_index,
    vehicle_reference,
    casualty_reference,
    casualty_class,
    casualty_severity,
    casualty_injury_based,
    casualty_adjusted_severity_serious,
    casualty_adjusted_severity_slight
)
VALUES (
    'TEST000000001',
    1,
    1,
    2,
    3,
    1,
    0.00000000000,
    1.00000000000
);


-- READ--
SELECT *
FROM collision
WHERE collision_index = 'TEST000000001';

SELECT *
FROM vehicle
WHERE collision_index = 'TEST000000001';


SELECT *
FROM casualty
WHERE collision_index = 'TEST000000001';

-- UPDATE--
UPDATE collision
SET collision_severity = 2
WHERE collision_index = 'TEST000000001';


SELECT
    collision_index,
    collision_severity
FROM collision
WHERE collision_index = 'TEST000000001';


-- DELETE--
DELETE FROM casualty
WHERE collision_index = 'TEST000000001';

DELETE FROM vehicle
WHERE collision_index = 'TEST000000001';

DELETE FROM collision
WHERE collision_index = 'TEST000000001';


-- verify deletion --
SELECT *
FROM collision
WHERE collision_index = 'TEST000000001';


ROLLBACK;


SELECT *
FROM collision
WHERE collision_index = 'TEST000000001';

SELECT *
FROM vehicle
WHERE collision_index = 'TEST000000001';

SELECT *
FROM casualty
WHERE collision_index = 'TEST000000001';

-- COMMIT DEMO--

DROP TEMPORARY TABLE  IF EXISTS  transaction_demo;

CREATE TEMPORARY TABLE transaction_demo (
    id INT PRIMARY KEY,
    description VARCHAR(100)
);

START TRANSACTION;

INSERT INTO transaction_demo
VALUES (1, 'Committed transaction');

COMMIT;

SELECT *
FROM transaction_demo;

-- SAVEPOINT and partial rollback demo --

START TRANSACTION;

INSERT INTO transaction_demo
VALUES (2, 'Before savepoint');

SAVEPOINT after_first_insert;

INSERT INTO transaction_demo
VALUES (3, 'After savepoint');

SELECT *
FROM transaction_demo
ORDER BY id;

ROLLBACK TO after_first_insert;

SELECT *
FROM transaction_demo
ORDER BY id;

COMMIT;

-- transactions on data Quality issue table --
-- finding unusual driver-age records for manual review?--

SELECT
    collision_index,
    vehicle_reference,
    age_of_driver
FROM vehicle
WHERE age_of_driver > 100
ORDER BY age_of_driver DESC;

SET @dq_collision_index = (
    SELECT collision_index
    FROM vehicle
    WHERE age_of_driver > 100
    ORDER BY age_of_driver DESC
    LIMIT 1
);

SELECT @dq_collision_index;

START TRANSACTION;

INSERT INTO data_quality_issue (
    collision_index,
    issue_type,
    description
)
VALUES (
    @dq_collision_index,
    'Unusual driver age',
    'Driver age above 100 identified for manual review'
);

SET @issue_id = LAST_INSERT_ID();

SELECT *
FROM data_quality_issue
WHERE issue_id = @issue_id;


UPDATE data_quality_issue
SET status = 'In Review'
WHERE issue_id = @issue_id;


SELECT *
FROM data_quality_issue
WHERE issue_id = @issue_id;


UPDATE data_quality_issue
SET
    status = 'Resolved',
    resolved_at = CURRENT_TIMESTAMP
WHERE issue_id = @issue_id;


SELECT *
FROM data_quality_issue
WHERE issue_id = @issue_id;


ROLLBACK;

SELECT *
FROM data_quality_issue
WHERE issue_id = @issue_id;

DROP TEMPORARY TABLE IF EXISTS transaction_demo;

