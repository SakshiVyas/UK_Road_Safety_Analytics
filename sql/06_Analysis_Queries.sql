USE UK_Road_Safety_Analytics;

-- how many total collisions , vehicles and casualties are there ?--
SELECT COUNT(*) AS total_collisions
FROM collision;

SELECT COUNT(*) AS total_vehicles
FROM vehicle;

SELECT COUNT(*) AS total_casualties
FROM casualty;

-- how have collisions and casualties changed by year? --

SELECT
    YEAR(c.collision_date) AS collision_year,
    COUNT(DISTINCT c.collision_index) AS total_collisions,
    COUNT(ca.casualty_reference) AS total_casualties
FROM collision c
LEFT JOIN casualty ca
    ON c.collision_index = ca.collision_index
GROUP BY YEAR(c.collision_date)
ORDER BY collision_year;

-- what proportions of collisions are fatal , serious and slight? --

SELECT l.severity_name,
    COUNT(*) AS total_collisions,
    ROUND (
        COUNT(*) * 100 / (SELECT COUNT(*) FROM collision), 2
    ) AS percentage
FROM collision c
JOIN collision_severity_lookup l
ON c.collision_severity = l.collision_severity_code
GROUP BY
    l.collision_severity_code, l.severity_name
ORDER BY total_collisions DESC ;

-- which road types have most collisions are how severe are they? --

SELECT  r.road_type_name,
        COUNT(*) AS total_collisions,
        SUM(c.collision_severity = 1) AS fatal_collisions,
        SUM(c.collision_severity = 2) AS serious_collisions,
        SUM(c.collision_severity = 3) AS slight_collisions
        FROM collision c
JOIN road_type_lookup r
ON c.road_type = r.road_type_code
GROUP BY
     r.road_type_code, r.road_type_name
ORDER BY total_collisions DESC ;


-- comparing severity rate --

SELECT
    r.road_type_name,
    COUNT(*) AS total_collisions,
    SUM( c.collision_severity IN (1,2)) AS serious_or_fatal_collisions,
    ROUND(
        SUM( c.collision_severity IN (1, 2) ) * 100.0 / COUNT(*), 2
    ) AS serious_or_fatal_percentage
FROM collision c
JOIN road_type_lookup r
ON c.road_type =r.road_type_code
GROUP BY
    r.road_type_code, r.road_type_name
ORDER BY serious_or_fatal_percentage DESC;

-- speed limit relate to collision severity--

SELECT c.speed_limit,
       COUNT(*) AS total_collisions,
       SUM(c.collision_severity = 1) AS fatal_collisions,
       SUM(c.collision_severity = 2) AS serious_collisions,
       SUM(c.collision_severity = 3) AS slight_collisions,
ROUND(
SUM(c.collision_severity IN (1,2)) * 100.0 /COUNT(*), 2
) AS serious_or_fatal_percentage
FROM collision c
WHERE c.speed_limit IS NOT NULL
GROUP BY c.speed_limit
ORDER BY c.speed_limit;

-- how do weather conditions relate to collision severity ?--

SELECT
    l.weather_conditions_name,
    COUNT(*) AS total_collisions,
    SUM( c.collision_severity IN (1,2)) AS serious_or_fatal_collisions,
    ROUND(
    SUM(c.collision_severity IN (1, 2)) * 100.0 / COUNT(*),2)
        AS serious_or_fatal_percentage
    FROM collision c
    JOIN weather_conditions_lookup l
    ON c.weather_conditions = l.weather_conditions_code
WHERE c.weather_conditions IS NOT NULL
GROUP BY l.weather_conditions_name;

-- how do light conditions relate to collision severity?--

SELECT
    l.light_conditions_name,
    COUNT(*) AS total_collisions,
    SUM( c.collision_severity IN (1,2)) AS serious_or_fatal_collisions,
    ROUND(
    SUM(c.collision_severity IN (1, 2)) * 100.0 / COUNT(*),2)
        AS serious_or_fatal_percentage
    FROM collision c
    JOIN light_conditions_lookup l
    ON c.light_conditions = l.light_conditions_code
