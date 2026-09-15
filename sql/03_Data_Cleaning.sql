USE UK_Road_Safety_Analytics;

-- cleaning -1 values in columns as they correspond to missing or out of range --
-- changing it to null--
-- first table collision --

SET SQL_SAFE_UPDATES = 0;


SELECT COUNT(*) AS missing_first_road_class
FROM collision
WHERE first_road_class=-1;

UPDATE collision
SET first_road_class=NULL
WHERE first_road_class=-1;

SELECT COUNT(*) AS null_first_road_class
FROM collision
WHERE first_road_class IS NULL;

-- use aggregation - SUM instead of using WHERE--

SELECT
    SUM(first_road_number = -1) AS first_road_number_missing,
    SUM(junction_detail = -1) AS junction_detail_missing,
    SUM(junction_control = -1) AS junction_control_missing,
    SUM(second_road_class = -1) AS second_road_class_missing,
    SUM(second_road_number = -1) AS second_road_number_missing
FROM collision;

-- set them to null--

UPDATE collision
SET first_road_number = NULL
WHERE first_road_number = -1;

UPDATE collision
SET junction_detail = NULL
WHERE junction_detail = -1;

UPDATE collision
SET junction_control = NULL
WHERE junction_control = -1;

UPDATE collision
SET second_road_class = NULL
WHERE second_road_class = -1;

UPDATE collision
SET second_road_number = NULL
WHERE second_road_number = -1;

-- checking if its done --

SELECT
    SUM(first_road_number = -1) AS first_road_number_remaining,
    SUM(junction_detail = -1) AS junction_detail_remaining,
    SUM(junction_control = -1) AS junction_control_remaining,
    SUM(second_road_class = -1) AS second_road_class_remaining,
    SUM(second_road_number = -1) AS second_road_number_remaining
FROM collision;


-- check other columns and clean such values --

SELECT COUNT(*) AS pedestrian_crossing_missing
FROM collision
WHERE pedestrian_crossing =-1;

UPDATE collision
SET pedestrian_crossing = NULL
WHERE pedestrian_crossing = -1;

SELECT COUNT(*) AS pedestrian_crossing_remaining
FROM collision
WHERE pedestrian_crossing = -1;

-- updated and verified--

SELECT
    SUM(speed_limit = -1) AS speed_limit_missing,
    SUM(light_conditions = -1) AS light_missing,
    SUM(weather_conditions = -1) AS weather_missing,
    SUM(road_surface_conditions = -1) AS road_surface_missing,
    SUM(special_conditions_at_site = -1) AS special_conditions_missing,
    SUM(carriageway_hazards = -1) AS carriageway_hazards_missing,
    SUM(urban_or_rural_area = -1) AS urban_rural_missing,
    SUM(trunk_road_flag = -1) AS trunk_road_missing,
    SUM(enhanced_severity_collision = -1) AS enhanced_severity_missing,
    SUM(local_authority_highway_current = '-1') AS current_authority_missing,
    SUM(lsoa_of_accident_location = '-1') AS lsoa_missing
FROM collision;

-- '' where CHAR--


UPDATE collision
SET light_conditions = NULL
WHERE light_conditions = -1;

UPDATE collision
SET weather_conditions = NULL
WHERE weather_conditions = -1;

UPDATE collision
SET road_surface_conditions = NULL
WHERE road_surface_conditions = -1;

UPDATE collision
SET special_conditions_at_site = NULL
WHERE special_conditions_at_site = -1;

UPDATE collision
SET speed_limit = NULL
WHERE speed_limit = -1;

UPDATE collision
SET carriageway_hazards = NULL
WHERE carriageway_hazards = -1;

UPDATE collision
SET urban_or_rural_area = NULL
WHERE urban_or_rural_area = -1;

UPDATE collision
SET trunk_road_flag = NULL
WHERE trunk_road_flag = -1;

UPDATE collision
SET enhanced_severity_collision = NULL
WHERE enhanced_severity_collision = -1;

