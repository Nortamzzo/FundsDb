-- Persons Database
-- Created 03/13/2023
-- Modification History
-- Date		Who			What modified

-- DROP DATABASE IF EXISTS JPERSONS001;
-- CREATE DATABASE JPERSONS001;
USE JPERSONS001;

DROP TABLE IF EXISTS Person;
CREATE TABLE Person (
    PersonId INT NOT NULL AUTO_INCREMENT,
    FirstName VARCHAR(25),
    LastName VARCHAR(25),
    IsEnabled BOOL DEFAULT 1,
	Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (PersonId),
    FOREIGN KEY (IdentityId) REFERENCES Identity (IdentityId)
);

CREATE TABLE IdentityPerson (
	IdentityPersonId INT NOT NULL AUTO_INCREMENT,
    IdentityId CHAR(36),
    PersonId INT,
    PRIMARY KEY (IdentityPersonId)
);
