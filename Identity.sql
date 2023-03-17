-- Identity Database
-- Identity across all databases / applications
-- Created 03/13/2023
-- Modification History
-- Date		Who			What modified

-- DROP DATABASE IF EXISTS JIDENTITY001;
-- CREATE DATABASE JIDENTITY001;
USE JIDENTITY001;
 
-- Associate AspNetUsers
DROP TABLE IF EXISTS Identity;
CREATE TABLE Identity (
	IdentityId CHAR(36) NOT NULL UNIQUE,
    Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (IdentityId)
);

-- Populate with GeoInsert
DROP TABLE IF EXISTS LkState;
CREATE TABLE LkState (
	LkStateId INT NOT NULL AUTO_INCREMENT,
    StateName VARCHAR(35),
    Abbreviation VARCHAR(2),
    PRIMARY KEY (LkStateId),
    INDEX (StateName, Abbreviation)
);
-- Populate with GeoInsert
DROP TABLE IF EXISTS LkZipCode;
CREATE TABLE LkZipCode (
	LkZipCodeId INT NOT NULL AUTO_INCREMENT,
    ZipCode VARCHAR(10),
    LkStateId INT,
    PRIMARY KEY (LkZipCodeId),
    FOREIGN KEY (LkStateId) REFERENCES LkState (LkStateId),
    INDEX (ZipCode)
);
-- Populate with GeoInsert
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
-- Populate with GeoInsert
DROP TABLE IF EXISTS LkPhoneType;
CREATE TABLE LkPhoneType (
	LkPhoneTypeId INT NOT NULL AUTO_INCREMENT,
	PhoneTypeName VARCHAR(10),
    PRIMARY KEY (LkPhoneTypeId)
);
INSERT INTO LkPhoneType
	(LkPhoneTypeId, PhoneTypeName)
VALUES
    (1, "Mobile"),
	(2, "Home"),
    (3, "Work")
; 
DROP TABLE IF EXISTS PhoneNumber;
CREATE TABLE PhoneNumber (
	PhoneNumberId INT NOT NULL AUTO_INCREMENT,
    IdentityId CHAR(36),
    PhoneNumberValue VARCHAR(15),
    LkPhoneTypeId INT,
    IsEnabled BOOL DEFAULT 1,
	Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (PhoneNumberId),
    FOREIGN KEY (IdentityId) REFERENCES Identity (IdentityId),
    FOREIGN KEY (LkPhoneTypeId) REFERENCES LkPhoneType (LkPhoneTypeId)
);
DROP TABLE IF EXISTS Address;
CREATE TABLE Address (
	AddressId INT NOT NULL AUTO_INCREMENT,
    IdentityId CHAR(36),
    LineOne VARCHAR(50),
    LineTwo VARCHAR(50),
    LkZipCodeId INT,
    LkCityId INT,
    LkStateId INT,
    IsEnabled BOOL DEFAULT 1,
    IsDeleted BOOL DEFAULT 0,
	Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (AddressId),
    FOREIGN KEY (IdentityId) REFERENCES Identity (IdentityId),
    FOREIGN KEY (LkZipCodeId) REFERENCES LkZipCode (LkZipCodeId),
    FOREIGN KEY (LkCityId) REFERENCES LkCity (LkCityId),
    FOREIGN KEY (LkStateId) REFERENCES LkState (LkStateId)
);
CREATE TABLE Application (
	ApplicationId INT NOT NULL AUTO_INCREMENT,
    ApplicationName VARCHAR(20),
    PRIMARY KEY (ApplicationId)
);
INSERT INTO Application
	(ApplicationId, ApplicationName)
    VALUES
	(1, 'jBoooks')
	;
DROP TABLE IF EXISTS UserProfile;
CREATE TABLE UserProfile (
	UserProfileId INT NOT NULL AUTO_INCREMENT,
    IdentityId CHAR(36),
    ActiveId CHAR(36),
    Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UserProfileId),
    FOREIGN KEY (IdentityId) REFERENCES Identity (IdentityId),
    FOREIGN KEY (ActiveId) REFERENCES Identity (IdentityId),
    FOREIGN KEY (PersonId) REFERENCES Person (PersonId)
);