UPDATE collision
SET local_authority_highway_current = NULL
WHERE local_authority_highway_current = '-1';

UPDATE collision
SET lsoa_of_accident_location = NULL
WHERE lsoa_of_accident_location = '-1';

-- verify --


SELECT
    SUM(light_conditions = -1) AS light_conditions_remaining,
    SUM(weather_conditions = -1) AS weather_conditions_remaining,
    SUM(road_surface_conditions = -1) AS road_surface_conditions_remaining,
    SUM(special_conditions_at_site = -1) AS special_conditions_remaining,
    SUM(speed_limit = -1) AS speed_limit_remaining,
    SUM(carriageway_hazards = -1) AS carriageway_hazards_remaining,
    SUM(urban_or_rural_area = -1) AS urban_rural_remaining,
    SUM(trunk_road_flag = -1) AS trunk_road_remaining,
    SUM(enhanced_severity_collision = -1) AS enhanced_severity_remaining,
    SUM(local_authority_highway_current = '-1') AS current_authority_remaining,
    SUM(lsoa_of_accident_location = '-1') AS lsoa_remaining

FROM collision;


-- checking null values--

SELECT
    SUM(first_road_class IS NULL) AS first_road_class_nulls,
    SUM(first_road_number IS NULL) AS first_road_number_nulls,
    SUM(speed_limit IS NULL) AS speed_limit_nulls,
    SUM(junction_detail IS NULL) AS junction_detail_nulls,
    SUM(junction_control IS NULL) AS junction_control_nulls,
    SUM(second_road_class IS NULL) AS second_road_class_nulls,
    SUM(second_road_number IS NULL) AS second_road_number_nulls,
    SUM(pedestrian_crossing IS NULL) AS pedestrian_crossing_nulls,
    SUM(light_conditions IS NULL) AS light_conditions_nulls,
    SUM(weather_conditions IS NULL) AS weather_conditions_nulls,
    SUM(road_surface_conditions IS NULL) AS road_surface_conditions_nulls,
    SUM(special_conditions_at_site IS NULL) AS special_conditions_nulls,
    SUM(carriageway_hazards IS NULL) AS carriageway_hazards_nulls,
    SUM(urban_or_rural_area IS NULL) AS urban_rural_nulls,
    SUM(trunk_road_flag IS NULL) AS trunk_road_nulls,
    SUM(enhanced_severity_collision IS NULL) AS enhanced_severity_nulls,
    SUM(local_authority_highway_current IS NULL) AS current_authority_nulls,
    SUM(lsoa_of_accident_location IS NULL) AS lsoa_nulls

FROM collision;

-- final check to see total records --
-- use distinct to verify PK --

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT collision_index ) AS unique_collisions
FROM collision;

-- cleaning vehicle table --

SELECT
    SUM(vehicle_type = -1) AS vehicle_type_missing,
    SUM(towing_and_articulation = -1) AS towing_missing,
    SUM(vehicle_manoeuvre = -1) AS manoeuvre_missing,

    SUM(vehicle_direction_from = -1) AS direction_from_missing,
    SUM(vehicle_direction_to = -1) AS direction_to_missing,
    SUM(vehicle_location_restricted_lane = -1) AS restricted_lane_missing,
    SUM(junction_location = -1) AS junction_location_missing,

    SUM(skidding_and_overturning = -1) AS skidding_missing,
    SUM(hit_object_in_carriageway = -1) AS hit_carriageway_missing,
    SUM(vehicle_leaving_carriageway = -1) AS leaving_carriageway_missing,
    SUM(hit_object_off_carriageway = -1) AS hit_off_carriageway_missing,
    SUM(first_point_of_impact = -1) AS impact_missing,
    SUM(vehicle_left_hand_drive = -1) AS left_hand_drive_missing,

    SUM(journey_purpose_of_driver = -1) AS journey_purpose_missing,
    SUM(sex_of_driver = -1) AS sex_driver_missing,
    SUM(age_of_driver = -1) AS age_driver_missing,

    SUM(engine_capacity_cc = -1) AS engine_capacity_missing,
    SUM(propulsion_code = -1) AS propulsion_missing,
    SUM(age_of_vehicle = -1) AS vehicle_age_missing,

    SUM(generic_make_model = '-1') AS make_model_missing,
    SUM(driver_imd_decile = -1) AS imd_missing,
    SUM(lsoa_of_driver = '-1') AS lsoa_driver_missing,
    SUM(driver_distance_banding = -1) AS distance_banding_missing

