/* IS5102, Ethan Hill, November 2021

Assignment 2 - Database management with SQlite

Usage:
- To connect to a transient in-memory database:

    sqlite3 --init buses.sql

- To connect to a named database:

    sqlite3 <name.db> --init buses.sql
*/


.mode column
.headers on
.width 18 18 18 18
-- enforce foreign keys check
PRAGMA foreign_keys = TRUE;
----------------------------------------------------------------------
-- TASK 2 - TABLE DECLARATIONS
----------------------------------------------------------------------

CREATE TABLE staff (
    id          VARCHAR(5),
    staff_name  VARCHAR(30) NOT NULL,
    email       VARCHAR(30) NOT NULL,
    street      VARCHAR(25),
    city        VARCHAR(20),
    postcode    VARCHAR(8),
    PRIMARY KEY (id)
);

CREATE TABLE phone (
    phone_number  VARCHAR(15), 
    phone_type    VARCHAR(10) DEFAULT 'MOBILE',
    id            VARCHAR(5),
    PRIMARY KEY (phone_number, id),
    FOREIGN KEY (id) REFERENCES staff
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE manager (
    id               VARCHAR(5),
    annual_salary    NUMERIC(6,2) NOT NULL,
    CHECK (annual_salary > 0),
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES staff
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE driver (
    id               VARCHAR(5),
    hourly_salary    NUMERIC(2,2) NOT NULL,
    CHECK (hourly_salary > 0),
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES driver
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE station (
    station_name     VARCHAR(20),
    id               VARCHAR(5),
    PRIMARY KEY (station_name),
    FOREIGN KEY (id) REFERENCES manager
    ON UPDATE CASCADE
);

CREATE TABLE bus_service (
    service_number      VARCHAR(4),
    orig_station_name   VARCHAR(20),
    term_station_name   VARCHAR(20) CHECK(orig_station_name <> term_station_name),
    PRIMARY KEY (service_number),
    FOREIGN KEY (orig_station_name) REFERENCES station(station_name)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (term_station_name) REFERENCES station(station_name)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE drives (
    service_number  VARCHAR(4),
    id              VARCHAR(5),
    hours_driven    NUMERIC(3,2),
    PRIMARY KEY (id, service_number),
    FOREIGN KEY (id) REFERENCES driver
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (service_number) REFERENCES bus_service
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE service_time (
    service_number  VARCHAR(4),
    start_time      INTEGER,
    CHECK (start_time > 0),
    PRIMARY KEY (service_number, start_time),
    FOREIGN KEY (service_number) REFERENCES bus_service
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE stopservice (
    service_number     VARCHAR(4),
    start_time         INTEGER,
    stop_name          VARCHAR(30),
    arrival_time       INTEGER,
    fare_from_origin   NUMERIC(2,2) DEFAULT 0.60,
    CHECK (arrival_time > 0),
    PRIMARY KEY (service_number, start_time, stop_name),
    FOREIGN KEY (service_number, start_time) REFERENCES service_time
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (stop_name) REFERENCES stops
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE stops (
    stop_name    VARCHAR(30),
    PRIMARY KEY (stop_name)
);

-- Uncomment the DROP command below if you need to reset an existing
-- database. Tables are listed in the order which allows to drop them
-- without breaking foreign key constraints.
-- 

/*
DROP table phone;
DROP table stopservice;
DROP table stops;
DROP table service_time;
DROP table drives;
DROP table bus_service;
DROP table station;
DROP table driver;
DROP table manager;
DROP table staff;
*/

----------------------------------------------------------------------
-- TASK 2 - INSERT DATA (MIN 10 ROWS PER TABLE)
----------------------------------------------------------------------

INSERT INTO staff
VALUES ('P0001', 'Frodo Baggins', 'fbaggins@gmail.com', '1 Bag End', 'Dundee', 'DS14 1AB'),
       ('P0002', 'Bilbo Baggins', 'bbaggins@gmail.com', '1 Bag End', 'Dundee', 'DS14 1AB'),
       ('P0003', 'Samwise Gamgee', 'kinggardener@gmail.com', '14 Underhill', 'Cupar', 'KY14 4BC'),
       ('P0004', 'Meriadoc Brandybuck', 'merrymail@gmail.com', '42 Oaktree', 'Pickletillum', 'KY2 5TR'),
       ('P0005', 'Peregrin Took', 'Pipster420@gmail.com', '3 Hedgerow Hill', 'Kirkcaldy', 'KY74 7VB'),
       ('P0006', 'Adalbert Bolger', 'bigbadbolg@gmail.com', '56 Horseradish', 'Dundee', 'DS16 1CB'),
       ('P0007', 'Tom Bombadil', 'tombom@gmail.com', '3 Golden Dragon', 'Dundee', 'DS4 3ND'),
       ('P0008', 'Adamanta Chubb', 'Chubbster67@gmail.com', '14 Nutts Corner', 'Cupar', 'KY36 6AK'),
       ('P0009', 'Amethyst Hornblower', 'Amethystxx@gmail.com', '13b Acorn Alley', 'Pickletillum', 'KY14 3PS'),
       ('P0010', 'Andwise Roper', 'Ropey23@gmail.com', '37 Chestnut Way', 'Kirkcaldy', 'KY74 0KL'),
       ('P0011', 'Bandobras Took', 'bahbahblacksheep@gmail.com', '12 Alder Avenue', 'Strathkinness', 'KY17 4FB'),
       ('P0012', 'Basso Boffin', 'BigBoffinator@gmail.com', '89 Mordor Mews', 'Guardbridge', 'KY13 8SD'),
       ('P0013', 'Bell Goodchild', 'Goodygoody2shoez@gmail.com', '4 Minas Tirith Way', 'Newport', 'KY22 6LM'),
       ('P0014', 'Belladonna Took', 'bellamomma87@gmail.com', '6 Edoras Street', 'Anstruther', 'KY6 8WE'),
       ('P0015', 'Bilbo Gardener', 'theotherbilbo@gmail.com', '14 High Road', 'Crail', 'KY10 4FD'),
       ('P0016', 'Bingo Baggins', 'thatsabingo@gmail.com', '134 Finchley Road', 'Freuch', 'KY25 1OK'),
       ('P0017', 'Aldo Longjohnson', 'bigfeet567@gmail.com', '88 Hobbiton Highway', 'Perth', 'PR23 8HH'),
       ('P0018', 'Bodo Proudfoot', 'bodoboyo632@gmail.com', '37 Crouch End', 'St Andrews', 'KY16 9UA'),
       ('P0019', 'Bowman Cotton', 'bcotton3657@gmail.com', '34 Old Perth Road', 'Kirkcaldy', 'KY74 4ZP'),
       ('P0020', 'Bruno Bracegirdle', 'disorientedscorpion@gmail.com', '33 Aberdeen Road', 'Dundee', 'DS14 1MW');

INSERT INTO phone
VALUES ('07599719564','MOBILE', 'P0001'),
       ('07659719564','MOBILE', 'P0020'),
       ('07243719564','MOBILE', 'P0004'),
       ('07198519564','MOBILE', 'P0017'),
       ('08904719564','MOBILE', 'P0008'),
       ('00978919564','MOBILE', 'P0002'),
       ('03399719564','MOBILE', 'P0011'),
       ('55473219564','HOME', 'P0001'),
       ('09999219564','MOBILE', 'P0014'),
       ('11273019564','HOME', 'P0020')
       ;

INSERT INTO manager
VALUES ('P0001', 40000.00),
       ('P0002', 50000.00),
       ('P0003', 60000.20),
       ('P0004', 70000.00),
       ('P0005', 30500.00),
       ('P0006', 35000.00),
       ('P0007', 42000.50),
       ('P0008', 38000.80),
       ('P0009', 23000.30),
       ('P0010', 36000.00)
       ;

INSERT INTO driver
VALUES ('P0011', 9.22),
       ('P0012', 8.24),
       ('P0013', 7.57),
       ('P0014', 6.91),
       ('P0015', 11.34),
       ('P0016', 10.66),
       ('P0017', 8.02),
       ('P0018', 9.36),
       ('P0019', 7.87),
       ('P0020', 9.55)
       ;

INSERT INTO station
VALUES ('Seagate - Dundee', 'P0001'),
       ('St Andrews', 'P0002'),
       ('Kirkcaldy', 'P0003'),
       ('Cupar', 'P0004'),
       ('Anstruther', 'P0005'),
       ('Crail', 'P0006'),
       ('Perth', 'P0007'),
       ('Freuch', 'P0008'),
       ('Strathkinness', 'P0009'),
       ('Guardbridge', 'P0010')
       ;


INSERT INTO bus_service
VALUES ('99D', 'St Andrews', 'Seagate - Dundee'),
       ('747A', 'St Andrews', 'Kirkcaldy'),
       ('88X', 'Cupar', 'Anstruther'),
       ('43K', 'Crail', 'Perth'),
       ('99A', 'St Andrews', 'Perth'),
       ('69X', 'Freuch', 'Seagate - Dundee'),
       ('232C', 'Strathkinness', 'Guardbridge'),
       ('56G', 'St Andrews', 'Cupar'),
       ('8B', 'Guardbridge', 'Crail'),
       ('96F', 'Kirkcaldy', 'Seagate - Dundee')
       ;

INSERT INTO drives
VALUES ('99D', 'P0011', 120.00),
       ('747A', 'P0012', 170.50),
       ('88X', 'P0013', 220.00),
       ('43K', 'P0014', 135.00),
       ('99A', 'P0015', 104.00),
       ('69X', 'P0016', 96.00),
       ('232C', 'P0017', 203.67),
       ('56G', 'P0018', 140.40),
       ('8B', 'P0019', 300.00),
       ('96F', 'P0020', 178.33),
       ('43K', 'P0016', 102.00)
       ;

-- start times entered as INTEGER. This is seconds since UNIX epoch.
INSERT INTO service_time
VALUES ('99D', strftime('%s','06:35:00')),
       ('747A', strftime('%s','07:30:00')),
       ('88X', strftime('%s','07:30:00')),
       ('43K', strftime('%s','08:00:00')),
       ('99A', strftime('%s','09:00:00')),
       ('69X', strftime('%s','07:45:00')),
       ('232C', strftime('%s','08:45:00')),
       ('56G', strftime('%s','10:00:00')),
       ('8B', strftime('%s','08:15:00')),
       ('96F', strftime('%s','06:20:00')),
       ('99D', strftime('%s','09:35:00')),
       ('747A', strftime('%s','08:30:00')),
       ('88X', strftime('%s','11:30:00'))
       ;

INSERT INTO stops
VALUES ('South Street, St Andrews'),
       ('Strathkinness High Street'),
       ('Cupar Main Street'),
       ('St Andrews East Sands'),
       ('Eden Mills Library'),
       ('Leuchars Train Station'),
       ('Dundee Train Station'),
       ('Kirkcaldy Beach'),
       ('Crail Harbour'),
       ('Anstruther Street'),
       ('Howe Street'),
       ('Bag End Bus Stop'),
       ('Oak Street'),
       ('St Michaels'),
       ('Perth High Road')
       ;

INSERT INTO stopservice
VALUES ('99D', strftime('%s','06:35:00'), 'South Street, St Andrews', strftime('%s','06:45:00'), 3.50),
       ('99D', strftime('%s','06:35:00'), 'Strathkinness High Street', strftime('%s','06:55:00'), 3.60),
       ('99D', strftime('%s','06:35:00'), 'Eden Mills Library', strftime('%s','07:15:00'), 3.70),
       ('99D', strftime('%s','06:35:00'), 'Leuchars Train Station', strftime('%s','07:20:00'), 3.70),
       ('99D', strftime('%s','06:35:00'), 'Dundee Train Station', strftime('%s','07:45:00'), 4.20),
       ('747A', strftime('%s','07:30:00'), 'South Street, St Andrews', strftime('%s','07:40:00'), 3.50),
       ('747A', strftime('%s','07:30:00'), 'Strathkinness High Street', strftime('%s','07:50:00'), 3.60),
       ('747A', strftime('%s','07:30:00'), 'Cupar Main Street', strftime('%s','08:15:00'), 3.80),
       ('747A', strftime('%s','07:30:00'), 'Kirkcaldy Beach', strftime('%s','08:35:00'), 4.20),
       ('88X', strftime('%s','07:30:00'), 'Cupar Main Street', strftime('%s','07:35:00'), 3.20),
       ('88X', strftime('%s','07:30:00'), 'South Street, St Andrews', strftime('%s','08:15:00'), 4.20),
       ('88X', strftime('%s','07:30:00'), 'St Andrews East Sands', strftime('%s','08:20:00'), 4.20),
       ('88X', strftime('%s','07:30:00'), 'Anstruther Street', strftime('%s','08:45:00'), 4.70),
       ('43K', strftime('%s','08:00:00'), 'Crail Harbour', strftime('%s','08:10:00'), 2.20),
       ('43K', strftime('%s','08:00:00'), 'Anstruther Street', strftime('%s','08:25:00'), 3.20),
       ('43K', strftime('%s','08:00:00'), 'South Street, St Andrews', strftime('%s','08:45:00'), 3.50),
       ('43K', strftime('%s','08:00:00'), 'Perth High Road', strftime('%s','09:45:00'), 10.20),
       ('99A', strftime('%s','09:00:00'), 'St Michaels', strftime('%s','09:25:00'), 7.20),
       ('99A', strftime('%s','09:00:00'), 'Dundee Train Station', strftime('%s','09:45:00'), 7.50),
       ('99A', strftime('%s','09:00:00'), 'Howe Street', strftime('%s','09:55:00'), 7.60),
       ('99A', strftime('%s','09:00:00'), 'Perth High Road', strftime('%s','10:35:00'), 12.20),
       ('69X', strftime('%s','07:45:00'), 'Cupar Main Street', strftime('%s','08:15:00'), 1.80),
       ('69X', strftime('%s','07:45:00'), 'St Michaels', strftime('%s','08:35:00'), 2.80),
       ('69X', strftime('%s','07:45:00'), 'Bag End Bus Stop', strftime('%s','08:55:00'), 3.80),
       ('232C', strftime('%s','08:45:00'), 'Strathkinness High Street', strftime('%s','09:00:00'), 5.60),
       ('232C', strftime('%s','08:45:00'), 'South Street, St Andrews', strftime('%s','09:10:00'), 6.60),
       ('232C', strftime('%s','08:45:00'), 'Eden Mills Library', strftime('%s','09:25:00'), 7.60),
       ('56G', strftime('%s','10:00:00'), 'Oak Street', strftime('%s','08:55:00'), 7.86),
       ('56G', strftime('%s','10:00:00'), 'Howe Street', strftime('%s','08:55:00'), 9.86),
       ('56G', strftime('%s','10:00:00'), 'Perth High Road', strftime('%s','08:55:00'), 23.22),
       ('8B', strftime('%s','08:15:00'), 'Eden Mills Library', strftime('%s','08:25:00'), 0.60),
       ('8B', strftime('%s','08:15:00'), 'South Street, St Andrews', strftime('%s','08:45:00'), 0.90),
       ('8B', strftime('%s','08:15:00'), 'St Andrews East Sands', strftime('%s','08:50:00'), 2.00),
       ('96F', strftime('%s','06:20:00'), 'Kirkcaldy Beach', strftime('%s','06:35:00'), 4.20),
       ('96F', strftime('%s','06:20:00'), 'Howe Street', strftime('%s','06:55:00'), 6.20),
       ('96F', strftime('%s','06:20:00'), 'Oak Street', strftime('%s','07:15:00'), 6.30),
       ('96F', strftime('%s','06:20:00'), 'Bag End Bus Stop', strftime('%s','07:45:00'), 7.10),
       ('99D', strftime('%s','09:35:00'), 'South Street, St Andrews', strftime('%s','09:45:00'), 3.50),
       ('99D', strftime('%s','09:35:00'), 'Strathkinness High Street', strftime('%s','09:55:00'), 3.60),
       ('99D', strftime('%s','09:35:00'), 'Eden Mills Library', strftime('%s','10:15:00'), 3.70),
       ('99D', strftime('%s','09:35:00'), 'Leuchars Train Station', strftime('%s','10:20:00'), 3.70),
       ('99D', strftime('%s','09:35:00'), 'Dundee Train Station', strftime('%s','10:45:00'), 4.20),
       ('747A', strftime('%s','08:30:00'), 'South Street, St Andrews', strftime('%s','08:40:00'), 3.50),
       ('747A', strftime('%s','08:30:00'), 'Strathkinness High Street', strftime('%s','08:50:00'), 3.60),
       ('747A', strftime('%s','08:30:00'), 'Cupar Main Street', strftime('%s','09:15:00'), 3.80),
       ('747A', strftime('%s','08:30:00'), 'Kirkcaldy Beach', strftime('%s','09:35:00'), 4.20),
       ('88X', strftime('%s','11:30:00'), 'Cupar Main Street', strftime('%s','11:35:00'), 3.20),
       ('88X', strftime('%s','11:30:00'), 'South Street, St Andrews', strftime('%s','12:15:00'), 4.20),
       ('88X', strftime('%s','11:30:00'), 'St Andrews East Sands', strftime('%s','12:20:00'), 4.20),
       ('88X', strftime('%s','11:30:00'), 'Anstruther Street', strftime('%s','12:45:00'), 4.70)
       ;

----------------------------------------------------------------------
-- DATABASE CONSTRAINT TESTING (UNCOMMENT TO RUN)
----------------------------------------------------------------------

/*
-- CHECK FOREIGN KEY CONSTRAINTS

-- 1. Check failure when dropping a parent table such as staff.
DROP table staff;

-- 2. Check cascade is working, drop P0001 from staff and then check underlying tables
DELETE FROM staff
      WHERE id LIKE 'P0002';

SELECT *
  FROM station
 WHERE id = 'P0002';
*/

/*
-- CHECK MISC INTEGRITY CONDITIONS

-- 1. Try adding new bus route that starts and ends at same place. Check it fails.
INSERT INTO bus_service
VALUES ('J33', 'St Andrews', 'St Andrews');

-- 2. Try updating bus driver with negative hourly salary. Check it fails.
UPDATE driver
   SET hourly_salary = -3.00
 WHERE id = 'P0020';

-- 3. Try adding new manager with negative annual salary. Check it fails.
UPDATE manager
   SET annual_salary = -30000.00
 WHERE id = 'P0001';
*/

----------------------------------------------------------------------
-- VISUAL DATA CONTROL
----------------------------------------------------------------------

-- This "control" does not check anything, but if we can't see the
-- tables, then something definitely went wrong with defining them.
-- check min 10 rows per table.

SELECT * FROM staff;
SELECT * FROM phone;
SELECT * FROM manager;
SELECT * FROM driver;
SELECT * FROM station;
SELECT * FROM drives;
SELECT * FROM bus_service;
SELECT * FROM service_time;
SELECT * FROM stopservice;
SELECT * FROM stops;

----------------------------------------------------------------------
-- TASK 3 - SQL DATA MANIPULATION
----------------------------------------------------------------------

-- NEED TO RETURN AT LEAST 2 RESULTS PER QUERY

-- 1. List all services which have Seagate Bus Station in Dundee as their destination;

SELECT service_number 
  FROM bus_service
 WHERE term_station_name LIKE 'Seagate - Dundee';


-- 2. List the names of all drivers of services which have St Andrews Bus Station in St Andrews as their
--    origin or destination, in decreasing order of total hours driven;

  SELECT staff_name,
         SUM(hours_driven) AS 'total_hours'
    FROM drives d, 
         staff s, 
         bus_service b
   WHERE d.id = s.id
     AND d.service_number = b.service_number
     AND (b.orig_station_name LIKE 'St Andrews' 
      OR b.term_station_name LIKE 'St Andrews')
GROUP BY staff_name
ORDER BY total_hours DESC;


-- 3. List the manager of the most connected station, measured by the number of services which have
--    that station as their origin or destination.

  SELECT st.id, 
         staff_name, 
         station_name,
         COUNT(station_name) AS num_starts_or_ends
    FROM station s, 
         bus_service b, 
         staff st
   WHERE (s.station_name = b.orig_station_name 
      OR s.station_name = b.term_station_name)
     AND s.id = st.id
GROUP BY st.id
ORDER BY num_starts_or_ends DESC
   LIMIT 1;


-- 4. For the bus stop ”South Street, St Andrews” list in the chronological order arrival times at this
--    stop, origins, destinations, and service numbers of all bus services passing this stop between 8 am
--    and 6 pm.

  SELECT TIME(arrival_time, 'unixepoch') AS arrival_time, 
         orig_station_name AS origin, 
         term_station_name AS destination, 
         ss.service_number
    FROM stopservice ss, 
         bus_service b
   WHERE ss.service_number = b.service_number
     AND stop_name = 'South Street, St Andrews'
     AND arrival_time > 946713600   --8AM seconds since epoch
     AND arrival_time < 946749600   --6PM seconds since epoch
ORDER BY arrival_time ASC;


-- 5. For the manager of each station, look at the station they manage, 
--    their annual salary and their annual salary per number of routes which start or 
--    end in their station. Shows that based on data, managers with multiple
--    stations are not fairly recompensed.

  SELECT m.id, 
         staff_name, 
         station_name, 
         COUNT(station_name) AS num_starts_or_ends, 
         annual_salary, 
         ROUND(annual_salary/COUNT(station_name), 2) AS salary_per_routes_overseen
    FROM station s, 
         bus_service b, 
         staff st, 
         manager m
   WHERE (s.station_name = b.orig_station_name
      OR s.station_name = b.term_station_name)
     AND s.id = st.id
     AND s.id = m.id
GROUP BY m.id
ORDER BY salary_per_routes_overseen DESC;


-- 6. List each driver's ID, name, hourly salary, total hours driven across services and 
--    consequently, how much they are owed this month.

  SELECT d.id,
         staff_name, 
         hourly_salary, 
         SUM(hours_driven) AS total_hours_driven, 
         ROUND(hourly_salary * SUM(hours_driven), 2) AS wages_to_be_paid
    FROM staff s,
         driver d, 
         drives ds
   WHERE s.id = d.id 
     AND ds.id = d.id
GROUP BY d.id
ORDER BY wages_to_be_paid DESC;


-- 7. List the top five most stopped at bus stops and 
--    the number of times they are visited each day in descending order.

  SELECT stop_name,
         COUNT(stop_name) AS num_routes_present_on
    FROM stopservice
GROUP BY stop_name
ORDER BY num_routes_present_on DESC
   LIMIT 5;


-- 8. Look at the fares that are above average. List the service number, origin, stop name, and 
--    fare for each and present in descending order. Data shows that there isn't consistent pricing and
--    it makes sense to take some services over others.

  SELECT service_number,
         orig_station_name,
         stop_name,
         fare_from_origin
    FROM stopservice NATURAL JOIN bus_service
   WHERE fare_from_origin > (SELECT AVG(fare_from_origin) 
                               FROM stopservice)
ORDER BY fare_from_origin DESC;

-- VIEW 1 - View of bus drivers basic information and the routes they've driven and how many hours on each.
--          Excludes salary information and personal contact information

CREATE VIEW driver_view 
    AS SELECT s.id, 
              staff_name,
              service_number, 
              hours_driven
         FROM staff s, 
              drives d
        WHERE s.id = d.id
       ORDER BY s.id ASC;


-- VIEW 2 - Bus stops that can be accessed from the most connected station along with
--          service number and fare. Excludes individual times as timetables can change.

CREATE VIEW most_connected_destinations 
    AS SELECT DISTINCT service_number, 
                       stop_name, 
                       fare_from_origin
                  FROM stopservice NATURAL JOIN bus_service
                 WHERE orig_station_name IN 
                       (SELECT station_name
                          FROM (SELECT st.id, 
                                       staff_name, 
                                       station_name,
                                       COUNT(station_name) AS num_starts_or_ends
                                  FROM station s, 
                                       bus_service b, 
                                       staff st
                                 WHERE (s.station_name = b.orig_station_name
                                    OR s.station_name = b.term_station_name)
                                   AND s.id = st.id
                              GROUP BY st.id
                              ORDER BY num_starts_or_ends DESC
                                 LIMIT 1));
