USE UK_Road_Safety_Analytics;

-- alter collision because the tables now have null instead of -1--

ALTER TABLE collision
    MODIFY police_force TINYINT UNSIGNED NOT NULL,
    MODIFY first_road_class TINYINT UNSIGNED NULL,
    MODIFY road_type TINYINT UNSIGNED NOT NULL,
    MODIFY junction_detail TINYINT UNSIGNED NULL,
    MODIFY junction_control TINYINT UNSIGNED NULL,
    MODIFY second_road_class TINYINT UNSIGNED NULL,
    MODIFY pedestrian_crossing TINYINT UNSIGNED NULL,
    MODIFY light_conditions TINYINT UNSIGNED NULL,
    MODIFY weather_conditions TINYINT UNSIGNED NULL,
    MODIFY road_surface_conditions TINYINT UNSIGNED NULL,
    MODIFY special_conditions_at_site TINYINT UNSIGNED NULL,
    MODIFY carriageway_hazards TINYINT UNSIGNED NULL,
    MODIFY urban_or_rural_area TINYINT UNSIGNED NULL,
    MODIFY enhanced_severity_collision TINYINT UNSIGNED NULL;


DESCRIBE collision;


-- checking if data in tables match the lookup tables--

-- collision_severity--
SELECT DISTINCT c.collision_severity
FROM collision c
LEFT JOIN collision_severity_lookup l
    ON c.collision_severity = l.collision_severity_code
WHERE l.collision_severity_code IS NULL;

-- police_force --
SELECT DISTINCT c.police_force
FROM collision c
LEFT JOIN police_force_lookup l
   ON c.police_force = l.police_force_code
WHERE l.police_force_code IS NULL;

-- first road class--
SELECT DISTINCT c.first_road_class
FROM collision c
LEFT JOIN road_class_lookup l
    ON c.first_road_class = l.road_class_code
WHERE c.first_road_class IS NOT NULL
  AND l.road_class_code IS NULL;

-- second road class--
SELECT DISTINCT c.second_road_class
FROM collision c
LEFT JOIN road_class_lookup l
    ON c.second_road_class = l.road_class_code
WHERE c.second_road_class IS NOT NULL
  AND l.road_class_code IS NULL;


-- road type--
SELECT DISTINCT c.road_type
FROM collision c
LEFT JOIN road_type_lookup l
    ON c.road_type = l.road_type_code
WHERE l.road_type_code IS NULL;

-- junction detail but here code is null--
SELECT DISTINCT c.junction_detail
FROM collision c
LEFT JOIN junction_detail_lookup l
    ON c.junction_detail = l.junction_detail_code
WHERE c.junction_detail IS NOT NULL
  AND l.junction_detail_code IS NULL;


-- junction control--
SELECT DISTINCT c.junction_control
FROM collision c
LEFT JOIN junction_control_lookup l
    ON c.junction_control = l.junction_control_code
WHERE c.junction_control IS NOT NULL
  AND l.junction_control_code IS NULL;

-- pedestrian crossing--
SELECT DISTINCT c.pedestrian_crossing
FROM collision c
LEFT JOIN pedestrian_crossing_lookup l
    ON c.pedestrian_crossing = l.pedestrian_crossing_code
WHERE c.pedestrian_crossing IS NOT NULL
  AND l.pedestrian_crossing_code IS NULL;

-- light conditions--
SELECT DISTINCT c.light_conditions
FROM collision c
LEFT JOIN light_conditions_lookup l
    ON c.light_conditions = l.light_conditions_code
WHERE c.light_conditions IS NOT NULL
  AND l.light_conditions_code IS NULL;


-- weather conditions--
SELECT DISTINCT c.weather_conditions
FROM collision c
LEFT JOIN weather_conditions_lookup l
    ON c.weather_conditions = l.weather_conditions_code
WHERE c.weather_conditions IS NOT NULL
  AND l.weather_conditions_code IS NULL;


-- road surface conditions--
SELECT DISTINCT c.road_surface_conditions
FROM collision c
LEFT JOIN road_surface_conditions_lookup l
    ON c.road_surface_conditions = l.road_surface_conditions_code
