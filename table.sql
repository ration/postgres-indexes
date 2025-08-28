CREATE TABLE address (
    id bigint PRIMARY KEY,
    street VARCHAR(255) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    house_number VARCHAR(20),
    staircase VARCHAR(20),
    apartment VARCHAR(20)
);
CREATE UNIQUE INDEX address_pkey ON address USING BTREE(id);


--DROP TABLE Address;


CREATE TABLE address (
    id bigint,
    street VARCHAR(255) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    house_number VARCHAR(20),
    staircase VARCHAR(20),
    apartment VARCHAR(20)
);
CREATE UNIQUE INDEX address_pkey ON address USING BTREE(id);