-- dropping enum types
DROP TYPE IF EXISTS nationality_enum CASCADE;
DROP TYPE IF EXISTS priority_enum CASCADE;
DROP TYPE IF EXISTS difficulty_enum CASCADE;
DROP TYPE IF EXISTS consequences_enum CASCADE;
DROP TYPE IF EXISTS type_of_government_enum CASCADE;

-- dropping tables 
DROP TABLE IF EXISTS human_troubles CASCADE;
DROP TABLE IF EXISTS ship_troubles CASCADE;
DROP TABLE IF EXISTS human CASCADE;
DROP TABLE IF EXISTS human_origin CASCADE;
DROP TABLE IF EXISTS ship CASCADE;
DROP TABLE IF EXISTS ship_type CASCADE;
DROP TABLE IF EXISTS place CASCADE;
DROP TABLE IF EXISTS troubles CASCADE;
DROP TABLE IF EXISTS antenna CASCADE;

-- dropping domains
DROP DOMAIN IF EXISTS positive_integer CASCADE;
DROP DOMAIN IF EXISTS positive_decimal CASCADE;
DROP DOMAIN IF EXISTS max_speed_constraint CASCADE;
DROP DOMAIN IF EXISTS range_constraint CASCADE;
DROP DOMAIN IF EXISTS power_capacity_constraint CASCADE;
DROP DOMAIN IF EXISTS gain_constraint CASCADE;
DROP DOMAIN IF EXISTS ship_capacity_constraint CASCADE;
DROP DOMAIN IF EXISTS age_constraint CASCADE;

-- creating enums if they're exists
CREATE TYPE nationality_enum AS ENUM ('American', 'British', 'Canadian', 'Chinese', 'French', 'German', 'Indian', 'Japanese', 'Russian', 'Spanish');
CREATE TYPE priority_enum AS ENUM ('high', 'medium', 'low');
CREATE TYPE difficulty_enum AS ENUM ('easy', 'moderate', 'hard');
CREATE TYPE consequences_enum AS ENUM ('minimal', 'moderate', 'severe', 'catastrophic');
CREATE TYPE type_of_government_enum AS ENUM ('democracy', 'monarchy', 'dictatorship', 'communism', 'socialism', 'republic', 'constitutional monarchy', 'parliamentary republic', 'parliamentary democracy', 'federal semi-presidential republic', 'federal presidential republic', 'federal parliamentary constitutional republic', 'absolute monarchy');

-- create domain's
CREATE DOMAIN positive_integer AS INTEGER
CHECK (VALUE > 0);

CREATE DOMAIN positive_decimal AS DECIMAL
CHECK (VALUE > 0);

CREATE DOMAIN max_speed_constraint AS positive_integer;
CREATE DOMAIN range_constraint AS positive_integer;
CREATE DOMAIN power_capacity_constraint AS positive_decimal;
CREATE DOMAIN gain_constraint AS positive_decimal;
CREATE DOMAIN ship_capacity_constraint AS positive_integer;
CREATE DOMAIN age_constraint AS positive_integer;

-- creating tables if they're exists
CREATE TABLE IF NOT EXISTS antenna (
    id SERIAL PRIMARY KEY,
    manufacturer TEXT NULL,
    model TEXT NOT NULL,
    type TEXT NOT NULL,
    frequency_range TEXT NOT NULL,
    gain gain_constraint NOT NULL,
    power_capacity power_capacity_constraint NOT NULL
);

CREATE TABLE IF NOT EXISTS troubles (
    id SERIAL PRIMARY KEY,
    difficulty difficulty_enum NOT NULL,
    consequences consequences_enum NOT NULL,
    priority priority_enum NOT NULL
);

CREATE TABLE IF NOT EXISTS place (
    id SERIAL PRIMARY KEY,
    coordinates POINT NOT NULL,
    galaxy TEXT NOT NULL,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS ship_type (
    id SERIAL PRIMARY KEY,
    ship_type TEXT NOT NULL,
    ship_capacity ship_capacity_constraint NOT NULL,
    max_speed max_speed_constraint NOT NULL,
    range range_constraint NOT NULL
);

CREATE TABLE IF NOT EXISTS ship (
    id SERIAL PRIMARY KEY,
    disconnected_from_earth BOOLEAN NOT NULL,
    safety BOOLEAN NOT NULL,
    ship_modules INTEGER REFERENCES antenna(id) NOT NULL,
    place INTEGER REFERENCES place(id) NOT NULL,
    ship_type INTEGER REFERENCES ship_type(id) NOT NULL
);

CREATE TABLE IF NOT EXISTS human_origin (
    id SERIAL PRIMARY KEY,
    country TEXT NOT NULL,
    type_of_government type_of_government_enum NOT NULL,
    city TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS human (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    surname TEXT NOT NULL,
    age age_constraint NOT NULL,
    nationality nationality_enum NOT NULL,
    origin INTEGER REFERENCES human_origin(id) NOT NULL,
    place INTEGER REFERENCES place(id) NOT NULL
);

CREATE TABLE IF NOT EXISTS human_troubles (
    human_id INTEGER REFERENCES human(id) NOT NULL,
    troubles_id INTEGER REFERENCES troubles(id) NOT NULL,
    PRIMARY KEY (human_id, troubles_id)
);

CREATE TABLE IF NOT EXISTS ship_troubles (
    ship_id INTEGER REFERENCES ship(id) NOT NULL,
    troubles_id INTEGER REFERENCES troubles(id) NOT NULL,
    PRIMARY KEY (ship_id, troubles_id)
);