WHERE c.road_surface_conditions IS NOT NULL
  AND l.road_surface_conditions_code IS NULL;


-- special conditions at site--
SELECT DISTINCT c.special_conditions_at_site
FROM collision c
LEFT JOIN special_conditions_at_site_lookup l
    ON c.special_conditions_at_site = l.special_condition_code
WHERE c.special_conditions_at_site IS NOT NULL
  AND l.special_condition_code IS NULL;


-- carriageway hazards--
SELECT DISTINCT c.carriageway_hazards
FROM collision c
LEFT JOIN carriageway_hazards_lookup l
    ON c.carriageway_hazards = l.carriageway_hazard_code
WHERE c.carriageway_hazards IS NOT NULL
  AND l.carriageway_hazard_code IS NULL;


-- urban / rural--
SELECT DISTINCT c.urban_or_rural_area
FROM collision c
LEFT JOIN urban_rural_lookup l
    ON c.urban_or_rural_area = l.urban_rural_code
WHERE c.urban_or_rural_area IS NOT NULL
  AND l.urban_rural_code IS NULL;

-- enhanced severity--
SELECT DISTINCT c.enhanced_severity_collision
FROM collision c
LEFT JOIN enhanced_severity_lookup l
    ON c.enhanced_severity_collision = l.enhanced_severity_code
WHERE c.enhanced_severity_collision IS NOT NULL
  AND l.enhanced_severity_code IS NULL;



-- add all the foreign key constraints --

ALTER TABLE collision
ADD CONSTRAINT fk_collision_severity
  FOREIGN KEY (collision_severity)
  REFERENCES collision_severity_lookup (collision_severity_code);

ALTER TABLE collision

    ADD CONSTRAINT fk_collision_police_force
        FOREIGN KEY (police_force)
        REFERENCES police_force_lookup (police_force_code),

    ADD CONSTRAINT fk_collision_first_road_class
        FOREIGN KEY (first_road_class)
        REFERENCES road_class_lookup (road_class_code),

    ADD CONSTRAINT fk_collision_second_road_class
        FOREIGN KEY (second_road_class)
        REFERENCES road_class_lookup (road_class_code),

    ADD CONSTRAINT fk_collision_road_type
        FOREIGN KEY (road_type)
        REFERENCES road_type_lookup (road_type_code),

    ADD CONSTRAINT fk_collision_junction_detail
        FOREIGN KEY (junction_detail)
        REFERENCES junction_detail_lookup (junction_detail_code),

    ADD CONSTRAINT fk_collision_junction_control
        FOREIGN KEY (junction_control)
        REFERENCES junction_control_lookup (junction_control_code),

    ADD CONSTRAINT fk_collision_pedestrian_crossing
        FOREIGN KEY (pedestrian_crossing)
        REFERENCES pedestrian_crossing_lookup (pedestrian_crossing_code),

    ADD CONSTRAINT fk_collision_light_conditions
        FOREIGN KEY (light_conditions)
        REFERENCES light_conditions_lookup (light_conditions_code),

    ADD CONSTRAINT fk_collision_weather_conditions
        FOREIGN KEY (weather_conditions)
        REFERENCES weather_conditions_lookup (weather_conditions_code),

    ADD CONSTRAINT fk_collision_road_surface
        FOREIGN KEY (road_surface_conditions)
        REFERENCES road_surface_conditions_lookup (road_surface_conditions_code),

    ADD CONSTRAINT fk_collision_special_conditions
        FOREIGN KEY (special_conditions_at_site)
        REFERENCES special_conditions_at_site_lookup (special_condition_code),

    ADD CONSTRAINT fk_collision_carriageway_hazards
        FOREIGN KEY (carriageway_hazards)
        REFERENCES carriageway_hazards_lookup (carriageway_hazard_code),

    ADD CONSTRAINT fk_collision_urban_rural
        FOREIGN KEY (urban_or_rural_area)
        REFERENCES urban_rural_lookup (urban_rural_code),

    ADD CONSTRAINT fk_collision_enhanced_severity
        FOREIGN KEY (enhanced_severity_collision)
        REFERENCES enhanced_severity_lookup (enhanced_severity_code);


SHOW CREATE TABLE collision;
-- show full DDL--



-- vehicle table --

