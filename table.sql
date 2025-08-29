-- CREATE TABLE address (
--     id bigint PRIMARY KEY,
--     street VARCHAR(255) NOT NULL,
--     postal_code VARCHAR(20) NOT NULL,
--     house_number VARCHAR(20),
--     staircase VARCHAR(20),
--     apartment VARCHAR(20)
-- );
-- CREATE UNIQUE INDEX address_pkey ON address USING BTREE(id);


--DROP TABLE Address;


-- CREATE TABLE address (
--     id bigint,
--     street VARCHAR(255) NOT NULL,
--     postal_code VARCHAR(20) NOT NULL,
--     house_number VARCHAR(20),
--     staircase VARCHAR(20),
--     apartment VARCHAR(20)
-- );
-- CREATE UNIQUE INDEX address_pkey ON address USING BTREE(id);



CREATE TABLE address (
    id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    street VARCHAR(255) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    house_number VARCHAR(20),
    staircase VARCHAR(20),
    apartment VARCHAR(20),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION
);


ALTER TABLE address
ADD COLUMN search tsvector
GENERATED ALWAYS AS (
    setweight(to_tsvector('finnish', coalesce(postal_code, '')), 'A')
    || setweight(to_tsvector('finnish', coalesce(street, '')), 'B')
    || setweight(to_tsvector(
        'finnish',
        -- Add space between number and letter in house number, apartment, and staircase (e.g. "12A" -> "12 A")
        regexp_replace(coalesce(house_number, ''), '([0-9]+)([a-zA-Z]+)', '\1 \2', 'g')
    ), 'C')
    || setweight(to_tsvector(
        'finnish',
        regexp_replace(coalesce(apartment, ''), '([0-9]+)([a-zA-Z]+)', '\1 \2', 'g')
    ), 'C')
    || setweight(to_tsvector(
        'finnish',
        regexp_replace(coalesce(staircase, ''), '([0-9]+)([a-zA-Z]+)', '\1 \2', 'g')
    ), 'C')
)
STORED;

CREATE INDEX address_search_idx ON address USING gin (search);


-- GIST

CREATE EXTENSION IF NOT EXISTS postgis;

ALTER TABLE address drop column if exists geom;

ALTER TABLE address
ADD COLUMN geog geography(Point, 4326)
GENERATED ALWAYS AS (
  ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography
) STORED;

CREATE INDEX address_geom_gist_idx ON address USING gist (geog);

-- SELECT * from address