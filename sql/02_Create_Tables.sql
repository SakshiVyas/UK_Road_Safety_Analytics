USE UK_Road_Safety_Analytics;

SHOW VARIABLES LIKE 'local_infile';
-- should be ON--
-- if it's off, run: SET GLOBAL local_infile = ON;
SHOW VARIABLES LIKE 'sql_safe_updates';

SET SQL_SAFE_UPDATES = 0;

SELECT @@SQL_SAFE_UPDATES;

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

ALTER TABLE collision
MODIFY collision_date VARCHAR(10) NOT NULL;

-- import collision data--

LOAD DATA LOCAL INFILE 'dataset/dft-road-casualty-statistics-collision-last-5-years.csv'
INTO TABLE collision
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    collision_index,
    @collision_year,
    collision_ref_no,

    @location_easting_osgr,
    @location_northing_osgr,
    @longitude,
    @latitude,

    police_force,
    collision_severity,
    number_of_vehicles,
    number_of_casualties,

    collision_date,

    @day_of_week,

    collision_time,

    @local_authority_district,

    local_authority_ons_district,
    local_authority_highway,
    local_authority_highway_current,

    first_road_class,
    first_road_number,
    road_type,
    speed_limit,

    @junction_detail_historic,

    junction_detail,
    junction_control,
    second_road_class,
    second_road_number,

    @pedestrian_crossing_human_control_historic,
    @pedestrian_crossing_physical_facilities_historic,

    pedestrian_crossing,
    light_conditions,
    weather_conditions,
    road_surface_conditions,
    special_conditions_at_site,

    @carriageway_hazards_historic,

    carriageway_hazards,
    urban_or_rural_area,
    did_police_officer_attend_scene_of_accident,
    trunk_road_flag,
    lsoa_of_accident_location,
    enhanced_severity_collision,
    collision_injury_based,
    collision_adjusted_severity_serious,
    collision_adjusted_severity_slight
)
SET
    location_easting_osgr =
        NULLIF(@location_easting_osgr, ''),
    location_northing_osgr =
        NULLIF(@location_northing_osgr, ''),
    longitude =
        NULLIF(@longitude, ''),
    latitude =
        NULLIF(@latitude, '');


-- Verify --
SELECT COUNT(*) AS collision_rows
FROM collision;

-- CONVERT COLLISION DATE TO MYSQL DATE TYPE--

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

-- IMPORT VEHICLE DATA--

LOAD DATA LOCAL INFILE 'dataset/dft-road-casualty-statistics-vehicle-last-5-years.csv'
INTO TABLE vehicle
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    collision_index,
    @collision_year,
    @collision_ref_no,

    vehicle_reference,
    vehicle_type,
    towing_and_articulation,

    @vehicle_manoeuvre_historic,

    vehicle_manoeuvre,
    vehicle_direction_from,
    vehicle_direction_to,

    @vehicle_location_restricted_lane_historic,

    vehicle_location_restricted_lane,
    junction_location,
    skidding_and_overturning,
    hit_object_in_carriageway,
    vehicle_leaving_carriageway,
    hit_object_off_carriageway,
    first_point_of_impact,
    vehicle_left_hand_drive,

    @journey_purpose_of_driver_historic,

    journey_purpose_of_driver,
    sex_of_driver,
    age_of_driver,

    @age_band_of_driver,

    engine_capacity_cc,
    propulsion_code,
    age_of_vehicle,
    generic_make_model,
    driver_imd_decile,
    lsoa_of_driver,
    escooter_flag,
    driver_distance_banding
);

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


-- IMPORT CASUALTY DATA--

LOAD DATA LOCAL INFILE 'dataset/dft-road-casualty-statistics-casualty-last-5-years.csv'
INTO TABLE casualty
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    collision_index,
    @collision_year,
    @collision_ref_no,

    vehicle_reference,
    casualty_reference,
    casualty_class,
    sex_of_casualty,
    age_of_casualty,

    @age_band_of_casualty,

    casualty_severity,
    pedestrian_location,
    pedestrian_movement,
    car_passenger,
    bus_or_coach_passenger,
    pedestrian_road_maintenance_worker,
    casualty_type,
    casualty_imd_decile,
    lsoa_of_casualty,
    enhanced_casualty_severity,
    casualty_injury_based,
    casualty_adjusted_severity_serious,
    casualty_adjusted_severity_slight,
    casualty_distance_banding
);

SELECT COUNT(*) AS casualty_rows
FROM casualty;


-- FINAL CORE DATA IMPORT CHECK--

SELECT
    'collision' AS table_name,
    COUNT(*) AS row_count
FROM collision

UNION ALL

SELECT
    'vehicle',
    COUNT(*)
FROM vehicle

UNION ALL

SELECT
    'casualty',
    COUNT(*)
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