ALTER TABLE vehicle
    MODIFY vehicle_type TINYINT UNSIGNED NULL,
    MODIFY towing_and_articulation TINYINT UNSIGNED NULL,
    MODIFY vehicle_manoeuvre TINYINT UNSIGNED NULL,

    MODIFY vehicle_direction_from TINYINT UNSIGNED NULL,
    MODIFY vehicle_direction_to TINYINT UNSIGNED NULL,
    MODIFY vehicle_location_restricted_lane TINYINT UNSIGNED NULL,
    MODIFY junction_location TINYINT UNSIGNED NULL,

    MODIFY skidding_and_overturning TINYINT UNSIGNED NULL,
    MODIFY hit_object_in_carriageway TINYINT UNSIGNED NULL,
    MODIFY vehicle_leaving_carriageway TINYINT UNSIGNED NULL,
    MODIFY hit_object_off_carriageway TINYINT UNSIGNED NULL,
    MODIFY first_point_of_impact TINYINT UNSIGNED NULL,
    MODIFY vehicle_left_hand_drive TINYINT UNSIGNED NULL,

    MODIFY journey_purpose_of_driver TINYINT UNSIGNED NULL,
    MODIFY sex_of_driver TINYINT UNSIGNED NULL,
    MODIFY age_of_driver TINYINT UNSIGNED NULL,

    MODIFY engine_capacity_cc INT UNSIGNED NULL,
    MODIFY propulsion_code TINYINT UNSIGNED NULL,
    MODIFY age_of_vehicle SMALLINT UNSIGNED NULL,

    MODIFY driver_imd_decile TINYINT UNSIGNED NULL,
    MODIFY driver_distance_banding TINYINT UNSIGNED NULL;

DESCRIBE vehicle;

-- verification for vehicle lookup tables --


-- vehicle type --
SELECT DISTINCT v.vehicle_type
FROM vehicle v
LEFT JOIN vehicle_type_lookup l
    ON v.vehicle_type = l.vehicle_type_code
WHERE v.vehicle_type IS NOT NULL
  AND l.vehicle_type_code IS NULL;


-- towing / articulation --
SELECT DISTINCT v.towing_and_articulation
FROM vehicle v
LEFT JOIN towing_articulation_lookup l
    ON v.towing_and_articulation = l.towing_articulation_code
WHERE v.towing_and_articulation IS NOT NULL
  AND l.towing_articulation_code IS NULL;


-- vehicle manoeuvre --
SELECT DISTINCT v.vehicle_manoeuvre
FROM vehicle v
LEFT JOIN vehicle_manoeuvre_lookup l
    ON v.vehicle_manoeuvre = l.vehicle_manoeuvre_code
WHERE v.vehicle_manoeuvre IS NOT NULL
  AND l.vehicle_manoeuvre_code IS NULL;


-- direction from--
SELECT DISTINCT v.vehicle_direction_from
FROM vehicle v
LEFT JOIN vehicle_direction_lookup l
    ON v.vehicle_direction_from = l.vehicle_direction_code
WHERE v.vehicle_direction_from IS NOT NULL
  AND l.vehicle_direction_code IS NULL;


-- direction to--
SELECT DISTINCT v.vehicle_direction_to
FROM vehicle v
LEFT JOIN vehicle_direction_lookup l
    ON v.vehicle_direction_to = l.vehicle_direction_code
WHERE v.vehicle_direction_to IS NOT NULL
  AND l.vehicle_direction_code IS NULL;


-- restricted lane--
SELECT DISTINCT v.vehicle_location_restricted_lane
FROM vehicle v
LEFT JOIN vehicle_location_restricted_lane_lookup l
    ON v.vehicle_location_restricted_lane = l.restricted_lane_code
WHERE v.vehicle_location_restricted_lane IS NOT NULL
  AND l.restricted_lane_code IS NULL;


-- junction location--
SELECT DISTINCT v.junction_location
FROM vehicle v
LEFT JOIN junction_location_lookup l
    ON v.junction_location = l.junction_location_code
WHERE v.junction_location IS NOT NULL
  AND l.junction_location_code IS NULL;


