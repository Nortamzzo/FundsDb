/*
State, Zip, County, City
*/

DROP DATABASE IF EXISTS Geo;
CREATE DATABASE Geo;
USE Geo;

DROP TABLE IF EXISTS LkState;
CREATE TABLE LkState (
	LkStateId INT NOT NULL AUTO_INCREMENT,
    State VARCHAR(35),
    Abbreviation VARCHAR(2),
    PRIMARY KEY (LkStateId),
    INDEX (State, Abbreviation)
);

DROP TABLE IF EXISTS LkZipCode;
CREATE TABLE LkZipCode (
	LkZipCodeId INT NOT NULL AUTO_INCREMENT,
    ZipCode VARCHAR(10),
    LkStateId INT,
    PRIMARY KEY (LkZipCodeId),
    FOREIGN KEY (LkStateId) REFERENCES LkState (LkStateId),
    INDEX (ZipCode)
);

-- DROP TABLE IF EXISTS LkCounty;
-- CREATE TABLE LkCounty (
-- 	LkCountyId INT NOT NULL AUTO_INCREMENT,
--     County VARCHAR(35),
--     LkZipCodeId INT NOT NULL,
--     PRIMARY KEY (LkCountyId),
--     FOREIGN KEY (LkZipCodeId) REFERENCES LkZipCode (LkZipCodeId)
-- );

DROP TABLE IF EXISTS LkCity;
CREATE TABLE LkCity (
	LkCityId INT NOT NULL AUTO_INCREMENT,
    City VARCHAR(35),
    LkStateId INT NOT NULL,
    LkZipCodeId INT NOT NULL,
    PRIMARY KEY (LkCityId),
    INDEX (City),
    FOREIGN KEY (LkStateId) REFERENCES LkState (LkStateId),
    FOREIGN KEY (LkZipCodeId) REFERENCES LkZipCode (LkZipCodeId)
);