FROM vehicle;


-- convert -1 values to NULL--

UPDATE vehicle
SET vehicle_type = NULL
WHERE vehicle_type = -1;

UPDATE vehicle
SET towing_and_articulation = NULL
WHERE towing_and_articulation = -1;

UPDATE vehicle
SET vehicle_manoeuvre = NULL
WHERE vehicle_manoeuvre = -1;

UPDATE vehicle
SET vehicle_direction_from = NULL
WHERE vehicle_direction_from = -1;

UPDATE vehicle
SET vehicle_direction_to = NULL
WHERE vehicle_direction_to = -1;

UPDATE vehicle
SET vehicle_location_restricted_lane = NULL
WHERE vehicle_location_restricted_lane = -1;

UPDATE vehicle
SET junction_location = NULL
WHERE junction_location = -1;

UPDATE vehicle
SET skidding_and_overturning = NULL
WHERE skidding_and_overturning = -1;

UPDATE vehicle
SET hit_object_in_carriageway = NULL
WHERE hit_object_in_carriageway = -1;

UPDATE vehicle
SET vehicle_leaving_carriageway = NULL
WHERE vehicle_leaving_carriageway = -1;

UPDATE vehicle
SET hit_object_off_carriageway = NULL
WHERE hit_object_off_carriageway = -1;

UPDATE vehicle
SET first_point_of_impact = NULL
WHERE first_point_of_impact = -1;

UPDATE vehicle
SET vehicle_left_hand_drive = NULL
WHERE vehicle_left_hand_drive = -1;

UPDATE vehicle
SET journey_purpose_of_driver = NULL
WHERE journey_purpose_of_driver = -1;

UPDATE vehicle
SET sex_of_driver = NULL
WHERE sex_of_driver = -1;

UPDATE vehicle
SET age_of_driver = NULL
WHERE age_of_driver = -1;

UPDATE vehicle
SET engine_capacity_cc = NULL
WHERE engine_capacity_cc = -1;

UPDATE vehicle
SET propulsion_code = NULL
WHERE propulsion_code = -1;

UPDATE vehicle
SET age_of_vehicle = NULL
WHERE age_of_vehicle = -1;

UPDATE vehicle
SET generic_make_model = NULL
WHERE generic_make_model = '-1';

UPDATE vehicle
SET driver_imd_decile = NULL
WHERE driver_imd_decile = -1;

UPDATE vehicle
SET lsoa_of_driver = NULL
WHERE lsoa_of_driver = '-1';

UPDATE vehicle
SET driver_distance_banding = NULL
WHERE driver_distance_banding = -1;

-- verify --

SELECT
    SUM(vehicle_type = -1) AS vehicle_type_remaining,
    SUM(towing_and_articulation = -1) AS towing_remaining,
    SUM(vehicle_manoeuvre = -1) AS manoeuvre_remaining,

    SUM(vehicle_direction_from = -1) AS direction_from_remaining,
    SUM(vehicle_direction_to = -1) AS direction_to_remaining,
    SUM(vehicle_location_restricted_lane = -1) AS restricted_lane_remaining,
    SUM(junction_location = -1) AS junction_location_remaining,

    SUM(skidding_and_overturning = -1) AS skidding_remaining,
    SUM(hit_object_in_carriageway = -1) AS hit_carriageway_remaining,
    SUM(vehicle_leaving_carriageway = -1) AS leaving_carriageway_remaining,
    SUM(hit_object_off_carriageway = -1) AS hit_off_carriageway_remaining,
    SUM(first_point_of_impact = -1) AS impact_remaining,
    SUM(vehicle_left_hand_drive = -1) AS left_hand_drive_remaining,

    SUM(journey_purpose_of_driver = -1) AS journey_purpose_remaining,
    SUM(sex_of_driver = -1) AS sex_driver_remaining,
    SUM(age_of_driver = -1) AS age_driver_remaining,

    SUM(engine_capacity_cc = -1) AS engine_capacity_remaining,
    SUM(propulsion_code = -1) AS propulsion_remaining,
    SUM(age_of_vehicle = -1) AS vehicle_age_remaining,

    SUM(generic_make_model = '-1') AS make_model_remaining,
    SUM(driver_imd_decile = -1) AS imd_remaining,
    SUM(lsoa_of_driver = '-1') AS lsoa_driver_remaining,
    SUM(driver_distance_banding = -1) AS distance_banding_remaining