-- skidding / overturning--
SELECT DISTINCT v.skidding_and_overturning
FROM vehicle v
LEFT JOIN skidding_overturning_lookup l
    ON v.skidding_and_overturning = l.skidding_overturning_code
WHERE v.skidding_and_overturning IS NOT NULL
  AND l.skidding_overturning_code IS NULL;


-- hit object in carriageway--
SELECT DISTINCT v.hit_object_in_carriageway
FROM vehicle v
LEFT JOIN hit_object_in_carriageway_lookup l
    ON v.hit_object_in_carriageway = l.hit_object_in_carriageway_code
WHERE v.hit_object_in_carriageway IS NOT NULL
  AND l.hit_object_in_carriageway_code IS NULL;


-- vehicle leaving carriageway--
SELECT DISTINCT v.vehicle_leaving_carriageway
FROM vehicle v
LEFT JOIN vehicle_leaving_carriageway_lookup l
    ON v.vehicle_leaving_carriageway = l.vehicle_leaving_carriageway_code
WHERE v.vehicle_leaving_carriageway IS NOT NULL
  AND l.vehicle_leaving_carriageway_code IS NULL;


-- hit object off carriageway--
SELECT DISTINCT v.hit_object_off_carriageway
FROM vehicle v
LEFT JOIN hit_object_off_carriageway_lookup l
    ON v.hit_object_off_carriageway = l.hit_object_off_carriageway_code
WHERE v.hit_object_off_carriageway IS NOT NULL
  AND l.hit_object_off_carriageway_code IS NULL;


-- first point of impact--
SELECT DISTINCT v.first_point_of_impact
FROM vehicle v
LEFT JOIN first_point_of_impact_lookup l
    ON v.first_point_of_impact = l.first_point_of_impact_code
WHERE v.first_point_of_impact IS NOT NULL
  AND l.first_point_of_impact_code IS NULL;


-- left hand drive--
SELECT DISTINCT v.vehicle_left_hand_drive
FROM vehicle v
LEFT JOIN left_hand_drive_lookup l
    ON v.vehicle_left_hand_drive = l.left_hand_drive_code
WHERE v.vehicle_left_hand_drive IS NOT NULL
  AND l.left_hand_drive_code IS NULL;


-- journey purpose --
SELECT DISTINCT v.journey_purpose_of_driver
FROM vehicle v
LEFT JOIN journey_purpose_lookup l
    ON v.journey_purpose_of_driver = l.journey_purpose_code
WHERE v.journey_purpose_of_driver IS NOT NULL
  AND l.journey_purpose_code IS NULL;


-- sex of driver --
SELECT DISTINCT v.sex_of_driver
FROM vehicle v
LEFT JOIN sex_of_driver_lookup l
    ON v.sex_of_driver = l.sex_of_driver_code
WHERE v.sex_of_driver IS NOT NULL
  AND l.sex_of_driver_code IS NULL;


-- propulsion --
SELECT DISTINCT v.propulsion_code
FROM vehicle v
LEFT JOIN propulsion_lookup l
    ON v.propulsion_code = l.propulsion_code
WHERE v.propulsion_code IS NOT NULL
  AND l.propulsion_code IS NULL;


-- driver IMD decile--
SELECT DISTINCT v.driver_imd_decile
FROM vehicle v
LEFT JOIN driver_imd_decile_lookup l
    ON v.driver_imd_decile = l.driver_imd_decile_code
WHERE v.driver_imd_decile IS NOT NULL
  AND l.driver_imd_decile_code IS NULL;


-- driver distance banding --
SELECT DISTINCT v.driver_distance_banding
FROM vehicle v
LEFT JOIN driver_distance_banding_lookup l
    ON v.driver_distance_banding = l.driver_distance_banding_code
WHERE v.driver_distance_banding IS NOT NULL
  AND l.driver_distance_banding_code IS NULL;

-- need to check if there are any vehicles whose collision index does not exist in the collision table--

SELECT COUNT(*) AS missing_index
FROM vehicle v
LEFT JOIN collision c
ON v.collision_index = c.collision_index
WHERE c.collision_index IS NULL;

-- add foreign keys now--

