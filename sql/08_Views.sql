USE UK_Road_Safety_Analytics;


CREATE OR REPLACE VIEW vw_collision_summary AS
SELECT
    c.collision_index,
    c.collision_date,
    c.collision_time,
    c.longitude,
    c.latitude,
    c.number_of_vehicles,
    c.number_of_casualties,
    c.speed_limit,
    cs.severity_name,
    rt.road_type_name,
    w.weather_conditions_name AS weather_condition,
    l.light_conditions_name,
    rs.road_surface_conditions_name
FROM collision c
JOIN collision_severity_lookup cs
    ON c.collision_severity = cs.collision_severity_code
JOIN road_type_lookup rt
    ON c.road_type = rt.road_type_code
LEFT JOIN weather_conditions_lookup w
    ON c.weather_conditions = w.weather_conditions_code
LEFT JOIN light_conditions_lookup l
    ON c.light_conditions = l.light_conditions_code
LEFT JOIN road_surface_conditions_lookup rs
    ON c.road_surface_conditions = rs.road_surface_conditions_code;

SELECT * FROM vw_collision_summary
LIMIT 10;

CREATE OR REPLACE VIEW vw_casualty_detail AS
SELECT
    ca.collision_index,
    ca.casualty_reference,
    ca.vehicle_reference,

    c.collision_date,

    ct.casualty_type_name,
    sc.sex_of_casualty_name,
    ca.age_of_casualty,

    cs.severity_name AS casualty_severity,

    vt.vehicle_type_name,
    v.age_of_driver,
    v.generic_make_model

FROM casualty ca

JOIN collision c
    ON ca.collision_index = c.collision_index

JOIN vehicle v
    ON ca.collision_index = v.collision_index
   AND ca.vehicle_reference = v.vehicle_reference

LEFT JOIN casualty_type_lookup ct
    ON ca.casualty_type = ct.casualty_type_code

LEFT JOIN sex_of_casualty_lookup sc
    ON ca.sex_of_casualty = sc.sex_of_casualty_code

JOIN collision_severity_lookup cs
    ON ca.casualty_severity = cs.collision_severity_code

LEFT JOIN vehicle_type_lookup vt
    ON v.vehicle_type = vt.vehicle_type_code;

SELECT * FROM vw_casualty_detail
LIMIT 10;