USE UK_Road_Safety_Analytics;

CREATE TABLE collision(
    collision_index VARCHAR(13) PRIMARY KEY,
    collision_ref_no VARCHAR(9) NOT NULL ,
    location_easting_osgr INT NULL ,
    location_northing_osgr INT NULL ,
    longitude DECIMAL(9,6) NULL ,
    latitude DECIMAL(9,6) NULL,
    police_force SMALLINT UNSIGNED NOT NULL ,
    collision_severity TINYINT UNSIGNED NOT NULL,
    number_of_vehicles TINYINT UNSIGNED NOT NULL,
    number_of_casualties TINYINT UNSIGNED NOT NULL ,
    collision_date DATE NOT NULL ,
    collision_time TIME NOT NULL ,
    local_authority_ons_district CHAR(9) NOT NULL ,
    local_authority_highway CHAR(9) NOT NULL ,
    local_authority_highway_current CHAR(9) NULL,
    first_road_class TINYINT NULL ,
    first_road_number SMALLINT NULL ,
    road_type TINYINT NOT NULL ,
    speed_limit TINYINT NULL ,
    junction_detail TINYINT NULL,
    junction_control  TINYINT NULL ,
    second_road_class TINYINT NULL ,
    second_road_number SMALLINT NULL ,
    pedestrian_crossing TINYINT NULL ,
    light_conditions TINYINT NULL ,
    weather_conditions TINYINT NULL ,
    road_surface_conditions TINYINT NULL ,
    special_conditions_at_site TINYINT NULL ,
    carriageway_hazards TINYINT NULL ,
    urban_or_rural_area TINYINT NULL ,
    did_police_officer_attend_scene_of_accident TINYINT UNSIGNED NOT NULL ,
    trunk_road_flag TINYINT NULL ,
    lsoa_of_accident_location CHAR(9) NULL ,
    enhanced_severity_collision TINYINT NULL ,
    collision_injury_based TINYINT UNSIGNED NOT NULL ,
    collision_adjusted_severity_serious DECIMAL(12,11) NOT NULL ,
    collision_adjusted_severity_slight DECIMAL(12,11) NOT NULL

);

DESCRIBE collision;

SELECT COUNT(*) AS collision_rows
FROM collision;

ALTER TABLE collision
MODIFY collision_date VARCHAR(10) NOT NULL;

SELECT COUNT(*) AS collision_rows
FROM collision;


SELECT collision_index, collision_date, collision_time
FROM collision
LIMIT 5;

SELECT
    collision_date,
    STR_TO_DATE(collision_date,'%d/%m/%Y') AS converted_date
FROM collision
LIMIT 10;

SELECT COUNT(*) AS invalid_dates
FROM collision
WHERE STR_TO_DATE(collision_date, '%d/%m/%Y') IS NULL;

ALTER TABLE collision
ADD COLUMN collision_date_new DATE;

UPDATE collision
SET collision_date_new =STR_TO_DATE(collision_date,'%d/%m/%Y');

SELECT
    collision_date,collision_date_new
FROM collision
LIMIT 10;


SELECT COUNT(*) AS failed_conversions
FROM collision
WHERE collision_date_new IS NULL;


ALTER TABLE collision
DROP COLUMN collision_date;

ALTER TABLE collision
RENAME COLUMN collision_date_new TO collision_date;

ALTER TABLE collision
MODIFY collision_date DATE NOT NULL;


DESCRIBE collision;

SELECT collision_date FROM collision LIMIT 10;



-- next table vehicle --

CREATE TABLE vehicle(
    collision_index VARCHAR(13) NOT NULL ,
    vehicle_reference SMALLINT UNSIGNED NOT NULL ,
    vehicle_type TINYINT NULL ,
    towing_and_articulation TINYINT NULL ,
    vehicle_manoeuvre TINYINT NULL ,
    vehicle_direction_from TINYINT NULL ,
    vehicle_direction_to TINYINT NULL ,
    vehicle_location_restricted_lane TINYINT NULL ,
    junction_location TINYINT NULL ,
    skidding_and_overturning TINYINT NULL,
    hit_object_in_carriageway TINYINT NULL,
    vehicle_leaving_carriageway TINYINT NULL,
    hit_object_off_carriageway TINYINT NULL,
    first_point_of_impact TINYINT NULL,
    vehicle_left_hand_drive TINYINT NULL,
    journey_purpose_of_driver TINYINT NULL ,
    sex_of_driver TINYINT NULL ,
    age_of_driver TINYINT NULL ,
    engine_capacity_cc INT NULL ,
    propulsion_code TINYINT NULL ,
    age_of_vehicle SMALLINT NULL ,
    generic_make_model VARCHAR(50) NULL ,
    driver_imd_decile TINYINT NULL ,
    lsoa_of_driver CHAR(9) NULL ,
    escooter_flag TINYINT UNSIGNED NOT NULL ,
    driver_distance_banding TINYINT NULL ,

    PRIMARY KEY (collision_index,vehicle_reference)

);

DESCRIBE vehicle;

SELECT COUNT(*) AS vehicle_rows
FROM vehicle;


-- casualty table--

CREATE TABLE casualty (
    collision_index VARCHAR(13) NOT NULL,
    vehicle_reference SMALLINT UNSIGNED NOT NULL,
    casualty_reference SMALLINT UNSIGNED NOT NULL,
    casualty_class TINYINT UNSIGNED NOT NULL,
    sex_of_casualty TINYINT NULL,
    age_of_casualty TINYINT NULL,
    casualty_severity TINYINT UNSIGNED NOT NULL,
    pedestrian_location TINYINT NULL,
    pedestrian_movement TINYINT NULL,
    car_passenger TINYINT NULL,
    bus_or_coach_passenger TINYINT NULL,
    pedestrian_road_maintenance_worker TINYINT NULL,
    casualty_type TINYINT NULL,
    casualty_imd_decile TINYINT NULL,
    lsoa_of_casualty CHAR(9) NULL,
    enhanced_casualty_severity TINYINT NULL,
    casualty_injury_based TINYINT UNSIGNED NOT NULL,
    casualty_adjusted_severity_serious DECIMAL(12,11) NOT NULL,
    casualty_adjusted_severity_slight DECIMAL(12,11) NOT NULL,
    casualty_distance_banding TINYINT NULL,

    PRIMARY KEY (collision_index, casualty_reference)
);

DESCRIBE casualty;

SELECT COUNT(*) AS casualty_rows
FROM casualty;


-- transaction table---

CREATE TABLE data_quality_issue (
    issue_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    collision_index VARCHAR(13) NOT NULL,
    issue_type VARCHAR(50) NOT NULL,
    description VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Open',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,

    CONSTRAINT fk_issue_collision
        FOREIGN KEY (collision_index)
        REFERENCES collision (collision_index),

    CONSTRAINT chk_issue_status
        CHECK (status IN ('Open', 'In Review', 'Resolved'))
);

DESCRIBE data_quality_issue;


CREATE TABLE IF NOT EXISTS data_quality_issue_audit (
    audit_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    issue_id BIGINT UNSIGNED NOT NULL,
    old_status VARCHAR(20) NOT NULL,
    new_status VARCHAR(20) NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_audit_issue
        FOREIGN KEY (issue_id)
        REFERENCES data_quality_issue(issue_id)
);