ALTER TABLE vehicle
    ADD CONSTRAINT fk_vehicle_collision
        FOREIGN KEY (collision_index)
        REFERENCES collision (collision_index),

    ADD CONSTRAINT fk_vehicle_type
        FOREIGN KEY (vehicle_type)
        REFERENCES vehicle_type_lookup (vehicle_type_code),

    ADD CONSTRAINT fk_vehicle_towing
        FOREIGN KEY (towing_and_articulation)
        REFERENCES towing_articulation_lookup (towing_articulation_code),

    ADD CONSTRAINT fk_vehicle_manoeuvre
        FOREIGN KEY (vehicle_manoeuvre)
        REFERENCES vehicle_manoeuvre_lookup (vehicle_manoeuvre_code),

    ADD CONSTRAINT fk_vehicle_direction_from
        FOREIGN KEY (vehicle_direction_from)
        REFERENCES vehicle_direction_lookup (vehicle_direction_code),

    ADD CONSTRAINT fk_vehicle_direction_to
        FOREIGN KEY (vehicle_direction_to)
        REFERENCES vehicle_direction_lookup (vehicle_direction_code),

    ADD CONSTRAINT fk_vehicle_restricted_lane
        FOREIGN KEY (vehicle_location_restricted_lane)
        REFERENCES vehicle_location_restricted_lane_lookup (restricted_lane_code),

    ADD CONSTRAINT fk_vehicle_junction_location
        FOREIGN KEY (junction_location)
        REFERENCES junction_location_lookup (junction_location_code),

    ADD CONSTRAINT fk_vehicle_skidding
        FOREIGN KEY (skidding_and_overturning)
        REFERENCES skidding_overturning_lookup (skidding_overturning_code),

    ADD CONSTRAINT fk_vehicle_hit_carriageway
        FOREIGN KEY (hit_object_in_carriageway)
        REFERENCES hit_object_in_carriageway_lookup (hit_object_in_carriageway_code),

    ADD CONSTRAINT fk_vehicle_leaving_carriageway
        FOREIGN KEY (vehicle_leaving_carriageway)
        REFERENCES vehicle_leaving_carriageway_lookup (vehicle_leaving_carriageway_code),

    ADD CONSTRAINT fk_vehicle_hit_off_carriageway
        FOREIGN KEY (hit_object_off_carriageway)
        REFERENCES hit_object_off_carriageway_lookup (hit_object_off_carriageway_code),

    ADD CONSTRAINT fk_vehicle_first_impact
        FOREIGN KEY (first_point_of_impact)
        REFERENCES first_point_of_impact_lookup (first_point_of_impact_code),

    ADD CONSTRAINT fk_vehicle_left_hand_drive
        FOREIGN KEY (vehicle_left_hand_drive)
        REFERENCES left_hand_drive_lookup (left_hand_drive_code),

    ADD CONSTRAINT fk_vehicle_journey_purpose
        FOREIGN KEY (journey_purpose_of_driver)
        REFERENCES journey_purpose_lookup (journey_purpose_code),

    ADD CONSTRAINT fk_vehicle_driver_sex
        FOREIGN KEY (sex_of_driver)
        REFERENCES sex_of_driver_lookup (sex_of_driver_code),

    ADD CONSTRAINT fk_vehicle_propulsion
        FOREIGN KEY (propulsion_code)
        REFERENCES propulsion_lookup (propulsion_code),

    ADD CONSTRAINT fk_vehicle_imd
        FOREIGN KEY (driver_imd_decile)
        REFERENCES driver_imd_decile_lookup (driver_imd_decile_code),

    ADD CONSTRAINT fk_vehicle_distance_banding
        FOREIGN KEY (driver_distance_banding)
        REFERENCES driver_distance_banding_lookup (driver_distance_banding_code);

-- casualty --

ALTER TABLE casualty
    MODIFY sex_of_casualty TINYINT UNSIGNED NULL,
    MODIFY age_of_casualty TINYINT UNSIGNED NULL,
    MODIFY pedestrian_location TINYINT UNSIGNED NULL,
    MODIFY pedestrian_movement TINYINT UNSIGNED NULL,
    MODIFY car_passenger TINYINT UNSIGNED NULL,
    MODIFY bus_or_coach_passenger TINYINT UNSIGNED NULL,
    MODIFY pedestrian_road_maintenance_worker TINYINT UNSIGNED NULL,
    MODIFY casualty_type TINYINT UNSIGNED NULL,
    MODIFY casualty_imd_decile TINYINT UNSIGNED NULL,
    MODIFY enhanced_casualty_severity TINYINT UNSIGNED NULL,
    MODIFY casualty_distance_banding TINYINT UNSIGNED NULL;

