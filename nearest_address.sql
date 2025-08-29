-- 61.50253682344901, 23.774215075037738
WITH clicked_point AS (
    SELECT ST_SetSRID(ST_MakePoint(23.774215075037738, 61.50253682344901), 4326)::geography AS clicked_point
)
SELECT id, street, house_number, postal_code,
       ST_Distance(
         geog,
         clicked_point
       ) AS dist_m
FROM address
CROSS JOIN clicked_point
ORDER BY geog <-> clicked_point
LIMIT 5;