FROM vehicle;

-- casualty cleaning -1 --

SELECT
    SUM(sex_of_casualty = -1) AS sex_missing,
    SUM(age_of_casualty = -1) AS age_missing,
    SUM(pedestrian_location = -1) AS pedestrian_location_missing,
    SUM(pedestrian_movement = -1) AS pedestrian_movement_missing,
    SUM(car_passenger = -1) AS car_passenger_missing,
    SUM(bus_or_coach_passenger = -1) AS bus_passenger_missing,
    SUM(pedestrian_road_maintenance_worker = -1) AS road_worker_missing,
    SUM(casualty_type = -1) AS casualty_type_missing,
    SUM(casualty_imd_decile = -1) AS imd_missing,
    SUM(lsoa_of_casualty = '-1') AS lsoa_missing,
    SUM(enhanced_casualty_severity = -1) AS enhanced_severity_missing,
    SUM(casualty_distance_banding = -1) AS distance_banding_missing
FROM casualty;

-- update --

UPDATE casualty
SET sex_of_casualty = NULL
WHERE sex_of_casualty = -1;

UPDATE casualty
SET age_of_casualty = NULL
WHERE age_of_casualty = -1;

UPDATE casualty
SET pedestrian_location = NULL
WHERE pedestrian_location = -1;

UPDATE casualty
SET pedestrian_movement = NULL
WHERE pedestrian_movement = -1;

UPDATE casualty
SET car_passenger = NULL
WHERE car_passenger = -1;

UPDATE casualty
SET bus_or_coach_passenger = NULL
WHERE bus_or_coach_passenger = -1;

UPDATE casualty
SET pedestrian_road_maintenance_worker = NULL
WHERE pedestrian_road_maintenance_worker = -1;

UPDATE casualty
SET casualty_type = NULL
WHERE casualty_type = -1;

UPDATE casualty
SET casualty_imd_decile = NULL
WHERE casualty_imd_decile = -1;

UPDATE casualty
SET lsoa_of_casualty = NULL
WHERE lsoa_of_casualty = '-1';

UPDATE casualty
SET enhanced_casualty_severity = NULL
WHERE enhanced_casualty_severity = -1;

UPDATE casualty
SET casualty_distance_banding = NULL
WHERE casualty_distance_banding = -1;

-- verify --
SELECT
    SUM(sex_of_casualty = -1) AS sex_missing,
    SUM(age_of_casualty = -1) AS age_missing,
    SUM(pedestrian_location = -1) AS pedestrian_location_missing,
    SUM(pedestrian_movement = -1) AS pedestrian_movement_missing,
    SUM(car_passenger = -1) AS car_passenger_missing,
    SUM(bus_or_coach_passenger = -1) AS bus_passenger_missing,
    SUM(pedestrian_road_maintenance_worker = -1) AS road_worker_missing,
    SUM(casualty_type = -1) AS casualty_type_missing,
    SUM(casualty_imd_decile = -1) AS imd_missing,
    SUM(lsoa_of_casualty = '-1') AS lsoa_missing,
    SUM(enhanced_casualty_severity = -1) AS enhanced_severity_missing,
    SUM(casualty_distance_banding = -1) AS distance_banding_missing
FROM casualty;