-- validate before adding fk --

-- casualty class--
SELECT DISTINCT c.casualty_class
FROM casualty c
LEFT JOIN casualty_class_lookup l
    ON c.casualty_class = l.casualty_class_code
WHERE l.casualty_class_code IS NULL;


-- sex of casualty--
SELECT DISTINCT c.sex_of_casualty
FROM casualty c
LEFT JOIN sex_of_casualty_lookup l
    ON c.sex_of_casualty = l.sex_of_casualty_code
WHERE c.sex_of_casualty IS NOT NULL
  AND l.sex_of_casualty_code IS NULL;


-- casualty severity--
SELECT DISTINCT c.casualty_severity
FROM casualty c
LEFT JOIN collision_severity_lookup l
    ON c.casualty_severity = l.collision_severity_code
WHERE l.collision_severity_code IS NULL;


-- pedestrian location--
SELECT DISTINCT c.pedestrian_location
FROM casualty c
LEFT JOIN pedestrian_location_lookup l
    ON c.pedestrian_location = l.pedestrian_location_code
WHERE c.pedestrian_location IS NOT NULL
  AND l.pedestrian_location_code IS NULL;


-- pedestrian movement--
SELECT DISTINCT c.pedestrian_movement
FROM casualty c
LEFT JOIN pedestrian_movement_lookup l
    ON c.pedestrian_movement = l.pedestrian_movement_code
WHERE c.pedestrian_movement IS NOT NULL
  AND l.pedestrian_movement_code IS NULL;


-- car passenger--
SELECT DISTINCT c.car_passenger
FROM casualty c
LEFT JOIN car_passenger_lookup l
    ON c.car_passenger = l.car_passenger_code
WHERE c.car_passenger IS NOT NULL
  AND l.car_passenger_code IS NULL;


-- bus / coach passenger--
SELECT DISTINCT c.bus_or_coach_passenger
FROM casualty c
LEFT JOIN bus_or_coach_passenger_lookup l
    ON c.bus_or_coach_passenger = l.bus_or_coach_passenger_code
WHERE c.bus_or_coach_passenger IS NOT NULL
  AND l.bus_or_coach_passenger_code IS NULL;


-- pedestrian road maintenance worker--
SELECT DISTINCT c.pedestrian_road_maintenance_worker
FROM casualty c
LEFT JOIN pedestrian_road_maintenance_worker_lookup l
    ON c.pedestrian_road_maintenance_worker = l.road_maintenance_worker_code
WHERE c.pedestrian_road_maintenance_worker IS NOT NULL
  AND l.road_maintenance_worker_code IS NULL;


-- casualty type--
SELECT DISTINCT c.casualty_type
FROM casualty c
LEFT JOIN casualty_type_lookup l
    ON c.casualty_type = l.casualty_type_code
WHERE c.casualty_type IS NOT NULL
  AND l.casualty_type_code IS NULL;


-- casualty IMD decile--
SELECT DISTINCT c.casualty_imd_decile
FROM casualty c
LEFT JOIN casualty_imd_decile_lookup l
    ON c.casualty_imd_decile = l.casualty_imd_decile_code
WHERE c.casualty_imd_decile IS NOT NULL
  AND l.casualty_imd_decile_code IS NULL;


-- enhanced casualty severity--
SELECT DISTINCT c.enhanced_casualty_severity
FROM casualty c
LEFT JOIN enhanced_severity_lookup l
    ON c.enhanced_casualty_severity = l.enhanced_severity_code
WHERE c.enhanced_casualty_severity IS NOT NULL
  AND l.enhanced_severity_code IS NULL;


-- casualty distance banding--
SELECT DISTINCT c.casualty_distance_banding
FROM casualty c
LEFT JOIN casualty_distance_banding_lookup l
    ON c.casualty_distance_banding = l.casualty_distance_banding_code