WHERE c.light_conditions IS NOT NULL
GROUP BY l.light_conditions_name, l.light_conditions_code
ORDER BY serious_or_fatal_percentage DESC ;

-- how do surface road conditions relate to collision severity?--


SELECT
    r.road_surface_conditions_name,
    COUNT(*) AS total_collisions,
    SUM(c.collision_severity IN (1, 2)) AS serious_or_fatal_collisions,
    ROUND(
        SUM(c.collision_severity IN (1, 2)) * 100.0 / COUNT(*),
        2
    ) AS serious_or_fatal_percentage
FROM collision c
JOIN road_surface_conditions_lookup r
    ON c.road_surface_conditions = r.road_surface_conditions_code
WHERE c.road_surface_conditions IS NOT NULL
GROUP BY
    r.road_surface_conditions_code,
    r.road_surface_conditions_name
ORDER BY serious_or_fatal_percentage DESC;

-- which vehicle types are most frequently involved?--

SELECT vt.vehicle_type_name,
       COUNT(*) AS total_vehicles
FROM vehicle v
JOIN vehicle_type_lookup vt
ON v.vehicle_type = vt.vehicle_type_code
WHERE v.vehicle_type IS NOT NULL
GROUP BY  vt.vehicle_type_code,vt.vehicle_type_name
ORDER BY total_vehicles DESC ;

-- which vehicle types are involved in the highest proportion of serious/fatal collisions? --

SELECT
    vt.vehicle_type_name,
    COUNT(*) AS total_vehicle_records,
    SUM(c.collision_severity IN (1, 2)) AS serious_or_fatal_records,
    ROUND(
        SUM(c.collision_severity IN (1, 2)) * 100.0 / COUNT(*),
        2
    ) AS serious_or_fatal_percentage
FROM vehicle v
JOIN collision c
    ON v.collision_index = c.collision_index
JOIN vehicle_type_lookup vt
    ON v.vehicle_type = vt.vehicle_type_code
WHERE v.vehicle_type IS NOT NULL
GROUP BY
    vt.vehicle_type_code,
    vt.vehicle_type_name
ORDER BY serious_or_fatal_percentage DESC;

-- min max and avg recorded ages of driver records in each sex category?--

SELECT s.sex_of_driver_name,
       COUNT(*) AS total_drivers,
       ROUND(AVG(v.age_of_driver),1) AS average_age,
       MIN(v.age_of_driver) AS minimum_age,
       MAX(v.age_of_driver) AS maximum_age
FROM vehicle v
JOIN sex_of_driver_lookup s
ON v.sex_of_driver = s.sex_of_driver_code
WHERE v.age_of_driver IS NOT NULL
GROUP BY
    s.sex_of_driver_name,
    sex_of_driver_code
ORDER BY total_drivers DESC ;

-- which type of road users appear most often as casualties ?

SELECT ct.casualty_type_name,
       COUNT(*) AS total_casualties
FROM casualty c
JOIN casualty_type_lookup ct
ON c.casualty_type = ct.casualty_type_code
WHERE c.casualty_type IS NOT NULL
GROUP BY
    ct.casualty_type_code,
    ct.casualty_type_name
ORDER BY total_casualties DESC ;

-- which age and sex groups have higher proportions of serious or fatal casualties ?--
-- use age bands instead of creating 100 rows ---  USING CASE --

SELECT
    CASE
        WHEN ca.age_of_casualty BETWEEN 0 AND 15 THEN '0-15'
        WHEN ca.age_of_casualty BETWEEN 16 AND 24 THEN '16-24'
        WHEN ca.age_of_casualty BETWEEN 25 AND 44 THEN '25-44'
        WHEN ca.age_of_casualty BETWEEN 45 AND 64 THEN '45-64'
        WHEN ca.age_of_casualty BETWEEN 65 AND 74 THEN '65-74'
        ELSE '75+'
    END AS age_group,

    s.sex_of_casualty_name,
    COUNT(*) AS total_casualties,
    SUM(ca.casualty_severity IN (1, 2))
        AS serious_or_fatal_casualties,
    ROUND(
        SUM(ca.casualty_severity IN (1, 2))* 100.0 / COUNT(*), 2 )
        AS serious_or_fatal_percentage
