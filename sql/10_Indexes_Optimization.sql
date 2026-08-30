USE UK_Road_Safety_Analytics;

SHOW INDEX FROM collision;

SHOW INDEX FROM vehicle;

SHOW INDEX FROM casualty;


-- serious /fatal collisions during 2024 and their casualty counts --
-- using explain analyze to ensure execution and actual measurements --


EXPLAIN ANALYZE
SELECT
    c.collision_index,
    c.collision_date,
    c.collision_severity,
    COUNT(ca.casualty_reference) AS casualty_count
FROM collision c
JOIN casualty ca
    ON c.collision_index = ca.collision_index
WHERE c.collision_date >= '2024-01-01'
  AND c.collision_date < '2025-01-01'
  AND c.collision_severity IN (1, 2)
GROUP BY
    c.collision_index,
    c.collision_date,
    c.collision_severity;

CREATE INDEX idx_collision_severity_date
ON collision (collision_severity, collision_date);

EXPLAIN ANALYZE
SELECT
    c.collision_index,
    c.collision_date,
    c.collision_severity,
    COUNT(ca.casualty_reference) AS casualty_count
FROM collision c
JOIN casualty ca
    ON c.collision_index = ca.collision_index
WHERE c.collision_date >= '2024-01-01'
  AND c.collision_date < '2025-01-01'
  AND c.collision_severity IN (1, 2)
GROUP BY
    c.collision_index,
    c.collision_date,
    c.collision_severity;


-- comparing YEAR usage on indexed column --

EXPLAIN ANALYZE
SELECT
    collision_index,
    collision_date,
    collision_severity
FROM collision
WHERE YEAR(collision_date) = 2024
  AND collision_severity IN (1, 2);

EXPLAIN ANALYZE
SELECT
    collision_index,
    collision_date,
    collision_severity
FROM collision
WHERE collision_date >= '2024-01-01'
  AND collision_date < '2025-01-01'
  AND collision_severity IN (1, 2);
-- this is better as it uses range --

-- filtering collisions by speed_limit and severity --

EXPLAIN ANALYZE
SELECT
    speed_limit,
    collision_severity,
    COUNT(*) AS collision_count
FROM collision
WHERE speed_limit IN (30, 40, 50, 60, 70)
  AND collision_severity IN (1, 2)
GROUP BY
    speed_limit,
    collision_severity;

CREATE INDEX idx_collision_speed_severity
ON collision (
    speed_limit,
    collision_severity
);

EXPLAIN ANALYZE
SELECT
    speed_limit,
    collision_severity,
    COUNT(*) AS collision_count
FROM collision
WHERE speed_limit IN (30, 40, 50, 60, 70)
  AND collision_severity IN (1, 2)
GROUP BY
    speed_limit,
    collision_severity;

-- Optimization result:
-- MySQL used idx_collision_speed_severity with a covering index range scan.
-- The query only requires speed_limit and collision_severity, both of which are stored in the composite index, reducing the need to access full table rows.--