WHERE c.casualty_distance_banding IS NOT NULL
  AND l.casualty_distance_banding_code IS NULL;

-- add fk --

ALTER TABLE casualty
    ADD CONSTRAINT fk_casualty_collision
        FOREIGN KEY (collision_index)
        REFERENCES collision (collision_index),

    ADD CONSTRAINT fk_casualty_vehicle
        FOREIGN KEY (collision_index, vehicle_reference)
        REFERENCES vehicle (collision_index, vehicle_reference),

    ADD CONSTRAINT fk_casualty_class
        FOREIGN KEY (casualty_class)
        REFERENCES casualty_class_lookup (casualty_class_code),

    ADD CONSTRAINT fk_casualty_sex
        FOREIGN KEY (sex_of_casualty)
        REFERENCES sex_of_casualty_lookup (sex_of_casualty_code),

    ADD CONSTRAINT fk_casualty_severity
        FOREIGN KEY (casualty_severity)
        REFERENCES collision_severity_lookup (collision_severity_code),

    ADD CONSTRAINT fk_casualty_pedestrian_location
        FOREIGN KEY (pedestrian_location)
        REFERENCES pedestrian_location_lookup (pedestrian_location_code),

    ADD CONSTRAINT fk_casualty_pedestrian_movement
        FOREIGN KEY (pedestrian_movement)
        REFERENCES pedestrian_movement_lookup (pedestrian_movement_code),

    ADD CONSTRAINT fk_casualty_car_passenger
        FOREIGN KEY (car_passenger)
        REFERENCES car_passenger_lookup (car_passenger_code),

    ADD CONSTRAINT fk_casualty_bus_passenger
        FOREIGN KEY (bus_or_coach_passenger)
        REFERENCES bus_or_coach_passenger_lookup (bus_or_coach_passenger_code),

    ADD CONSTRAINT fk_casualty_road_worker
        FOREIGN KEY (pedestrian_road_maintenance_worker)
        REFERENCES pedestrian_road_maintenance_worker_lookup (road_maintenance_worker_code),

    ADD CONSTRAINT fk_casualty_type
        FOREIGN KEY (casualty_type)
        REFERENCES casualty_type_lookup (casualty_type_code),

    ADD CONSTRAINT fk_casualty_imd
        FOREIGN KEY (casualty_imd_decile)
        REFERENCES casualty_imd_decile_lookup (casualty_imd_decile_code),

    ADD CONSTRAINT fk_casualty_enhanced_severity
        FOREIGN KEY (enhanced_casualty_severity)
        REFERENCES enhanced_severity_lookup (enhanced_severity_code),

    ADD CONSTRAINT fk_casualty_distance_banding
        FOREIGN KEY (casualty_distance_banding)
        REFERENCES casualty_distance_banding_lookup (casualty_distance_banding_code);

-- adding checks --

ALTER TABLE collision
    ADD CONSTRAINT chk_collision_vehicle_count
        CHECK (number_of_vehicles >= 1),

    ADD CONSTRAINT chk_collision_casualty_count
        CHECK (number_of_casualties >= 1),

    ADD CONSTRAINT chk_collision_injury_based
        CHECK (collision_injury_based IN (0, 1));


ALTER TABLE vehicle
    ADD CONSTRAINT chk_vehicle_escooter_flag
        CHECK (escooter_flag IN (0, 1));


ALTER TABLE casualty
    ADD CONSTRAINT chk_casualty_injury_based
        CHECK (casualty_injury_based IN (0, 1));

ALTER TABLE collision
    ADD CONSTRAINT chk_collision_adjusted_serious
        CHECK (collision_adjusted_severity_serious BETWEEN 0 AND 1),

    ADD CONSTRAINT chk_collision_adjusted_slight
        CHECK (collision_adjusted_severity_slight BETWEEN 0 AND 1);


ALTER TABLE casualty
    ADD CONSTRAINT chk_casualty_adjusted_serious
        CHECK (casualty_adjusted_severity_serious BETWEEN 0 AND 1),

    ADD CONSTRAINT chk_casualty_adjusted_slight
        CHECK (casualty_adjusted_severity_slight BETWEEN 0 AND 1);