FROM casualty ca
JOIN sex_of_casualty_lookup s
    ON ca.sex_of_casualty = s.sex_of_casualty_code
WHERE ca.age_of_casualty IS NOT NULL
  AND ca.sex_of_casualty IS NOT NULL
GROUP BY
    age_group,
    s.sex_of_casualty_code,
    s.sex_of_casualty_name
ORDER BY
    serious_or_fatal_percentage DESC;


-- selected vulnerable road user groups(using codebook) vs injury severity--

SELECT
    CASE
        WHEN ca.casualty_type = 0 THEN 'Pedestrian'
        WHEN ca.casualty_type = 1 THEN 'Cyclist'
        WHEN ca.casualty_type IN (2, 3, 4, 5, 23, 97, 103, 104, 105, 106)
            THEN 'Motorcyclist'
    END AS road_user_group,
    COUNT(*) AS total_casualties,
    SUM(ca.casualty_severity IN (1, 2))
        AS serious_or_fatal_casualties,
    ROUND(
        SUM(ca.casualty_severity IN (1, 2))* 100.0 / COUNT(*),  2)
        AS serious_or_fatal_percentage
FROM casualty ca
WHERE ca.casualty_type IN (
    0, 1,
    2, 3, 4, 5, 23, 97, 103, 104, 105, 106
)
GROUP BY road_user_group
ORDER BY serious_or_fatal_percentage DESC;

-- for each year and vehicle type , how many casualties were linked to that vehicle type and what proportion were serious or fatal?--

SELECT YEAR(c.collision_date) AS collision_year,
       vt.vehicle_type_name,
       COUNT(*) AS total_casualties,
       SUM(ca.casualty_severity IN (1, 2))
        AS serious_or_fatal_casualties,
    ROUND(
        SUM(ca.casualty_severity IN (1, 2))
        * 100.0 / COUNT(*),
        2
    ) AS serious_or_fatal_percentage

FROM collision c

JOIN vehicle v
    ON c.collision_index = v.collision_index

JOIN casualty ca
    ON v.collision_index = ca.collision_index
   AND v.vehicle_reference = ca.vehicle_reference

JOIN vehicle_type_lookup vt
    ON v.vehicle_type = vt.vehicle_type_code

WHERE v.vehicle_type IS NOT NULL

GROUP BY
    YEAR(c.collision_date),
    vt.vehicle_type_code,
    vt.vehicle_type_name

ORDER BY
    collision_year,
    serious_or_fatal_percentage DESC ;


-- which vehicle types have large casualty counts?--

SELECT
    vt.vehicle_type_name,
    COUNT(*) AS total_casualties
FROM vehicle v
JOIN casualty ca
ON v.collision_index = ca.collision_index
AND v.vehicle_reference = ca.vehicle_reference
JOIN vehicle_type_lookup vt
ON v.vehicle_type= vt.vehicle_type_code
GROUP BY vt.vehicle_type_code,
         vt.vehicle_type_name
HAVING COUNT(*) >= 1000
ORDER BY total_casualties DESC ;

-- how many serious /fatal collisions occurred each year?--

WITH yearly_severity AS (
    SELECT
        YEAR(collision_date) AS collision_year,
        COUNT(*) AS total_collisions,
        SUM(collision.collision_severity IN (1,2) ) AS serious_or_fatal_collisions
    FROM collision
    GROUP BY YEAR(collision_date)
)
SELECT collision_year, total_collisions, serious_or_fatal_collisions,
       ROUND(serious_or_fatal_collisions * 100.0 / total_collisions , 2) AS serious_or_fatal_percentage
FROM yearly_severity
ORDER BY collision_year;

-- how did the number of collisions change compared with the previous year?--


