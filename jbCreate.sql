-- DROP DATABASE IF EXISTS JBOOKS001;
-- CREATE DATABASE JBOOKS001;
USE JBOOKS001;

SET FOREIGN_KEY_CHECKS = 0;

-- Associate AspNetUsers
DROP TABLE IF EXISTS Identity;
CREATE TABLE Identity (
	IdentityId CHAR(36) NOT NULL UNIQUE,
    Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (IdentityId)
);

DROP TABLE IF EXISTS UserProfile;
CREATE TABLE UserProfile (
	UserProfileId INT NOT NULL AUTO_INCREMENT,
    IdentityId CHAR(36),
    ActiveId CHAR(36),
    Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UserProfileId),
    FOREIGN KEY (IdentityId) REFERENCES Identity (IdentityId),
    FOREIGN KEY (ActiveId) REFERENCES Identity (IdentityId)
);

CREATE TABLE Amount (
	AmountId INT NOT NULL AUTO_INCREMENT,
    Value DECIMAL(13,2),
    PRIMARY KEY (AmountId)
);

DROP TABLE IF EXISTS LkAccountCategory;
CREATE TABLE LkAccountCategory (
    LkAccountCategoryId INT NOT NULL AUTO_INCREMENT,
    AccountCategory VARCHAR(15),
    PRIMARY KEY (LkAccountCategoryId)
);
INSERT INTO LkAccountCategory
	(LkAccountCategoryId, AccountCategory)
VALUES
	(1, 'Asset'),
    (2, 'Liability'),
    (3, 'Equity')
;

DROP TABLE IF EXISTS LkAccountType;
CREATE TABLE LkAccountType (
    LkAccountTypeId INT NOT NULL AUTO_INCREMENT,
    LkAccountCategoryId INT,
    AccountType VARCHAR(50),
    PRIMARY KEY (LkAccountTypeId),
    FOREIGN KEY (LkAccountCategoryId) REFERENCES LkAccountCategory (LkAccountCategoryId)
);
INSERT INTO LkAccountType
	(LkAccountTypeId, AccountType, LkAccountCategoryId)
VALUES
	(1, 'Cash', 1),
    (2, 'Checking', 1),
    (3, 'Saving', 1),
    (4, 'Credit Card', 2),
    (5, 'Loan', 2),
    (6, 'Loan Out', 3)
;

DROP TABLE IF EXISTS Note;
CREATE TABLE Note (
	NoteId INT NOT NULL AUTO_INCREMENT,
    NoteText TEXT,
    Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (NoteId)
);

DROP TABLE IF EXISTS Account;
CREATE TABLE Account (
    AccountId INT NOT NULL AUTO_INCREMENT,
    AccountTitle VARCHAR(25),
    LkAccountTypeId INT,
	Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (AccountId),
    FOREIGN KEY (LkAccountTypeId) REFERENCES LkAccountType (LkAccountTypeId)
);

DROP TABLE IF EXISTS IdentityAccount;
CREATE TABLE IdentityAccount (
	IdentityId CHAR(36),
    AccountId INT,
    PRIMARY KEY (IdentityId, AccountId)
);

DROP TABLE IF EXISTS AccountNote;
CREATE TABLE AccountNote(
	AccountId INT,
    NoteId INT,
    PRIMARY KEY (AccountId, NoteId)
);

DROP TABLE IF EXISTS Transaction;
CREATE TABLE Transaction (
	TransactionId INT NOT NULL AUTO_INCREMENT,
    TransactionDate DATE,
    TransactionAmount DECIMAL(13,2),
    AccountId INT,
    Enabled BOOL NOT NULL DEFAULT 1,
    Hidden BOOL NOT NULL DEFAULT 0,
    Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (TransactionId),
    FOREIGN KEY (AccountId) REFERENCES Account (AccountId)
);

SET FOREIGN_KEY_CHECKS = 1;