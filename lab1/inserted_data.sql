-- dropping created previously sequences
DROP SEQUENCE troubles_id_sequence;
DROP SEQUENCE human_id_sequence;
 
-- creating sequences for handy inserting data into tables
CREATE SEQUENCE troubles_id_sequence START 1;
CREATE SEQUENCE human_id_sequence START 1;
 
-- insert data into antenna
INSERT INTO antenna (manufacturer, model, type, frequency_range, gain, power_capacity) 
VALUES 
    ('AntennaCorp', 'SuperAntenna', 'Dipole', '10 MHz - 1 GHz', 12.5, 100),
    ('AntennaWorks', 'HyperGain', 'Yagi', '1 GHz - 10 GHz', 16.2, 500),
    ('TechAntenna', 'UltraBeam', 'Parabolic', '2 GHz - 18 GHz', 20.1, 1000),
    ('AntennaCo', 'MegaHorn', 'Horn', '100 MHz - 6 GHz', 10.8, 200),
    ('AntennaCorp', 'OmniAntenna', 'Omni-Directional', '1 MHz - 100 MHz', 6.4, 50),
    ('AntennaWorks', 'SlimLine', 'Patch', '900 MHz - 2.4 GHz', 8.7, 300),
    ('TechAntenna', 'UltraFlex', 'Flexible', '500 MHz - 2 GHz', 9.3, 100),
    ('AntennaCo', 'GigaHorn', 'Horn', '10 GHz - 100 GHz', 12.1, 500),
    ('AntennaCorp', 'Helix', 'Helical', '300 MHz - 2.4 GHz', 7.6, 150),
    ('AntennaWorks', 'MegaPatch', 'Patch', '1.5 GHz - 5 GHz', 14.5, 400);
 
 
-- inserting data into troubles table
INSERT INTO troubles (difficulty, consequences, priority) VALUES
('easy', 'minimal', 'low'),
('moderate', 'moderate', 'medium'),
('hard', 'catastrophic', 'high');
 
-- insert data into place
 
INSERT INTO place (coordinates, galaxy, name)
VALUES
    (POINT(40.7128, -74.0060), 'Milky Way', 'New York City'),
    (POINT(51.5074, -0.1278), 'Milky Way', 'London'),
    (POINT(43.6532, -79.3832), 'Milky Way', 'Toronto'),
    (POINT(39.9042, 116.4074), 'Milky Way', 'Beijing'),
    (POINT(48.8566, 2.3522), 'Milky Way', 'Paris'),
    (POINT(52.5200, 13.4050), 'Milky Way', 'Berlin'),
    (POINT(28.7041, 77.1025), 'Milky Way', 'New Delhi'),
    (POINT(35.6895, 139.6917), 'Milky Way', 'Tokyo'),
    (POINT(55.7558, 37.6173), 'Milky Way', 'Moscow'),
    (POINT(40.4168, -3.7038), 'Milky Way', 'Madrid');
 
-- insert data into ship_type
INSERT INTO ship_type (ship_type, ship_capacity, max_speed, range)
VALUES
    ('Fighter', 1, 200, 1000),
    ('Cruiser', 10, 150, 5000),
    ('Frigate', 20, 100, 10000),
    ('Destroyer', 50, 75, 15000),
    ('Transport', 100, 50, 20000);
 
 
-- insert data into ship table
INSERT INTO ship (disconnected_from_earth, safety, ship_modules, place, ship_type)
VALUES (TRUE, TRUE, 1, 1, 1),
(FALSE, FALSE, 2, 2, 2),
(TRUE, FALSE, 3, 3, 3);
 
-- inserting data into human_origin table
INSERT INTO human_origin (country, type_of_government, city) VALUES
('Mexico', 'democracy', 'Mexico City'),
('Italy', 'republic', 'Rome'),
('Japan', 'constitutional monarchy', 'Tokyo'),
('South Africa', 'parliamentary republic', 'Cape Town'),
('Canada', 'parliamentary democracy', 'Ottawa'),
('Australia', 'parliamentary democracy', 'Canberra'),
('Russia', 'federal semi-presidential republic', 'Moscow'),
('Brazil', 'federal presidential republic', 'Brasília'),
('India', 'federal parliamentary constitutional republic', 'New Delhi'),
('Saudi Arabia', 'absolute monarchy', 'Riyadh');
 
 
-- inserting data into human table
INSERT INTO human (name, surname, age, nationality, origin, place)
VALUES ('John', 'Doe', 35, 'American', 1, 1),
('Ivan', 'Ivanov', 28, 'Russian', 2, 2),
('Marie', 'Curie', 66, 'French', 3, 3),
('Alice', 'Johnson', 33, 'German', 4, 4);
 
 
-- Insert data into human_troubles using the sequence
INSERT INTO human_troubles (human_id, troubles_id)
SELECT nextval('human_id_sequence'), nextval('troubles_id_sequence')
FROM generate_series(1, 3); 
 
-- inserting data into ship_troubles table
INSERT INTO ship_troubles (ship_id, troubles_id) VALUES
(1, 1),
(2, 2),
(3, 3);
