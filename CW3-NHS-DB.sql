
/* 
COURSEWORK 3: NHS DATABASE 
GROUP 17
ASHAR ADEEL & ALI HABIB
written for Oracle Live
*/

        /*
            CLEAN TABLE:
                DROP TABLE DISTRICT;
                DROP TABLE COUNTY;
                DROP TABLE COUNTRY;
                DROP TABLE LOCATION;
                DROP TABLE STATEMENTS;
                DROP TABLE MINISTER;
        */

--- PART 1: 

/*
    Part 1: Database creation.
    Create a minimum of 5 tables using SQL CREATE commands.
    Expect to see constraints (e.g. key constraints). 
    Expect to see an instance of Generalisation.

    Populate your tables with at least 10 rows of data per table using SQL INSERT statements.
*/

--- --- --- CREATE TABLES

--- MINISTER
CREATE TABLE Minister(
    MinisterID INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    CHECK (end_date is NULL or end_date >= start_date)
);


--- STATEMENTS <-- MINISTER
CREATE TABLE Statements (
    StatementID INT PRIMARY KEY,
    MinisterID INT NOT NULL,
    present_date DATE NOT NULL,
    statement TEXT NOT NULL,
    FOREIGN KEY (MinisterID) REFERENCES Minister(MinisterID)
);

--- LOCATION
CREATE TABLE Location (
    LocationID INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    population INT NOT NULL CHECK (population >= 0),
    type VARCHAR(20) NOT NULL CHECK (type IN ('Country','County','District'))
);


--- COUNTRY <- LOCATION (GENERALISED)
CREATE TABLE Country (
    CountryID INT PRIMARY KEY,
    MinisterID INT NOT NULL,
    FOREIGN KEY (CountryID) REFERENCES Location(LocationID),
    FOREIGN KEY (MinisterID) REFERENCES Minister(MinisterID)
);

--- COUNTY <- LOCATION (GENERALISED)
CREATE TABLE County (
    CountyID INT PRIMARY KEY,
    CountryID INT NOT NULL,
    FOREIGN KEY (CountyID) REFERENCES Location(LocationID),
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);

--- DISTRICT <- LOCATION (GENERALISED)
CREATE TABLE District (
    DistrictID INT PRIMARY KEY,
    CountyID INT NOT NULL,
    FOREIGN KEY (DistrictID) REFERENCES Location(LocationID),
    FOREIGN KEY (CountyID) REFERENCES County(CountyID)
);

--- --- --- CREATE INSERTIONS

/* MINISTERS (Prime Ministers) */
INSERT INTO Minister VALUES
(301, 'Keir Starmer', DATE '2024-07-05', NULL);
INSERT INTO Minister VALUES
(302, 'Rishi Sunak', DATE '2022-10-25', DATE '2024-07-05');
INSERT INTO Minister VALUES
(303, 'Liz Truss', DATE '2022-09-06', DATE '2022-10-25');
INSERT INTO Minister VALUES
(304, 'Boris Johnson', DATE '2019-07-24', DATE '2022-09-06');



/* COUNTRIES */
INSERT INTO Location VALUES
(1, 'England', 56000000, 'Country');
INSERT INTO Location VALUES
(2, 'Scotland', 5500000, 'Country');
INSERT INTO Location VALUES
(3, 'Wales', 3150000, 'Country');
INSERT INTO Location VALUES
(4, 'Northern Ireland', 1900000, 'Country');

INSERT INTO Country VALUES (1, 301);
INSERT INTO Country VALUES (2, 302);
INSERT INTO Country VALUES (3, 303);
INSERT INTO Country VALUES (4, 304);



/* COUNTIES */
INSERT INTO Location VALUES
(100, 'Essex', 1800000, 'County');
INSERT INTO Location VALUES
(101, 'Cambridgeshire', 900000, 'County');
INSERT INTO Location VALUES
(102, 'Greater London', 8900000, 'County');
INSERT INTO Location VALUES
(103, 'Greater Manchester', 2800000, 'County');

INSERT INTO County VALUES (100, 1);
INSERT INTO County VALUES (101, 1);
INSERT INTO County VALUES (102, 1);
INSERT INTO County VALUES (103, 1);


/* DISTRICT LOCATIONS */
INSERT INTO Location VALUES
(200, 'City of London', 8000, 'District');
INSERT INTO Location VALUES
(201, 'Tower Hamlets', 320000, 'District');

INSERT INTO District VALUES (200, 102);
INSERT INTO District VALUES (201, 102);



--- PART 2: 
/*
    Part 2: Basic Queries

    Write 2 Basic SQL Queries using dates, joins or functions. 

*/

/*
    QUERY #1
    
    SELECT ALL DISTRICTS WHICH ARE IN THE COUNTRY "ENGLAND"
*/
SELECT 
    dl.name AS district_name,
    cl.name AS country_name
FROM District d
JOIN Location dl ON d.DistrictID = dl.LocationID      
JOIN County c ON d.CountyID = c.CountyID
JOIN Country co ON c.CountryID = co.CountryID
JOIN Location cl ON co.CountryID = cl.LocationID       
WHERE cl.name = 'England';
s

/*
    QUERY #2
    SHOW THE START DATE THE MINISTERS AND THE COUNTRY THEY REPRESENT
*/
SELECT 
    TO_CHAR(m.start_date, 'Day, DD Month YYYY') AS start_date,
    m.name AS minister_name,
    l.name AS country_name
FROM Minister m
JOIN Country c ON m.MinisterID = c.MinisterID
JOIN Location l ON c.CountryID = l.LocationID;