WITH yearly_collisions AS (
    SELECT
        YEAR(collision_date) AS collision_year,
        COUNT(*) AS total_collisions
    FROM collision
    GROUP BY YEAR(collision_date)
)
SELECT
    collision_year,
    total_collisions,
    LAG(total_collisions) OVER (
        ORDER BY collision_year
    ) AS previous_year_collisions,
    total_collisions
        - LAG(total_collisions) OVER (
            ORDER BY collision_year
        ) AS change_from_previous_year,
    ROUND((total_collisions
            - LAG(total_collisions) OVER (
                ORDER BY collision_year
            ))
        * 100.0
        / LAG(total_collisions) OVER (
            ORDER BY collision_year
        ), 2 ) AS percentage_change
FROM yearly_collisions
ORDER BY collision_year;

-- checking collisions where the recorded vehicle count does not match the actual number of vehicle rows --

SELECT
    c.collision_index,
    c.number_of_vehicles AS recorded_vehicles,
    COUNT(v.vehicle_reference) AS actual_vehicle_rows
FROM collision c
LEFT JOIN vehicle v
    ON c.collision_index = v.collision_index
GROUP BY
    c.collision_index,
    c.number_of_vehicles
HAVING c.number_of_vehicles <> COUNT(v.vehicle_reference);


-- does this collision have at least one casualty who was serious or fatal?--

SELECT
    c.collision_index,
    c.collision_date
FROM collision c
WHERE EXISTS (
    SELECT 1
    FROM casualty ca
    WHERE ca.collision_index = c.collision_index
      AND ca.casualty_severity IN (1, 2)
)
LIMIT 200;


-- counting vehicles for each collision --

SELECT
    c.collision_index,
    c.number_of_vehicles AS recorded_vehicles,
    (   SELECT COUNT(*)
        FROM vehicle v
        WHERE v.collision_index = c.collision_index
    ) AS actual_vehicle_rows
FROM collision c
LIMIT 100;


-- combining driver and casualty sex statistics--

SELECT
    'Driver' AS person_type,
    s.sex_of_driver_name AS sex,
    COUNT(*) AS total_records
FROM vehicle v
JOIN sex_of_driver_lookup s
    ON v.sex_of_driver = s.sex_of_driver_code
GROUP BY
    s.sex_of_driver_code,
    s.sex_of_driver_name

UNION ALL

SELECT
    'Casualty' AS person_type,
    s.sex_of_casualty_name AS sex,
    COUNT(*) AS total_records
FROM casualty ca
JOIN sex_of_casualty_lookup s
    ON ca.sex_of_casualty = s.sex_of_casualty_code
GROUP BY
    s.sex_of_casualty_code,
    s.sex_of_casualty_name;

-- give something , if it is null show 'Not recorded'--

SELECT
    collision_index,
    vehicle_reference,
    COALESCE(generic_make_model, 'Not recorded') AS make_model
FROM vehicle
LIMIT 100;

-- collisions without vehicle records --

SELECT
    c.collision_index,
    c.collision_date
FROM collision c
WHERE NOT EXISTS (
    SELECT 1
    FROM vehicle v
    WHERE v.collision_index = c.collision_index
);

-- finding unique vehicle models--

SELECT DISTINCT
    generic_make_model
FROM vehicle
WHERE generic_make_model IS NOT NULL
ORDER BY generic_make_model;

SELECT
    collision_index,
    vehicle_reference,
    generic_make_model
FROM vehicle
WHERE generic_make_model LIKE '%FORD%'
LIMIT 100;

-- serious or fatal collisions recorded on 60 or 70 mph roads --

SELECT
    collision_index,
    collision_date,
    speed_limit,
    collision_severity
FROM collision
WHERE speed_limit IN (60, 70)
  AND collision_severity IN (1, 2)
LIMIT 100;

-- check age of driver between 18 and 25--

SELECT collision_index, vehicle_reference, age_of_driver
FROM vehicle
WHERE age_of_driver BETWEEN 18 AND 25
ORDER BY age_of_driver
LIMIT 100;

