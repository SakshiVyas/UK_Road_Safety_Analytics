USE UK_Road_Safety_Analytics;

-- creating lookup tables for those columns which are coded--
-- columns from the codebook--
-- collision--


-- collision_severity --

CREATE TABLE collision_severity_lookup (
    collision_severity_code TINYINT UNSIGNED PRIMARY KEY ,
    severity_name VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO collision_severity_lookup (collision_severity_code, severity_name)
VALUES (1, 'Fatal'),
       (2,'Serious'),
       (3,'Slight');

SELECT * FROM collision_severity_lookup;

-- police_force --

CREATE TABLE police_force_lookup (
    police_force_code TINYINT UNSIGNED PRIMARY KEY,
    police_force_name VARCHAR(50) NOT NULL
);

INSERT INTO police_force_lookup (police_force_code, police_force_name)
VALUES
    (1, 'Metropolitan Police'),
    (3, 'Cumbria'),
    (4, 'Lancashire'),
    (5, 'Merseyside'),
    (6, 'Greater Manchester'),
    (7, 'Cheshire'),
    (10, 'Northumbria'),
    (11, 'Durham'),
    (12, 'North Yorkshire'),
    (13, 'West Yorkshire'),
    (14, 'South Yorkshire'),
    (16, 'Humberside'),
    (17, 'Cleveland'),
    (20, 'West Midlands'),
    (21, 'Staffordshire'),
    (22, 'West Mercia'),
    (23, 'Warwickshire'),
    (30, 'Derbyshire'),
    (31, 'Nottinghamshire'),
    (32, 'Lincolnshire'),
    (33, 'Leicestershire'),
    (34, 'Northamptonshire'),
    (35, 'Cambridgeshire'),
    (36, 'Norfolk'),
    (37, 'Suffolk'),
    (40, 'Bedfordshire'),
    (41, 'Hertfordshire'),
    (42, 'Essex'),
    (43, 'Thames Valley'),
    (44, 'Hampshire'),
    (45, 'Surrey'),
    (46, 'Kent'),
    (47, 'Sussex'),
    (48, 'City of London'),
    (50, 'Devon and Cornwall'),
    (52, 'Avon and Somerset'),
    (53, 'Gloucestershire'),
    (54, 'Wiltshire'),
    (55, 'Dorset'),
    (60, 'North Wales'),
    (61, 'Gwent'),
    (62, 'South Wales'),
    (63, 'Dyfed-Powys'),
    (91, 'Northern'),
    (92, 'Grampian'),
    (93, 'Tayside'),
    (94, 'Fife'),
    (95, 'Lothian and Borders'),
    (96, 'Central'),
    (97, 'Strathclyde'),
    (98, 'Dumfries and Galloway'),
    (99, 'Police Scotland');

SELECT * FROM police_force_lookup;



--  ROAD CLASS LOOKUP --
--  Will be used by BOTH first_road_class and second_road_class --


CREATE TABLE road_class_lookup (
    road_class_code TINYINT UNSIGNED PRIMARY KEY,
    road_class_name VARCHAR(50) NOT NULL
);

INSERT INTO road_class_lookup (road_class_code, road_class_name)
VALUES
    (0, 'Not at junction or within 20 metres'),
    (1, 'Motorway'),
    (2, 'A(M)'),
    (3, 'A'),
    (4, 'B'),
    (5, 'C'),
    (6, 'Unclassified'),
    (9, 'Unknown (self rep only)');



SELECT * FROM road_class_lookup;


-- ROAD TYPE LOOKUP --

CREATE TABLE road_type_lookup (
    road_type_code TINYINT UNSIGNED PRIMARY KEY,
    road_type_name VARCHAR(50) NOT NULL
);

INSERT INTO road_type_lookup (road_type_code, road_type_name)
VALUES
    (1, 'Roundabout'),
    (2, 'One way street'),
    (3, 'Dual carriageway'),
    (6, 'Single carriageway'),
    (7, 'Slip road'),
    (9, 'Unknown'),
    (12, 'One way street/Slip road');

SELECT * FROM road_type_lookup;



-- JUNCTION DETAIL LOOKUP --

CREATE TABLE junction_detail_lookup (
    junction_detail_code TINYINT UNSIGNED PRIMARY KEY,
    junction_detail_name VARCHAR(100) NOT NULL
);

INSERT INTO junction_detail_lookup
    (junction_detail_code, junction_detail_name)
VALUES
    (0, 'Not at junction or within 20 metres'),
    (13, 'T or staggered junction'),
    (16, 'Crossroads'),
    (17, 'Junction with more than four arms (not roundabout)'),
    (18, 'Using private drive or entrance'),
    (19, 'Other junction'),
    (99, 'unknown (self reported)');


SELECT * FROM junction_detail_lookup;



--  JUNCTION CONTROL LOOKUP --


CREATE TABLE junction_control_lookup (
    junction_control_code TINYINT UNSIGNED PRIMARY KEY,
    junction_control_name VARCHAR(50) NOT NULL
);

INSERT INTO junction_control_lookup
    (junction_control_code, junction_control_name)
VALUES
    (0, 'Not at junction or within 20 metres'),
    (1, 'Authorised person'),
    (2, 'Auto traffic signal'),
    (3, 'Stop sign'),
    (4, 'Give way or uncontrolled'),
    (9, 'unknown (self reported)');

SELECT * FROM junction_control_lookup;


--  PEDESTRIAN CROSSING LOOKUP --

CREATE TABLE pedestrian_crossing_lookup (
    pedestrian_crossing_code TINYINT UNSIGNED PRIMARY KEY,
    pedestrian_crossing_name VARCHAR(100) NOT NULL
);

INSERT INTO pedestrian_crossing_lookup
    (pedestrian_crossing_code, pedestrian_crossing_name)
VALUES
    (0, 'No physical crossing facility within 50m'),
    (11, 'Human crossing control by school crossing patrol'),
    (12, 'Human crossing control by other authorised person'),
    (13, 'Zebra crossing'),
    (14, 'Pedestrian light crossing (pelican or puffin or toucan or similar)'),
    (15, 'Pedestrian phase at traffic signal'),
    (16, 'Footbridge or subway'),
    (17, 'Central refuge - no other controls'),
    (99, 'unknown (self reported)');


SELECT * FROM pedestrian_crossing_lookup;



-- LIGHT CONDITIONS LOOKUP --

CREATE TABLE light_conditions_lookup (
    light_conditions_code TINYINT UNSIGNED PRIMARY KEY,
    light_conditions_name VARCHAR(50) NOT NULL
);

INSERT INTO light_conditions_lookup
    (light_conditions_code, light_conditions_name)
VALUES
    (1, 'Daylight'),
    (4, 'Darkness - lights lit'),
    (5, 'Darkness - lights unlit'),
    (6, 'Darkness - no lighting'),
    (7, 'Darkness - lighting unknown');

SELECT * FROM light_conditions_lookup;


--  WEATHER CONDITIONS LOOKUP--


CREATE TABLE weather_conditions_lookup (
    weather_conditions_code TINYINT UNSIGNED PRIMARY KEY,
    weather_conditions_name VARCHAR(50) NOT NULL
);

INSERT INTO weather_conditions_lookup
    (weather_conditions_code, weather_conditions_name)
VALUES
    (1, 'Fine no high winds'),
    (2, 'Raining no high winds'),
    (3, 'Snowing no high winds'),
    (4, 'Fine + high winds'),
    (5, 'Raining + high winds'),
    (6, 'Snowing + high winds'),
    (7, 'Fog or mist'),
    (8, 'Other'),
    (9, 'Unknown');


SELECT * FROM weather_conditions_lookup;



--  ROAD SURFACE CONDITIONS LOOKUP --


CREATE TABLE road_surface_conditions_lookup (
    road_surface_conditions_code TINYINT UNSIGNED PRIMARY KEY,
    road_surface_conditions_name VARCHAR(50) NOT NULL
);

INSERT INTO road_surface_conditions_lookup
    (road_surface_conditions_code, road_surface_conditions_name)
VALUES
    (1, 'Dry'),
    (2, 'Wet or damp'),
    (3, 'Snow'),
    (4, 'Frost or ice'),
    (5, 'Flood over 3cm. deep'),
    (6, 'Oil or diesel'),
    (7, 'Mud'),
    (9, 'unknown (self reported)');


SELECT * FROM road_surface_conditions_lookup;



-- SPECIAL CONDITIONS AT SITE LOOKUP --

CREATE TABLE special_conditions_at_site_lookup (
    special_condition_code TINYINT UNSIGNED PRIMARY KEY,
    special_condition_name VARCHAR(100) NOT NULL
);

INSERT INTO special_conditions_at_site_lookup
    (special_condition_code, special_condition_name)
VALUES
    (0, 'None'),
    (1, 'Auto traffic signal - out'),
    (2, 'Auto signal part defective'),
    (3, 'Road sign or marking defective or obscured'),
    (4, 'Roadworks'),
    (5, 'Road surface defective'),
    (6, 'Oil or diesel'),
    (7, 'Mud'),
    (9, 'unknown (self reported)');


SELECT * FROM special_conditions_at_site_lookup;


-- CARRIAGEWAY HAZARDS LOOKUP --

CREATE TABLE carriageway_hazards_lookup (
    carriageway_hazard_code TINYINT UNSIGNED PRIMARY KEY,
    carriageway_hazard_name VARCHAR(100) NOT NULL
);

INSERT INTO carriageway_hazards_lookup
    (carriageway_hazard_code, carriageway_hazard_name)
VALUES
    (0, 'None'),
    (11, 'Defective traffic signals'),
    (12, 'Permanent road signing or markings defective or obscured or inadequate'),
    (13, 'Roadworks'),
    (14, 'Oil or diesel'),
    (15, 'Mud'),
    (16, 'Dislodged vehicle load in carriageway'),
    (17, 'Other object in carriageway'),
    (18, 'Involvement with previous collision'),
    (19, 'Pedestrian in carriageway - not injured'),
    (20, 'Any animal in carriageway (except ridden horse)'),
    (21, 'Poor or defective road surface'),
    (99, 'unknown (self reported)');


SELECT  * FROM carriageway_hazards_lookup;


--  URBAN / RURAL LOOKUP --

CREATE TABLE urban_rural_lookup (
    urban_rural_code TINYINT UNSIGNED PRIMARY KEY,
    urban_rural_name VARCHAR(30) NOT NULL
);

INSERT INTO urban_rural_lookup
    (urban_rural_code, urban_rural_name)
VALUES
    (1, 'Urban'),
    (2, 'Rural'),
    (3, 'Unallocated');

SELECT * FROM urban_rural_lookup;


-- Enhanced_severity --

CREATE TABLE enhanced_severity_lookup (
    enhanced_severity_code TINYINT UNSIGNED PRIMARY KEY,
    enhanced_severity_name VARCHAR(30) NOT NULL
);

INSERT INTO enhanced_severity_lookup
    (enhanced_severity_code, enhanced_severity_name)
VALUES
    (1, 'Fatal'),
    (3, 'Slight'),
    (5, 'Very Serious'),
    (6, 'Moderately Serious'),
    (7, 'Less Serious');


SELECT * FROM enhanced_severity_lookup;


-- creating lookup tables for vehicle--


-- vehicle_type_lookup--

CREATE TABLE vehicle_type_lookup (
    vehicle_type_code TINYINT UNSIGNED PRIMARY KEY,
    vehicle_type_name VARCHAR(100) NOT NULL
);

INSERT INTO vehicle_type_lookup (vehicle_type_code, vehicle_type_name)
VALUES
    (1, 'Pedal cycle'),
    (2, 'Motorcycle 50cc and under'),
    (3, 'Motorcycle 125cc and under'),
    (4, 'Motorcycle over 125cc and up to 500cc'),
    (5, 'Motorcycle over 500cc'),
    (8, 'Taxi/Private hire car'),
    (9, 'Car'),
    (10, 'Minibus (8 - 16 passenger seats)'),
    (11, 'Bus or coach (17 or more pass seats)'),
    (16, 'Ridden horse'),
    (17, 'Agricultural vehicle'),
    (18, 'Tram'),
    (19, 'Van / Goods 3.5 tonnes mgw or under'),
    (20, 'Goods over 3.5t. and under 7.5t'),
    (21, 'Goods 7.5 tonnes mgw and over'),
    (22, 'Mobility scooter'),
    (23, 'Electric motorcycle'),
    (90, 'Other vehicle'),
    (97, 'Motorcycle - unknown cc'),
    (98, 'Goods vehicle - unknown weight'),
    (99, 'Unknown vehicle type (self rep only)'),
    (103, 'Motorcycle - Scooter (1979-1998)'),
    (104, 'Motorcycle (1979-1998)'),
    (105, 'Motorcycle - Combination (1979-1998)'),
    (106, 'Motorcycle over 125cc (1999-2004)'),
    (108, 'Taxi (excluding private hire cars) (1979-2004)'),
    (109, 'Car (including private hire cars) (1979-2004)'),
    (110, 'Minibus/Motor caravan (1979-1998)'),
    (113, 'Goods over 3.5 tonnes (1979-1998)');

SELECT * FROM  vehicle_type_lookup;


--  towing_articulation_lookup--


CREATE TABLE towing_articulation_lookup (
    towing_articulation_code TINYINT UNSIGNED PRIMARY KEY,
    towing_articulation_name VARCHAR(50) NOT NULL
);

INSERT INTO towing_articulation_lookup
VALUES
    (0, 'No tow/articulation'),
    (1, 'Articulated vehicle'),
    (2, 'Double or multiple trailer'),
    (3, 'Caravan'),
    (4, 'Single trailer'),
    (5, 'Other tow'),
    (9, 'unknown (self reported)');

SELECT * FROM towing_articulation_lookup;


--  vehicle manoeuvre lookup--

CREATE TABLE vehicle_manoeuvre_lookup (
    vehicle_manoeuvre_code TINYINT UNSIGNED PRIMARY KEY,
    vehicle_manoeuvre_name VARCHAR(100) NOT NULL
);

INSERT INTO vehicle_manoeuvre_lookup
VALUES
    (1, 'Reversing'),
    (2, 'Parked'),
    (3, 'Waiting to go ahead'),
    (4, 'Slowing or stopping'),
    (5, 'Moving off'),
    (6, 'U-turn'),
    (7, 'Turning left'),
    (8, 'Waiting to turn left'),
    (9, 'Turning right'),
    (10, 'Waiting to turn right'),
    (11, 'Changing lane to left'),
    (12, 'Changing lane to right'),
    (13, 'Over taking moving vehicle on its offside'),
    (14, 'Overtaking stationary vehicle on its offside'),
    (15, 'Overtaking on nearside (passengers side nearest kerb)'),
    (19, 'Going ahead'),
    (20, 'Parking'),
    (99, 'unknown (self reported)');


SELECT * FROM vehicle_manoeuvre_lookup;

--  vehicle direction lookup--
-- Used by BOTH vehicle_direction_from and vehicle_direction_to --

CREATE TABLE vehicle_direction_lookup (
    vehicle_direction_code TINYINT UNSIGNED PRIMARY KEY,
    vehicle_direction_name VARCHAR(30) NOT NULL
);

INSERT INTO vehicle_direction_lookup
VALUES
    (0, 'Parked'),
    (1, 'North'),
    (2, 'North East'),
    (3, 'East'),
    (4, 'South East'),
    (5, 'South'),
    (6, 'South West'),
    (7, 'West'),
    (8, 'North West'),
    (9, 'unknown (self reported)');


SELECT * FROM vehicle_direction_lookup;

--  RESTRICTED LANE LOOKUP --

CREATE TABLE vehicle_location_restricted_lane_lookup (
    restricted_lane_code TINYINT UNSIGNED PRIMARY KEY,
    restricted_lane_name VARCHAR(100) NOT NULL
);

INSERT INTO vehicle_location_restricted_lane_lookup
VALUES
    (0, 'On main carriageway (not in restricted lane)'),
    (1, 'Tram or Light rail track'),
    (2, 'Bus lane or Busway'),
    (4, 'Cycle lane (on main carriageway)'),
    (5, 'Cycleway or shared use footway (not part of main carriageway)'),
    (6, 'Lay-by or hard shoulder'),
    (9, 'Footway (pavement)'),
    (99, 'unknown (self reported)');

SELECT * FROM vehicle_location_restricted_lane_lookup;



--  JUNCTION LOCATION LOOKUP--

CREATE TABLE junction_location_lookup (
    junction_location_code TINYINT UNSIGNED PRIMARY KEY,
    junction_location_name VARCHAR(100) NOT NULL
);

INSERT INTO junction_location_lookup
VALUES
    (0, 'Not at or within 20 metres of junction'),
    (1, 'Approaching junction or waiting/parked at junction approach'),
    (2, 'Cleared junction or waiting/parked at junction exit'),
    (3, 'Leaving roundabout'),
    (4, 'Entering roundabout'),
    (5, 'Leaving main road'),
    (6, 'Entering main road'),
    (7, 'Entering from slip road'),
    (8, 'Mid Junction - on roundabout or on main road'),
    (9, 'unknown (self reported)');

SELECT * FROM junction_location_lookup;


-- SKIDDING / OVERTURNING LOOKUP--

CREATE TABLE skidding_overturning_lookup (
    skidding_overturning_code TINYINT UNSIGNED PRIMARY KEY,
    skidding_overturning_name VARCHAR(50) NULL
);

INSERT INTO skidding_overturning_lookup
VALUES
    (0, NULL),
    (1, 'Skidded'),
    (2, 'Skidded and overturned'),
    (3, 'Jackknifed'),
    (4, 'Jackknifed and overturned'),
    (5, 'Overturned'),
    (9, 'unknown (self reported)');


SELECT * FROM skidding_overturning_lookup;

UPDATE skidding_overturning_lookup
SET skidding_overturning_name = 'None'
WHERE skidding_overturning_code =0;

SELECT * FROM skidding_overturning_lookup
WHERE skidding_overturning_code =0;

-- HIT OBJECT IN CARRIAGEWAY LOOKUP --

CREATE TABLE hit_object_in_carriageway_lookup (
    hit_object_in_carriageway_code TINYINT UNSIGNED PRIMARY KEY,
    hit_object_in_carriageway_name VARCHAR(100) NULL
);

INSERT INTO hit_object_in_carriageway_lookup
VALUES
    (0, NULL),
    (1, 'Previous accident'),
    (2, 'Road works'),
    (4, 'Parked vehicle'),
    (5, 'Bridge (roof)'),
    (6, 'Bridge (side)'),
    (7, 'Bollard or refuge'),
    (8, 'Open door of vehicle'),
    (9, 'Central island of roundabout'),
    (10, 'Kerb'),
    (11, 'Other object'),
    (12, 'Any animal (except ridden horse)'),
    (99, 'unknown (self reported)');

SELECT * FROM hit_object_in_carriageway_lookup;

UPDATE hit_object_in_carriageway_lookup
SET hit_object_in_carriageway_name ='None'
WHERE hit_object_in_carriageway_code = 0;

SELECT * FROM hit_object_in_carriageway_lookup
WHERE hit_object_in_carriageway_code =0;

--  VEHICLE LEAVING CARRIAGEWAY LOOKUP --

CREATE TABLE vehicle_leaving_carriageway_lookup (
    vehicle_leaving_carriageway_code TINYINT UNSIGNED PRIMARY KEY,
    vehicle_leaving_carriageway_name VARCHAR(100) NOT NULL
);

INSERT INTO vehicle_leaving_carriageway_lookup
VALUES
    (0, 'Did not leave carriageway'),
    (1, 'Nearside'),
    (2, 'Nearside and rebounded'),
    (3, 'Straight ahead at junction'),
    (4, 'Offside on to central reservation'),
    (5, 'Offside on to centrl res + rebounded'),
    (6, 'Offside - crossed central reservation'),
    (7, 'Offside'),
    (8, 'Offside and rebounded'),
    (9, 'unknown (self reported)');

SELECT * FROM vehicle_leaving_carriageway_lookup;


--  HIT OBJECT OFF CARRIAGEWAY LOOKUP --

CREATE TABLE hit_object_off_carriageway_lookup (
    hit_object_off_carriageway_code TINYINT UNSIGNED PRIMARY KEY,
    hit_object_off_carriageway_name VARCHAR(100) NULL
);

INSERT INTO hit_object_off_carriageway_lookup
VALUES
    (0, NULL),
    (1, 'Road sign or traffic signal'),
    (2, 'Lamp post'),
    (3, 'Telegraph or electricity pole'),
    (4, 'Tree'),
    (5, 'Bus stop or bus shelter'),
    (6, 'Central crash barrier'),
    (7, 'Near/Offside crash barrier'),
    (8, 'Submerged in water'),
    (9, 'Entered ditch'),
    (10, 'Other permanent object'),
    (11, 'Wall or fence'),
    (99, 'unknown (self reported)');

SELECT * FROM hit_object_off_carriageway_lookup;

UPDATE hit_object_off_carriageway_lookup
SET hit_object_off_carriageway_name='None'
WHERE hit_object_off_carriageway_code = 0;

SELECT * FROM hit_object_off_carriageway_lookup
WHERE hit_object_off_carriageway_code =0;

--  FIRST POINT OF IMPACT LOOKUP --

CREATE TABLE first_point_of_impact_lookup (
    first_point_of_impact_code TINYINT UNSIGNED PRIMARY KEY,
    first_point_of_impact_name VARCHAR(30) NOT NULL
);

INSERT INTO first_point_of_impact_lookup
VALUES
    (0, 'Did not impact'),
    (1, 'Front'),
    (2, 'Back'),
    (3, 'Offside'),
    (4, 'Nearside'),
    (9, 'unknown (self reported)');

SELECT * FROM first_point_of_impact_lookup;


--  LEFT HAND DRIVE LOOKUP --

CREATE TABLE left_hand_drive_lookup (
    left_hand_drive_code TINYINT UNSIGNED PRIMARY KEY,
    left_hand_drive_name VARCHAR(20) NOT NULL
);

INSERT INTO left_hand_drive_lookup
VALUES
    (1, 'No'),
    (2, 'Yes'),
    (9, 'Unknown');

SELECT * FROM left_hand_drive_lookup;


--  JOURNEY PURPOSE LOOKUP --

CREATE TABLE journey_purpose_lookup (
    journey_purpose_code TINYINT UNSIGNED PRIMARY KEY,
    journey_purpose_name VARCHAR(100) NOT NULL
);

INSERT INTO journey_purpose_lookup
VALUES
    (1, 'Journey as part of work'),
    (2, 'Commuting to or from work'),
    (6, 'Not known or not requested'),
    (7, 'Education and educational escort'),
    (8, 'Emergency vehicle (blue light) on response'),
    (9, 'Personal business or leisure');

SELECT * FROM journey_purpose_lookup;



--  SEX OF DRIVER LOOKUP--

CREATE TABLE sex_of_driver_lookup (
    sex_of_driver_code TINYINT UNSIGNED PRIMARY KEY,
    sex_of_driver_name VARCHAR(20) NOT NULL
);

INSERT INTO sex_of_driver_lookup
VALUES
    (1, 'Male'),
    (2, 'Female'),
    (3, 'Not known');

SELECT * FROM sex_of_driver_lookup;


--  PROPULSION LOOKUP --

CREATE TABLE propulsion_lookup (
    propulsion_code TINYINT UNSIGNED PRIMARY KEY,
    propulsion_name VARCHAR(50) NOT NULL
);

INSERT INTO propulsion_lookup
VALUES
    (1, 'Petrol'),
    (2, 'Heavy oil'),
    (3, 'Electric'),
    (4, 'Steam'),
    (5, 'Gas'),
    (6, 'Petrol/Gas (LPG)'),
    (7, 'Gas/Bi-fuel'),
    (8, 'Hybrid electric'),
    (9, 'Gas Diesel'),
    (10, 'New fuel technology'),
    (11, 'Fuel cells'),
    (12, 'Electric diesel');

SELECT * FROM propulsion_lookup;

--  DRIVER IMD DECILE LOOKUP --

CREATE TABLE driver_imd_decile_lookup (
    driver_imd_decile_code TINYINT UNSIGNED PRIMARY KEY,
    driver_imd_decile_name VARCHAR(50) NOT NULL
);

INSERT INTO driver_imd_decile_lookup
VALUES
    (1, 'Most deprived 10%'),
    (2, 'More deprived 10-20%'),
    (3, 'More deprived 20-30%'),
    (4, 'More deprived 30-40%'),
    (5, 'More deprived 40-50%'),
    (6, 'Less deprived 40-50%'),
    (7, 'Less deprived 30-40%'),
    (8, 'Less deprived 20-30%'),
    (9, 'Less deprived 10-20%'),
    (10, 'Least deprived 10%');

SELECT * FROM driver_imd_decile_lookup;


--  DRIVER DISTANCE BANDING LOOKUP --

CREATE TABLE driver_distance_banding_lookup (
    driver_distance_banding_code TINYINT UNSIGNED PRIMARY KEY,
    driver_distance_banding_name VARCHAR(100) NOT NULL
);

INSERT INTO driver_distance_banding_lookup
VALUES
    (1, 'Collision occurred within 5km of drivers home postcode'),
    (2, 'Collision occurred between 5.001 and 10km of drivers home postcode'),
    (3, 'Collision occurred between 10.001 and 20km of drivers home postcode'),
    (4, 'Collision occurred between 20.001 and 100km of drivers home postcode'),
    (5, 'Collision occurred over 100km of drivers home postcode');

SELECT * FROM driver_distance_banding_lookup;


-- casualty lookup tables--

--  CASUALTY CLASS LOOKUP --

CREATE TABLE casualty_class_lookup (
    casualty_class_code TINYINT UNSIGNED PRIMARY KEY,
    casualty_class_name VARCHAR(30) NOT NULL
);

INSERT INTO casualty_class_lookup
VALUES
    (1, 'Driver or rider'),
    (2, 'Passenger'),
    (3, 'Pedestrian');

SELECT * FROM casualty_class_lookup;


--  SEX OF CASUALTY LOOKUP --

CREATE TABLE sex_of_casualty_lookup (
    sex_of_casualty_code TINYINT UNSIGNED PRIMARY KEY,
    sex_of_casualty_name VARCHAR(30) NOT NULL
);

INSERT INTO sex_of_casualty_lookup
VALUES
    (1, 'Male'),
    (2, 'Female'),
    (9, 'unknown (self reported)');

SELECT * FROM sex_of_casualty_lookup;


-- PEDESTRIAN LOCATION LOOKUP --

CREATE TABLE pedestrian_location_lookup (
    pedestrian_location_code TINYINT UNSIGNED PRIMARY KEY,
    pedestrian_location_name VARCHAR(120) NOT NULL
);

INSERT INTO pedestrian_location_lookup
VALUES
    (0, 'Not a Pedestrian'),
    (1, 'Crossing on pedestrian crossing facility'),
    (2, 'Crossing in zig-zag approach lines'),
    (3, 'Crossing in zig-zag exit lines'),
    (4, 'Crossing elsewhere within 50m. of pedestrian crossing'),
    (5, 'In carriageway, crossing elsewhere'),
    (6, 'On footway or verge'),
    (7, 'On refuge, central island or central reservation'),
    (8, 'In centre of carriageway - not on refuge, island or central reservation'),
    (9, 'In carriageway, not crossing'),
    (10, 'Unknown or other');

SELECT * FROM pedestrian_location_lookup;


--  PEDESTRIAN MOVEMENT LOOKUP --

CREATE TABLE pedestrian_movement_lookup (
    pedestrian_movement_code TINYINT UNSIGNED PRIMARY KEY,
    pedestrian_movement_name VARCHAR(150) NOT NULL
);

INSERT INTO pedestrian_movement_lookup
VALUES
    (0, 'Not a Pedestrian'),
    (1, 'Crossing from driver''s nearside'),
    (2, 'Crossing from nearside - masked by parked or stationary vehicle'),
    (3, 'Crossing from driver''s offside'),
    (4, 'Crossing from offside - masked by parked or stationary vehicle'),
    (5, 'In carriageway, stationary - not crossing (standing or playing)'),
    (6, 'In carriageway, stationary - not crossing (standing or playing) - masked by parked or stationary vehicle'),
    (7, 'Walking along in carriageway, facing traffic'),
    (8, 'Walking along in carriageway, back to traffic'),
    (9, 'Unknown or other');

SELECT * FROM pedestrian_movement_lookup;


-- CAR PASSENGER LOOKUP --

CREATE TABLE car_passenger_lookup (
    car_passenger_code TINYINT UNSIGNED PRIMARY KEY,
    car_passenger_name VARCHAR(50) NOT NULL
);

INSERT INTO car_passenger_lookup
VALUES
    (0, 'Not car passenger'),
    (1, 'Front seat passenger'),
    (2, 'Rear seat passenger'),
    (9, 'unknown (self reported)');

SELECT * FROM car_passenger_lookup;


--  BUS / COACH PASSENGER LOOKUP --

CREATE TABLE bus_or_coach_passenger_lookup (
    bus_or_coach_passenger_code TINYINT UNSIGNED PRIMARY KEY,
    bus_or_coach_passenger_name VARCHAR(60) NOT NULL
);

INSERT INTO bus_or_coach_passenger_lookup
VALUES
    (0, 'Not a bus or coach passenger'),
    (1, 'Boarding'),
    (2, 'Alighting'),
    (3, 'Standing passenger'),
    (4, 'Seated passenger'),
    (9, 'unknown (self reported)');

SELECT * FROM bus_or_coach_passenger_lookup;


--  PEDESTRIAN ROAD MAINTENANCE WORKER LOOKUP --

CREATE TABLE pedestrian_road_maintenance_worker_lookup (
    road_maintenance_worker_code TINYINT UNSIGNED PRIMARY KEY,
    road_maintenance_worker_name VARCHAR(40) NOT NULL
);

INSERT INTO pedestrian_road_maintenance_worker_lookup
VALUES
    (0, 'No / Not applicable'),
    (1, 'Yes'),
    (2, 'Not Known'),
    (3, 'Probable');

SELECT * FROM pedestrian_road_maintenance_worker_lookup;


--  CASUALTY TYPE LOOKUP --

CREATE TABLE casualty_type_lookup (
    casualty_type_code TINYINT UNSIGNED PRIMARY KEY,
    casualty_type_name VARCHAR(120) NOT NULL
);

INSERT INTO casualty_type_lookup
VALUES
    (0, 'Pedestrian'),
    (1, 'Cyclist'),
    (2, 'Motorcycle 50cc and under rider or passenger'),
    (3, 'Motorcycle 125cc and under rider or passenger'),
    (4, 'Motorcycle over 125cc and up to 500cc rider or passenger'),
    (5, 'Motorcycle over 500cc rider or passenger'),
    (8, 'Taxi/Private hire car occupant'),
    (9, 'Car occupant'),
    (10, 'Minibus (8 - 16 passenger seats) occupant'),
    (11, 'Bus or coach occupant (17 or more pass seats)'),
    (16, 'Horse rider'),
    (17, 'Agricultural vehicle occupant'),
    (18, 'Tram occupant'),
    (19, 'Van / Goods vehicle (3.5 tonnes mgw or under) occupant'),
    (20, 'Goods vehicle (over 3.5t. and under 7.5t.) occupant'),
    (21, 'Goods vehicle (7.5 tonnes mgw and over) occupant'),
    (22, 'Mobility scooter rider'),
    (23, 'Electric motorcycle rider or passenger'),
    (90, 'Other vehicle occupant'),
    (97, 'Motorcycle - unknown cc rider or passenger'),
    (98, 'Goods vehicle (unknown weight) occupant'),
    (99, 'Unknown vehicle type (self rep only)'),
    (103, 'Motorcycle - Scooter (1979-1998)'),
    (104, 'Motorcycle (1979-1998)'),
    (105, 'Motorcycle - Combination (1979-1998)'),
    (106, 'Motorcycle over 125cc (1999-2004)'),
    (108, 'Taxi (excluding private hire cars) (1979-2004)'),
    (109, 'Car (including private hire cars) (1979-2004)'),
    (110, 'Minibus/Motor caravan (1979-1998)'),
    (113, 'Goods over 3.5 tonnes (1979-1998)');

SELECT * FROM casualty_type_lookup;


--  CASUALTY IMD DECILE LOOKUP --

CREATE TABLE casualty_imd_decile_lookup (
    casualty_imd_decile_code TINYINT UNSIGNED PRIMARY KEY,
    casualty_imd_decile_name VARCHAR(50) NOT NULL
);

INSERT INTO casualty_imd_decile_lookup
VALUES
    (1, 'Most deprived 10%'),
    (2, 'More deprived 10-20%'),
    (3, 'More deprived 20-30%'),
    (4, 'More deprived 30-40%'),
    (5, 'More deprived 40-50%'),
    (6, 'Less deprived 40-50%'),
    (7, 'Less deprived 30-40%'),
    (8, 'Less deprived 20-30%'),
    (9, 'Less deprived 10-20%'),
    (10, 'Least deprived 10%');

SELECT * FROM casualty_imd_decile_lookup;


--  CASUALTY DISTANCE BANDING LOOKUP --

CREATE TABLE casualty_distance_banding_lookup (
    casualty_distance_banding_code TINYINT UNSIGNED PRIMARY KEY,
    casualty_distance_banding_name VARCHAR(100) NOT NULL
);

INSERT INTO casualty_distance_banding_lookup
VALUES
    (1, 'Collision occurred within 5km of casualties home postcode'),
    (2, 'Collision occurred between 5.001 and 10km of casualties home postcode'),
    (3, 'Collision occurred between 10.001 and 20km of casualties home postcode'),
    (4, 'Collision occurred between 20.001 and 100km of casualties home postcode'),
    (5, 'Collision occurred over 100km of casualties home postcode');

SELECT * FROM casualty_distance_banding_lookup;

