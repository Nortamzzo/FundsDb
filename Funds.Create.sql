DROP DATABASE IF EXISTS Funds0008;
CREATE DATABASE Funds0008;
USE Funds0008;

/*
Step 1: Run this script
Step 2: CALL UserCreate('<EMAIL ADDRESS>', '<USERNAME>', '<HASH PASS *SEE NOTE>', '<FIRST NAME>', '<LAST NAME>');
Step 2 NOTE: TO run from mysql, create our own hash pass. To run from web, use a password instead and api will create a hash based off that
Step 3: Use.
*/

/*
Begin Create
*/

DROP TABLE IF EXISTS `Person`;
CREATE TABLE `Person` (
  `PersonId` int NOT NULL AUTO_INCREMENT,
  `Email` varchar(75) NOT NULL,
  `Username` varchar(25) NOT NULL,
  `FirstName` varchar(35) DEFAULT NULL,
  `LastName` varchar(35) DEFAULT NULL,
  PRIMARY KEY (`PersonId`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Username` (`Username`),
  CONSTRAINT `MinUsernameLength` CHECK ((length(`Username`) >= 4))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `UserRole`;
CREATE TABLE `UserRole` (
  `UserRoleId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(15) NOT NULL,
  PRIMARY KEY (`UserRoleId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Users`;
CREATE TABLE `Users` (
  `UserId` int NOT NULL,
  `PersonId` int NOT NULL,
  `UserRoleId` int NOT NULL DEFAULT '1',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserId`),
  UNIQUE KEY `UserId` (`UserId`),
  KEY `PersonId` (`PersonId`),
  KEY `UserRoleId` (`UserRoleId`),
  FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`),
  FOREIGN KEY (`UserRoleId`) REFERENCES `UserRole` (`UserRoleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `HashTable`;
CREATE TABLE `HashTable` (
  `HashTableId` int NOT NULL AUTO_INCREMENT,
  `PersonId` int NOT NULL,
  `HashPass` varchar(255) NOT NULL,
  PRIMARY KEY (`HashTableId`),
  KEY `PersonId` (`PersonId`),
  FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `AccountCategory`;
CREATE TABLE `AccountCategory` (
  `AccountCategoryId` int NOT NULL AUTO_INCREMENT,
  `AccountCategory` varchar(10) NOT NULL,
  PRIMARY KEY (`AccountCategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `AccountType`;
CREATE TABLE `AccountType` (
  `AccountTypeId` int NOT NULL AUTO_INCREMENT,
  `AccountCategoryId` int NOT NULL,
  `AccountType` varchar(25) NOT NULL,
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`AccountTypeId`),
  KEY `AccountCategoryId` (`AccountCategoryId`),
  FOREIGN KEY (`AccountCategoryId`) REFERENCES `AccountCategory` (`AccountCategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account` (
  `AccountId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(35) NOT NULL,
  `StartAmount` decimal(9,2) NOT NULL,
  `Information` varchar(255) DEFAULT NULL,
  `OpenDate` date NOT NULL,
  `Tracking` tinyint(1) NOT NULL DEFAULT '1',
  `Sequence` int NOT NULL,
  `Enabled` tinyint(1) NOT NULL DEFAULT '1',
  `AccountTypeId` int NOT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `IncludeInTotal` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`AccountId`),
  KEY `AccountTypeId` (`AccountTypeId`),
  FOREIGN KEY (`AccountTypeId`) REFERENCES `AccountType` (`AccountTypeId`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `UserAccount`;
CREATE TABLE `UserAccount` (
  `UserAccountId` int NOT NULL AUTO_INCREMENT,
  `UserId` int NOT NULL,
  `AccountId` int NOT NULL,
  PRIMARY KEY (`UserAccountId`),
  KEY `UserId` (`UserId`),
  KEY `AccountId` (`AccountId`),
  CONSTRAINT `UserAccount_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`),
  CONSTRAINT `UserAccount_ibfk_2` FOREIGN KEY (`AccountId`) REFERENCES `Account` (`AccountId`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Flow`;
CREATE TABLE `Flow` (
  `FlowId` int NOT NULL AUTO_INCREMENT,
  `Flow` varchar(7) NOT NULL,
  `Rate` int NOT NULL,
  PRIMARY KEY (`FlowId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Category`;
CREATE TABLE `Category` (
  `CategoryId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(35) NOT NULL,
  `Information` varchar(255) DEFAULT NULL,
  `Sequence` int DEFAULT '0',
  `Editable` tinyint(1) NOT NULL DEFAULT '1',
  `Hidden` tinyint(1) NOT NULL DEFAULT '0',
  `Enabled` tinyint(1) NOT NULL DEFAULT '1',
  `FlowId` int NOT NULL,
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CategoryId`),
  KEY `FlowId` (`FlowId`),
  CONSTRAINT `Category_ibfk_1` FOREIGN KEY (`FlowId`) REFERENCES `Flow` (`FlowId`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `UserCategory`;
CREATE TABLE `UserCategory` (
  `UserCategoryId` int NOT NULL AUTO_INCREMENT,
  `UserId` int NOT NULL,
  `CategoryId` int NOT NULL,
  PRIMARY KEY (`UserCategoryId`),
  KEY `UserId` (`UserId`),
  KEY `CategoryId` (`CategoryId`),
  CONSTRAINT `UserCategory_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`),
  CONSTRAINT `UserCategory_ibfk_2` FOREIGN KEY (`CategoryId`) REFERENCES `Category` (`CategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Subcategory`;
CREATE TABLE `Subcategory` (
  `SubcategoryId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(35) NOT NULL,
  `Information` varchar(255) DEFAULT NULL,
  `Budget` decimal(9,2) NOT NULL DEFAULT '0.00',
  `Sequence` int DEFAULT '0',
  `Editable` tinyint(1) NOT NULL DEFAULT '1',
  `Hidden` tinyint(1) NOT NULL DEFAULT '0',
  `Enabled` tinyint(1) NOT NULL DEFAULT '1',
  `CategoryId` int NOT NULL,
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`SubcategoryId`),
  KEY `CategoryId` (`CategoryId`),
  CONSTRAINT `Subcategory_ibfk_1` FOREIGN KEY (`CategoryId`) REFERENCES `Category` (`CategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Item`;
CREATE TABLE `Item` (
  `ItemId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(75) NOT NULL,
  `Information` varchar(255) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ItemId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `UserItem`;
CREATE TABLE `UserItem` (
  `UserItemId` int NOT NULL AUTO_INCREMENT,
  `UserId` int NOT NULL,
  `ItemId` int NOT NULL,
  PRIMARY KEY (`UserItemId`),
  KEY `UserId` (`UserId`),
  KEY `ItemId` (`ItemId`),
  CONSTRAINT `UserItem_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`),
  CONSTRAINT `UserItem_ibfk_2` FOREIGN KEY (`ItemId`) REFERENCES `Item` (`ItemId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Location`;
CREATE TABLE `Location` (
  `LocationId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(45) NOT NULL,
  `Information` varchar(255) DEFAULT NULL,
  `Url` varchar(100) DEFAULT NULL,
  `Hidden` tinyint(1) NOT NULL DEFAULT '0',
  `Editable` tinyint(1) NOT NULL DEFAULT '1',
  `LedgerEditable` tinyint(1) NOT NULL DEFAULT '1',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`LocationId`)
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `UserLocation`;
CREATE TABLE `UserLocation` (
  `UserLocationId` int NOT NULL AUTO_INCREMENT,
  `UserId` int NOT NULL,
  `LocationId` int NOT NULL,
  PRIMARY KEY (`UserLocationId`),
  KEY `UserId` (`UserId`),
  KEY `LocationId` (`LocationId`),
  CONSTRAINT `UserLocation_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`),
  CONSTRAINT `UserLocation_ibfk_2` FOREIGN KEY (`LocationId`) REFERENCES `Location` (`LocationId`)
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `NavbarSettings`;
CREATE TABLE `NavbarSettings` (
  `NavbarSettingsId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(20) NOT NULL,
  `DisplayTitle` varchar(20) NOT NULL,
  `Information` varchar(255) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`NavbarSettingsId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Transaction`;
CREATE TABLE `Transaction` (
  `TransactionId` int NOT NULL AUTO_INCREMENT,
  `DateOf` date NOT NULL,
  `Amount` decimal(9,2) NOT NULL,
  `Information` varchar(255) DEFAULT NULL,
  `Tax` decimal(9,2) DEFAULT NULL,
  `AccountId` int NOT NULL,
  `LocationId` int NOT NULL,
  `CategoryId` int NOT NULL,
  `SubcategoryId` int NOT NULL,
  `Reconcile` tinyint(1) NOT NULL DEFAULT '0',
  `LedgerEditable` tinyint(1) NOT NULL DEFAULT '1',
  `Hidden` tinyint(1) NOT NULL DEFAULT '0',
  `Enabled` tinyint(1) NOT NULL DEFAULT '1',
  `HasReceipt` tinyint(1) NOT NULL DEFAULT '0',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`TransactionId`),
  KEY `AccountId` (`AccountId`),
  KEY `LocationId` (`LocationId`),
  KEY `CategoryId` (`CategoryId`),
  KEY `SubcategoryId` (`SubcategoryId`),
  CONSTRAINT `Transaction_ibfk_1` FOREIGN KEY (`AccountId`) REFERENCES `Account` (`AccountId`),
  CONSTRAINT `Transaction_ibfk_2` FOREIGN KEY (`LocationId`) REFERENCES `Location` (`LocationId`),
  CONSTRAINT `Transaction_ibfk_3` FOREIGN KEY (`CategoryId`) REFERENCES `Category` (`CategoryId`),
  CONSTRAINT `Transaction_ibfk_4` FOREIGN KEY (`SubcategoryId`) REFERENCES `Subcategory` (`SubcategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `UserTransaction`;
CREATE TABLE `UserTransaction` (
  `UserTransactionId` int NOT NULL AUTO_INCREMENT,
  `UserId` int NOT NULL,
  `TransactionId` int NOT NULL,
  PRIMARY KEY (`UserTransactionId`),
  KEY `UserId` (`UserId`),
  KEY `TransactionId` (`TransactionId`),
  CONSTRAINT `UserTransaction_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`),
  CONSTRAINT `UserTransaction_ibfk_2` FOREIGN KEY (`TransactionId`) REFERENCES `Transaction` (`TransactionId`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `PresetTransaction`;
CREATE TABLE `PresetTransaction` (
  `PresetTransactionId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(45) DEFAULT NULL,
  `Amount` decimal(9,2) NOT NULL,
  `Information` varchar(255) DEFAULT NULL,
  `AccountId` int NOT NULL,
  `LocationId` int NOT NULL,
  `CategoryId` int NOT NULL,
  `SubcategoryId` int NOT NULL,
  `Sequence` int DEFAULT '0',
  `Enabled` tinyint(1) NOT NULL DEFAULT '1',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PresetTransactionId`),
  KEY `AccountId` (`AccountId`),
  KEY `LocationId` (`LocationId`),
  KEY `CategoryId` (`CategoryId`),
  KEY `SubcategoryId` (`SubcategoryId`),
  CONSTRAINT `PresetTransaction_ibfk_1` FOREIGN KEY (`AccountId`) REFERENCES `Account` (`AccountId`),
  CONSTRAINT `PresetTransaction_ibfk_2` FOREIGN KEY (`LocationId`) REFERENCES `Location` (`LocationId`),
  CONSTRAINT `PresetTransaction_ibfk_3` FOREIGN KEY (`CategoryId`) REFERENCES `Category` (`CategoryId`),
  CONSTRAINT `PresetTransaction_ibfk_4` FOREIGN KEY (`SubcategoryId`) REFERENCES `Subcategory` (`SubcategoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `UserPresetTransaction`;
CREATE TABLE `UserPresetTransaction` (
  `UserPresetTransactionId` int NOT NULL AUTO_INCREMENT,
  `UserId` int NOT NULL,
  `PresetTransactionId` int NOT NULL,
  PRIMARY KEY (`UserPresetTransactionId`),
  KEY `UserId` (`UserId`),
  KEY `PresetTransactionId` (`PresetTransactionId`),
  CONSTRAINT `UserPresetTransaction_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`),
  CONSTRAINT `UserPresetTransaction_ibfk_2` FOREIGN KEY (`PresetTransactionId`) REFERENCES `PresetTransaction` (`PresetTransactionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `PresetGroup`;
CREATE TABLE `PresetGroup` (
  `PresetGroupId` int NOT NULL AUTO_INCREMENT,
  `PresetGroupName` varchar(45) DEFAULT NULL,
  `Information` varchar(255) DEFAULT NULL,
  `Sequence` int DEFAULT '0',
  `Enabled` tinyint(1) NOT NULL DEFAULT '1',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PresetGroupId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `PresetGroupTransaction`;
CREATE TABLE `PresetGroupTransaction` (
  `PresetGroupTransactionId` int NOT NULL AUTO_INCREMENT,
  `PresetGroupId` int NOT NULL,
  `PresetTransactionId` int NOT NULL,
  `Enabled` tinyint(1) NOT NULL DEFAULT '1',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PresetGroupTransactionId`),
  KEY `PresetGroupId` (`PresetGroupId`),
  KEY `PresetTransactionId` (`PresetTransactionId`),
  CONSTRAINT `PresetGroupTransaction_ibfk_1` FOREIGN KEY (`PresetGroupId`) REFERENCES `PresetGroup` (`PresetGroupId`),
  CONSTRAINT `PresetGroupTransaction_ibfk_2` FOREIGN KEY (`PresetTransactionId`) REFERENCES `PresetTransaction` (`PresetTransactionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Receipt`;
CREATE TABLE `Receipt` (
  `ReceiptId` int NOT NULL AUTO_INCREMENT,
  `TransactionId` int NOT NULL,
  `Information` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ReceiptId`),
  KEY `TransactionId` (`TransactionId`),
  CONSTRAINT `Receipt_ibfk_1` FOREIGN KEY (`TransactionId`) REFERENCES `Transaction` (`TransactionId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ReceiptItem`;
CREATE TABLE `ReceiptItem` (
  `ReceiptItemId` int NOT NULL AUTO_INCREMENT,
  `Quantity` int NOT NULL DEFAULT '1',
  `Amount` decimal(9,2) DEFAULT NULL,
  `Information` varchar(255) DEFAULT NULL,
  `ReceiptId` int NOT NULL,
  `ItemId` int DEFAULT NULL,
  `Enabled` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ReceiptItemId`),
  KEY `ReceiptId` (`ReceiptId`),
  KEY `ItemId` (`ItemId`),
  CONSTRAINT `ReceiptItem_ibfk_1` FOREIGN KEY (`ReceiptId`) REFERENCES `Receipt` (`ReceiptId`),
  CONSTRAINT `ReceiptItem_ibfk_2` FOREIGN KEY (`ItemId`) REFERENCES `Item` (`ItemId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `SidebarSettings`;
CREATE TABLE `SidebarSettings` (
  `SidebarSettingsId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(20) NOT NULL,
  `DisplayTitle` varchar(20) NOT NULL,
  `Information` varchar(255) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`SidebarSettingsId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `UserPresetGroup`;
CREATE TABLE `UserPresetGroup` (
  `UserPresetGroupId` int NOT NULL AUTO_INCREMENT,
  `UserId` int NOT NULL,
  `PresetGroupId` int NOT NULL,
  PRIMARY KEY (`UserPresetGroupId`),
  KEY `UserId` (`UserId`),
  KEY `PresetGroupId` (`PresetGroupId`),
  CONSTRAINT `UserPresetGroup_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`),
  CONSTRAINT `UserPresetGroup_ibfk_2` FOREIGN KEY (`PresetGroupId`) REFERENCES `PresetGroup` (`PresetGroupId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `AdminAccount`;
CREATE TABLE `AdminAccount` (
  `AdminAccountId` int NOT NULL AUTO_INCREMENT,
  `AdminName` varchar(25) NOT NULL,
  `Hashed` varchar(255) NOT NULL,
  PRIMARY KEY (`AdminAccountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `AdminTopics`;
CREATE TABLE `AdminTopics` (
  `AdminTopicsId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(20) NOT NULL,
  `DisplayTitle` varchar(20) NOT NULL,
  `Information` varchar(255) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`AdminTopicsId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `CfgNavbarLinks`;
CREATE TABLE `CfgNavbarLinks` (
  `CfgNavbarLinksId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(20) NOT NULL,
  `DisplayTitle` varchar(20) NOT NULL,
  `LinkText` varchar(45) NOT NULL,
  `Enabled` tinyint(1) NOT NULL DEFAULT '1',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CfgNavbarLinksId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `CfgSidebarView`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CfgSidebarView` (
  `CfgSidebarViewId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(25) NOT NULL,
  `DisplayTitle` varchar(35) NOT NULL,
  `Enabled` tinyint(1) NOT NULL DEFAULT '1',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CfgSidebarViewId`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `CfgTable`;
CREATE TABLE `CfgTable` (
  `CfgTableId` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(45) NOT NULL,
  `DisplayTitle` varchar(55) NOT NULL,
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CfgTableId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `CfgColumn`;
CREATE TABLE `CfgColumn` (
  `CfgColumnId` int NOT NULL,
  `CfgTableId` int NOT NULL,
  `Title` varchar(45) NOT NULL,
  `DisplayTitle` varchar(55) NOT NULL,
  `Value` varchar(45) DEFAULT NULL,
  `HasValues` tinyint(1) NOT NULL DEFAULT '1',
  `ShowTitle` tinyint(1) NOT NULL DEFAULT '1',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CfgColumnId`),
  UNIQUE KEY `CfgColumnId` (`CfgColumnId`),
  KEY `CfgTableId` (`CfgTableId`),
  CONSTRAINT `CfgColumn_ibfk_1` FOREIGN KEY (`CfgTableId`) REFERENCES `CfgTable` (`CfgTableId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `UsrCfgColumn`;
CREATE TABLE `UsrCfgColumn` (
  `UsrCfgColumnId` int NOT NULL AUTO_INCREMENT,
  `UserId` int NOT NULL,
  `CfgTableId` int NOT NULL,
  `CfgColumnId` int NOT NULL,
  `Sequence` int NOT NULL DEFAULT '0',
  `Enabled` tinyint(1) NOT NULL DEFAULT '1',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`UsrCfgColumnId`),
  KEY `UserId` (`UserId`),
  KEY `CfgTableId` (`CfgTableId`),
  KEY `CfgColumnId` (`CfgColumnId`),
  CONSTRAINT `UsrCfgColumn_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`),
  CONSTRAINT `UsrCfgColumn_ibfk_2` FOREIGN KEY (`CfgTableId`) REFERENCES `CfgTable` (`CfgTableId`),
  CONSTRAINT `UsrCfgColumn_ibfk_3` FOREIGN KEY (`CfgColumnId`) REFERENCES `CfgColumn` (`CfgColumnId`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `UsrCfgNewAccount`;
CREATE TABLE `UsrCfgNewAccount` (
  `UsrCfgNewAccountId` int NOT NULL AUTO_INCREMENT,
  `UserId` int NOT NULL,
  `SetLoc` int DEFAULT NULL,
  `SetCat` int DEFAULT NULL,
  `SetSub` int DEFAULT NULL,
  `AssetCat` int DEFAULT NULL,
  `AssetSub` int DEFAULT NULL,
  `LiabilityCat` int DEFAULT NULL,
  `LiabilitySub` int DEFAULT NULL,
  `EquityCat` int DEFAULT NULL,
  `EquitySub` int DEFAULT NULL,
  PRIMARY KEY (`UsrCfgNewAccountId`),
  KEY `UserId` (`UserId`),
  CONSTRAINT `UsrCfgNewAccount_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `UsrCfgSidebarView`;
CREATE TABLE `UsrCfgSidebarView` (
  `UsrCfgSidebarViewId` int NOT NULL AUTO_INCREMENT,
  `UserId` int DEFAULT NULL,
  `CfgSidebarViewId` int DEFAULT NULL,
  `UserEnabled` int NOT NULL DEFAULT '1',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `LastUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`UsrCfgSidebarViewId`),
  KEY `UserId` (`UserId`),
  KEY `CfgSidebarViewId` (`CfgSidebarViewId`),
  CONSTRAINT `UsrCfgSidebarView_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`),
  CONSTRAINT `UsrCfgSidebarView_ibfk_2` FOREIGN KEY (`CfgSidebarViewId`) REFERENCES `CfgSidebarView` (`CfgSidebarViewId`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*
End Create
#ecr
*/

/*
Begin Setup of new database
#bset
*/

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO UserRole (Title) VALUES
	('User'),
    ('Admin')
;

-- Admin Topics
INSERT INTO AdminTopics (Title, DisplayTitle, Information) VALUES
	('Navbar', 'Navbar Settings', 'Navbar controls')
;
INSERT INTO AdminTopics (Title, DisplayTitle, Information) VALUES
	('Sidebar', 'Sidebar Settings', 'Sidebar controls')
;

-- Admin Navbar 
INSERT INTO NavbarSettings (Title, DisplayTitle, Information) VALUES
	('Links', 'Links', 'Main navbar button links')
;

INSERT INTO SidebarSettings (Title, DisplayTitle, Information) VALUES
	('TopicButtons', 'Topic Buttons', 'Sidebar topic buttons (top section)');

INSERT INTO Flow (Flow, Rate) VALUES 
/*1*/('DEBIT', 1),
/*2*/('CREDIT', -1),
/*3*/('set...', 1)
;
INSERT INTO AccountCategory (AccountCategory) VALUES 
/*1*/('Asset'),
/*2*/('Liability'),
/*3*/('Equity')
;
INSERT INTO AccountType (AccountCategoryId, AccountType) VALUES 
/*1*/(1, 'Checking'),
/*2*/(1, 'Saving'),
/*3*/(2, 'Credit Card'),
/*4*/(2, 'Loan'),
/*5*/(2, 'Auto Finance'),
/*6*/(2, 'Auto Lease'),
/*7*/(3, 'Mortgage')
;

/*
Config Section
CfgTable
CfgTableColumn
- UsrCfgTableColumn
CfgSidebarView
- UsrCfgSidebarView
*/
INSERT INTO CfgTable (Title, DisplayTitle) VALUES 
/*1*/('TransactionTable', 'Transaction Table'),
/*2*/('SidebarAccountTable', 'Sidebar Accounts Table'),
/*3*/('SidebarCategoryTable', 'Sidebar Category Table')
;
-- 1: Transaction Table 100
INSERT INTO CfgColumn (CfgColumnId, CfgTableId, Title, DisplayTitle, `Value`, HasValues, ShowTitle) VALUES 
	(100, 1, 'TransactionId', 'Transaction Id', 'TransactionId', 1, 0),
	(101, 1, 'DateOf', 'Date', 'DateOf', 1, 1),
	(102, 1, 'AccountId', 'Account', 'AccountId', 1, 1),
	(103, 1, 'LocationTitle', 'Location', 'LocationTitle', 1, 1),
	(104, 1, 'CategoryId', 'Category', 'CategoryId', 1, 1),
	(105, 1, 'SubcategoryId', 'Subcategory', 'SubcategoryId', 1, 1),
	(106, 1, 'Information', 'Information', 'Information', 1, 0),
	(107, 1, 'Amount', 'Amount', 'Amount', 1, 1),
	(108, 1, 'Balance', 'Balance', 'Balance', 1, 1),
	(109, 1, 'Actions', 'Actions', NULL, 0, 1)
;
-- 2: Sidebar Account Table 200
INSERT INTO CfgColumn (CfgColumnId, CfgTableId, Title, DisplayTitle, `Value`, HasValues, ShowTitle) VALUES 
	(200, 2, 'AccountId', 'Account Id', 'AccountId', 1, 0),
	(201, 2, 'Title', 'Account', 'AccountTitle', 1, 1),
	(202, 2, 'Current', 'Current Balance', 'Current', 1, 1),
	(203, 2, 'Future', 'Future Balance', 'Future', 1, 1),
	(204, 2, 'ThisMonth', 'This Month', 'ThisMonth', 1, 1),
	(205, 2, 'LastMonth', 'LastMonth', 'LastMonth', 1, 1)
;
-- 3: Sidebar Category Table 300
INSERT INTO CfgColumn (CfgColumnId, CfgTableId, Title, DisplayTitle, `Value`, HasValues, ShowTitle) VALUES 
	(300, 3, 'CategoryId', 'Category Id', 'CategoryId', 1, 0),
	(301, 3, 'Title', 'Category', 'CategoryTitle', 1, 1),
	(302, 3, 'Subcategory', 'Subcategory', 'SubcategoryTitle', 1, 0),
	(303, 3, 'Current', 'Current Balance', 'Current', 1, 1),
	(304, 3, 'Future', 'Future Balance', 'Future', 1, 1),
	(305, 3, 'ThisMonth', 'This Month', 'ThisMonth', 1, 1),
	(306, 3, 'LastMonth', 'LastMonth', 'LastMonth', 1, 1)
;

INSERT INTO CfgSidebarView (Title, DisplayTitle) VALUES
/*1*/('Accounts', 'Account Details'),
/*2*/('Categories', 'Category Details'),
/*3*/('FilterLedger', 'Filter Ledger'),
/*4*/('Items', 'Item Details'),
/*5*/('PresetTransactions', 'Preset Transactions'),
/*6*/('Receipts', 'Receipt Details'),
/*7*/('Transaction', '+ Transaction'),
/*8*/('RecurringPayments', 'Recurring Payments'),  -- Added 3/1/22
/*9*/('Transactios', 'Transactions'); -- Added 3/2/22
;
-- INSERT INTO CfgSidebarView (Title, DisplayTitle) VALUES ('RecurringPayments', 'Recurring Payments');
-- INSERT INTO CfgSidebarView (Title, DisplayTitle) VALUES ('Transactios', 'Transactions');
-- UPDATE CfgSidebarView SET DisplayTitle = "Transactions" WHERE CfgSidebarViewId = 9;
UPDATE CfgSidebarView SET Enabled = 0 WHERE CfgSidebarViewId = 3;
-- UPDATE CfgSidebarView SET Enabled = 0 WHERE CfgSidebarViewId = 5;
-- UPDATE CfgSidebarView SET Enabled = 1 WHERE CfgSidebarViewId = 7;
-- UPDATE CfgSidebarView SET Enabled = 0 WHERE CfgSidebarViewId = 9;
-- INSERT INTO CfgSidebarView (Title, DisplayTitle) VALUES ('Expense', 'Expense');
-- INSERT INTO CfgSidebarView (Title, DisplayTitle) VALUES ('Income', 'Income');

INSERT INTO CfgNavbarLinks (Title, DisplayTitle, LinkText) VALUES
	('Ledger', 'Ledger', 'ledger'),
    ('Budget', 'Budget', 'budget'),
    ('Receipts', 'Receipts', 'receipts'),
    ('Items', 'Items', 'items')
;

SET FOREIGN_KEY_CHECKS = 1;

/*
End Setup
#eset
*/

/*
Begin Views
#bvw
*/
DROP VIEW IF EXISTS vLedger;
CREATE VIEW vLedger AS
	SELECT
		ut.UserId,
		t.TransactionId,
        t.DateOf,
		t.Amount,
        t.AccountId,
		a.Title AS 'AccountTitle',
		t.LocationId,
		l.Title AS 'LocationTitle',
		t.Information,
		t.CategoryId,
		c.Title AS 'CategoryTitle',
        c.FlowId,
        f.Flow,
		t.SubcategoryId,
		s.Title AS 'SubcategoryTitle',
		SUM(t.Amount) 
				OVER (PARTITION BY t.AccountId ORDER BY t.DateOf, t.TransactionId DESC) AS 'Balance',
		IF(t.DateOf > curdate(), '1', '0') AS 'Future',
        t.Reconcile,
        t.HasReceipt,
        t.Created,
        t.LastUpdated,
        a.IncludeInTotal
	FROM 
		`Transaction` t
		LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
        LEFT JOIN `Account` a ON t.AccountId = a.AccountId
		LEFT JOIN Location l ON t.LocationId = l.LocationId
		LEFT JOIN Category c ON t.CategoryId = c.CategoryId
		LEFT JOIN Flow f ON c.FlowId = f.FlowId
		LEFT JOIN Subcategory s ON t.SubcategoryId = s.SubcategoryId
        LEFT JOIN Receipt r ON t.TransactionId = r.TransactionId
	WHERE
		t.Enabled = 1
	ORDER BY
		t.DateOf DESC
;

DROP VIEW IF EXISTS vAccount;
CREATE VIEW vAccount AS
	SELECT 
		a.AccountId,
		ua.UserId,
		a.Title AS 'AccountTitle',
		a.AccountTypeId AS 'AccountTypeId',
		aty.AccountType AS 'AccountType',
		aty.AccountCategoryId,
		ac.AccountCategory,
		CONCAT('$', a.StartAmount) AS 'StartAmount',
		a.Information,
		(
			SELECT SUM(Amount)
            FROM `Transaction`
            WHERE AccountId = a.AccountId
            AND DateOf <= curdate()
		) AS 'Balance',
        (
			SELECT SUM(Amount)
            FROM `Transaction`
            WHERE AccountId = a.AccountId
		) AS 'Future',
        (
			SELECT SUM(Amount)
            FROM `Transaction`
            WHERE AccountId = a.AccountId
            AND MONTH(DateOf) = MONTH(curdate())
		) AS 'ThisMonth',
        (
			SELECT SUM(Amount)
            FROM `Transaction`
            WHERE AccountId = a.AccountId
            AND MONTH(DateOf) = MONTH(curdate() - INTERVAL 1 MONTH)
		) AS 'LastMonth',
		a.Tracking,
        a.OpenDate,
        a.Created,
        a.LastUpdated
	FROM
		`Account` a
		LEFT JOIN UserAccount ua ON a.AccountId = ua.AccountId
		LEFT JOIN AccountType aty ON a.AccountTypeId = aty.AccountTypeId
		LEFT JOIN AccountCategory ac ON aty.AccountCategoryId = ac.AccountCategoryId
		LEFT JOIN `Transaction` t ON a.AccountId = t.AccountId
	GROUP BY
		a.AccountId, 
        ua.UserAccountId
	ORDER BY
		a.Title ASC
;

DROP VIEW IF EXISTS vCategory;
CREATE VIEW vCategory AS 
	SELECT 
		c.CategoryId,
        uc.UserId,
        c.Title AS 'CategoryTitle',
        c.FlowId,
        f.Flow,
		c.Information,
        c.Sequence,
        c.Hidden,
        (
			SELECT SUM(Budget)
			FROM Subcategory
			WHERE CategoryId = c.CategoryId
		) AS 'Budget',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = MONTH(curdate())
		) AS 'MonthToDate',
         (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = MONTH(curdate() - INTERVAL 1 MONTH)
		) AS 'LastMonth',
		c.Created,
        c.LastUpdated
	FROM 
		Category c
		LEFT JOIN UserCategory uc ON c.CategoryId = uc.CategoryId
        LEFT JOIN Flow f ON c.FlowId = f.FlowId
	WHERE 
		c.Hidden = 0
        AND c.Enabled = 1
	GROUP BY
		c.CategoryId,
        uc.UserId
	ORDER BY
		c.Title ASC
;

DROP VIEW IF EXISTS vCategoryBudgetYear;
CREATE VIEW vCategoryBudgetYear AS 
	SELECT 
		c.CategoryId,
        uc.UserId,
        c.Title AS 'CategoryTitle',
        c.FlowId,
        f.Flow,
		c.Information,
        c.Sequence,
        c.Hidden,
        (
			SELECT SUM(Budget)
			FROM Subcategory
			WHERE CategoryId = c.CategoryId
		) AS 'Budget',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 1
		) AS 'January',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 2
		) AS 'February',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 3
		) AS 'March',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 4
		) AS 'April',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 5
		) AS 'May',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 6
		) AS 'June',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 7
		) AS 'July',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 8
		) AS 'August',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 9
		) AS 'September',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 10
		) AS 'October',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 11
		) AS 'November',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 12
		) AS 'December',
		c.Created,
        c.LastUpdated
	FROM 
		Category c
		LEFT JOIN UserCategory uc ON c.CategoryId = uc.CategoryId
        LEFT JOIN Flow f ON c.FlowId = f.FlowId
	WHERE 
		c.Hidden = 0
        AND c.Enabled = 1
	GROUP BY
		c.CategoryId,
        uc.UserId
	ORDER BY
		c.Title ASC
;

DROP VIEW IF EXISTS vSubcategory;
CREATE VIEW vSubcategory AS
	SELECT
		c.CategoryId,
        c.Title AS 'CategoryTitle',
		s.SubcategoryId,
        uc.UserId,
        s.Title AS 'SubcategoryTitle',
        s.Information,
        s.Budget,
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = MONTH(curdate())
		) AS 'MonthToDate',
        (
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = MONTH(curdate() - INTERVAL 1 MONTH)
		) AS 'LastMonth',
        c.Hidden,
        s.Created,
        s.LastUpdated
	FROM 
		Subcategory s
        LEFT JOIN UserCategory uc ON s.CategoryId = uc.CategoryId
        LEFT JOIN Category c ON s.CategoryId = c.CategoryId
	WHERE 
		c.Hidden = 0
		AND c.Enabled = 1
	ORDER BY
		c.Title ASC,
        s.Title ASC
;

DROP VIEW IF EXISTS vPresetTransaction;
CREATE VIEW vPresetTransaction AS
	SELECT
		current_date() AS 'DateOf',
        upt.UserId,
		pt.PresetTransactionId,
        pt.Title AS 'PresetTitle',
		pt.Amount,
        pt.AccountId,
        a.Title AS 'AccountTitle',
        pt.LocationId,
        l.Title AS 'LocationTitle',
        pt.CategoryId,
        c.Title AS 'CategoryTitle',
        pt.SubcategoryId,
        s.Title AS 'SubCategoryTitle',
        pt.Information,
        pt.Created,
        pt.LastUpdated
	FROM 
		PresetTransaction pt
		LEFT JOIN UserPresetTransaction upt ON pt.PresetTransactionId = upt.UserPresetTransactionId
		LEFT JOIN `Account` a ON pt.AccountId = a.AccountId
        LEFT JOIN Location l ON pt.LocationId = l.LocationId
        LEFT JOIN Category c ON pt.CategoryId = c.CategoryId
        LEFT JOIN Subcategory s ON pt.SubcategoryId = s.SubcategoryId
;

DROP VIEW IF EXISTS vLocation;
CREATE VIEW vLocation AS
	SELECT DISTINCT
		l.LocationId,
        ul.UserId,
		l.Title AS 'LocationTitle',
        l.Information,
        l.Hidden,
        l.Editable,
        l.LedgerEditable
	FROM
		Location l
        LEFT JOIN UserLocation ul ON l.LocationId = ul.LocationId
;

DROP VIEW IF EXISTS vItem;
CREATE VIEW vItem AS
	SELECT
		ui.UserId,
		i.ItemId,
        i.Title AS 'ItemTitle',
        i.Information,
        (
			SELECT ri.Amount
			FROM ReceiptItem ri
            LEFT JOIN Receipt r ON ri.ItemId = ItemId
            LEFT JOIN `Transaction` t ON r.TransactionId = t.TransactionId
            WHERE ri.ItemId = i.ItemId
            ORDER BY t.DateOf DESC
            LIMIT 1
        ) AS 'LastAmount',
        (
			SELECT l.Title
			FROM `Transaction` t
            LEFT JOIN Location l ON t.LocationId = l.LocationId
            LEFT JOIN Receipt r ON t.TransactionId = r.TransactionId
            LEFT JOIN ReceiptItem ri ON r.ReceiptId = ri.ReceiptId
            LEFT JOIN Item ii ON ri.ItemId = ii.ItemId
            WHERE ii.ItemId = i.ItemId
            ORDER BY t.DateOf DESC
            LIMIT 1
        ) AS 'LastLocation',
        (
			SELECT t.DateOf
			FROM `Transaction` t
            LEFT JOIN Receipt r ON t.TransactionId = r.TransactionId
            LEFT JOIN ReceiptItem ri ON r.ReceiptId = ri.ReceiptId
            WHERE ri.ItemId = i.ItemId
            ORDER BY t.DateOf DESC
            LIMIT 1
        ) AS 'LastDateOf'
	FROM
		Item i
        LEFT JOIN UserItem ui ON i.ItemId = ui.ItemId
        LEFT JOIN ReceiptItem ri ON i.ItemId = ri.ItemId
;

DROP VIEW IF EXISTS vUserConfigColumn;
CREATE VIEW vUserConfigColumn AS 
	SELECT
		cc.*
		FROM Users u
        LEFT JOIN UsrCfgColumn ucc ON u.UserId = ucc.UserId
        LEFT JOIN CfgColumn cc ON ucc.CfgColumnId = cc.CfgColumnId
;

DROP VIEW IF EXISTS vUserConfigSidebarView;
CREATE VIEW vUserConfigSidebarView AS
	SELECT
		u.UserId,
		csv.CfgSidebarViewId,
        ucsv.UsrCfgSidebarViewId,
        csv.Title AS 'Title',
        csv.DisplayTitle AS 'DisplayTitle',
        ucsv.UserEnabled
	FROM
		Users u
		LEFT JOIN UsrCfgSidebarView ucsv ON u.UserId = ucsv.UserId
		LEFT JOIN CfgSidebarView csv ON ucsv.CfgSidebarViewId = csv.CfgSidebarViewId
    WHERE 
		ucsv.UsrCfgSidebarViewId IS NOT NULL
		AND csv.Enabled = 1;
;

DROP VIEW IF EXISTS vUserConfigNewAccount;
CREATE VIEW vUserConfigNewAccount AS
	SELECT
		ucna.*
	FROM
		Users u
	LEFT JOIN UsrCfgNewAccount ucna ON u.UserId = ucna.UserId
;

DROP VIEW IF EXISTS vCfgNavbarLinks;
CREATE VIEW vCfgNavbarLinks AS
	SELECT
		*
	FROM
		CfgNavbarLinks
;
/*
End Views
*/

/*
Begin Stored Procecures
#bsp
*/
DROP PROCEDURE IF EXISTS UserCreate;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UserCreate`(
	IN $Email VARCHAR(75),
    IN $Username VARCHAR(25),
    IN $HashPass VARCHAR(255), 
    IN $FirstName VARCHAR(45), 
    IN $LastName VARCHAR(45)
)
BEGIN
	INSERT INTO Person (Email, Username, FirstName, LastName) VALUES 
		($Email, $Username, $FirstName, $LastName)
	;
    SET @PersonId = last_insert_id();
    
    INSERT INTO HashTable (PersonId, HashPass) VALUES 
		(@PersonId, $HashPass)
	;
    
	-- Generate random number for UserId
    SET @RandId = (
		SELECT NUM
		FROM (SELECT FLOOR( RAND() * (999999999-111111111) + 111111111) AS NUM) UX
		WHERE NUM NOT IN (SELECT UserId FROM Users)
	);
    
    INSERT INTO Users (
		UserId,
        PersonId
	) VALUES 
		(@RandId, @PersonId)
	;
	SET @UserId = @RandId;
    
    INSERT INTO UsrCfgNewAccount (UserId) VALUES (@UserId);
	
	/*
    Default Location
    - Set: Location is 'Set'
    - does not show up in lcoation list
    */
    INSERT INTO Location (
		Title,
        Information,
        Hidden,
        Editable,
        LedgerEditable
		) VALUES 
			("Set Location...", "Please choose a location", 1, 0, 0);
	SET @LocId = last_insert_id();
    INSERT INTO UserLocation (UserId, LocationId) VALUES (@UserId, @LocId);
    UPDATE UsrCfgNewAccount SET SetLoc = @LocId WHERE UserId = @UserId;
    
	/*
	Default Categories and Subcategories
	- Set: default when no category or subcategory is selected
	- Start: Category and Subcategory for new account start amount Asset, Liability, Equity
	*/
    
    -- Set
    INSERT INTO Category (
		Title,
        Information,
        Editable,
        Hidden,
        Flowid
        ) VALUES
			("Set...", "Pleaae choose a category", 0, 1, 1);
	SET @CatId = last_insert_id();
    
    INSERT INTO UserCategory (
		UserId,
        CategoryId
		) VALUES
			(@UserId, @CatId);
	
    INSERT INTO Subcategory (
		Title,
        Information,
        Editable,
        Hidden,
        CategoryId
		) VALUES
			("Set...", "Please choose a subcategory", 0, 1, @CatId);
	SET @SubId = last_insert_id();
    
    UPDATE UsrCfgNewAccount SET SetCat = @CatId, SetSub = @SubId WHERE UserId = @UserId;
	
    -- New Asset Account
    INSERT INTO Category (
		Title,
        Information,
        Editable,
        Hidden,
        Flowid
        ) VALUES
			("New Account Setup", "New asset account", 0, 1, 1);
	SET @CatId = last_insert_id();
    
    INSERT INTO UserCategory (
		UserId,
        CategoryId
		) VALUES
			(@UserId, @CatId);
	
    INSERT INTO Subcategory (
		Title,
        Information,
        Editable,
        Hidden,
        CategoryId
		) VALUES
			("Asset Account", "New asset account starting balance", 0, 1, @CatId);
	SET @SubId = last_insert_id();
	
    UPDATE UsrCfgNewAccount SET AssetCat = @CatId, AssetSub = @SubId WHERE UserId = @UserId;
    
    -- New Liability Account
    INSERT INTO Category (
		Title,
        Information,
        Editable,
        Hidden,
        Flowid
        ) VALUES
			("New Account Setup", "New laibility account", 0, 1, 2);
	SET @CatId = last_insert_id();
    
    INSERT INTO UserCategory (
		UserId,
        CategoryId
		) VALUES
			(@UserId, @CatId);
	
    INSERT INTO Subcategory (
		Title,
        Information,
        Editable,
        Hidden,
        CategoryId
		) VALUES
			("Liability Account", "New asset account starting balance", 0, 1, @CatId);
	SET @SubId = last_insert_id();
            
	UPDATE UsrCfgNewAccount SET LiabilityCat = @CatId, LiabilitySub = @SubId WHERE UserId = @UserId;
    
    -- New Equity Account
    INSERT INTO Category (
		Title,
        Information,
        Editable,
        Hidden,
        Flowid
        ) VALUES
			("New Account Setup", "New equity account", 0, 1, 1);
	SET @CatId = last_insert_id();
    
    INSERT INTO UserCategory (
		UserId,
        CategoryId
		) VALUES
			(@UserId, @CatId);
	
    INSERT INTO Subcategory (
		Title,
        Information,
        Editable,
        Hidden,
        CategoryId
		) VALUES
			("Liability equity", "New equity account starting balance", 0, 1, @CatId);
	SET @SubId = last_insert_id();
    
    UPDATE UsrCfgNewAccount SET EquityCat = @CatId, EquitySub = @SubId WHERE UserId = @UserId;
    
    SET FOREIGN_KEY_CHECKS=0;
    
    -- Sidebar Views
    INSERT INTO UsrCfgSidebarView (UserId, CfgSidebarViewId) VALUES
		(@UserId, 1),
        (@UserId, 2),
        (@UserId, 3),
        (@UserId, 4),
        (@UserId, 5),
        (@UserId, 6),
        (@UserId, 7),
        (@UserId, 8),
        (@UserId, 0)
	;
    
    -- Transaction Table
    INSERT INTO UsrCfgColumn (UserId, CfgTableId, CfgColumnId, Sequence) VALUES
		(@UserId, 1, 100, 1),
        (@UserId, 1, 101, 2),
        (@UserId, 1, 102, 3),
        (@UserId, 1, 103, 4),
        (@UserId, 1, 104, 5),
        (@UserId, 1, 105, 6),
        (@UserId, 1, 106, 7),
        (@UserId, 1, 107, 8)
	;
    
    -- Sidebar Account Table
    INSERT INTO UsrCfgColumn (UserId, CfgTableId, CfgColumnId, Sequence) VALUES
		(@UserId, 2, 100, 1),
        (@UserId, 2, 201, 2),
        (@UserId, 2, 202, 3),
        (@UserId, 2, 203, 4),
        (@UserId, 2, 204, 5),
        (@UserId, 2, 205, 6)
	;
    
    -- Sidebar Category Table
    INSERT INTO UsrCfgColumn (UserId, CfgTableId, CfgColumnId, Sequence) VALUES
		(@UserId, 3, 300, 1),
        (@UserId, 3, 301, 2),
        (@UserId, 3, 302, 3),
        (@UserId, 3, 303, 4),
        (@UserId, 3, 304, 5),
        (@UserId, 3, 305, 6),
        (@UserId, 3, 306, 7)
	;
    SET FOREIGN_KEY_CHECKS=1;
/*
09:46:18	
CALL UserCreate('jamie@nortamzzo.com', 'a2eRlHm6sbiZ4qREHYpYzo8aGrrB1XeCaAwhasih/kw=', 'Jamie', 'Alarie')	
Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails 
(`Funds007`.`UsrCfgColumn`, CONSTRAINT `UsrCfgColumn_ibfk_3` FOREIGN KEY (`CfgColumnId`) REFERENCES `CfgColumn` (`CfgColumnId`))	0.125 sec
*/
    
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS UserAuthenticate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UserAuthenticate`(
	IN $Email VARCHAR(75),
    IN $Username VARCHAR(25),
    IN $HashPass VARCHAR(255)
)
BEGIN
    SELECT 
		u.UserId,
        p.Email,
        p.Username,
        p.FirstName,
        p.LastName,
        u.UserRoleId AS 'UserRole'
	FROM 
		Users u
		LEFT JOIN Person p ON u.PersonId = p.PersonId
        LEFT JOIN UserRole r ON u.UserRoleId = r.UserRoleId
        LEFT JOIN HashTable h ON p.PersonId = h.PersonId
	WHERE
		h.HashPass = $HashPass
        AND CASE
			WHEN $Email IS NOT NULL THEN p.Email = $Email
            WHEN $Username IS NOT NULL THEN p.Username = $Username
		END
	;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS AdminCreateAccount; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AdminCreateAccount`(
	IN $AdminName VARCHAR(45),
    IN $Hashed VARCHAR(255)
)
BEGIN
	INSERT INTO AdminAccount (AdminName, Hashed) VALUES
		($AdminName, $Hashed)
	;
    
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS AccountCreate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AccountCreate`(
	IN $UserId VARCHAR(75),
    IN $Title VARCHAR(45),
    IN $StartAmount DECIMAL(11,2),
    IN $Information VARCHAR(255),
    IN $OpenDate DATE,
    IN $AccountTypeId INT,
    IN $Tracking INT
)
BEGIN
    CASE
		WHEN (SELECT MAX(a.Sequence) FROM `Account` a LEFT JOIN UserAccount ua ON a.AccountId = ua.AccountId WHERE ua.UserId = $UserId) IS NULL THEN 
			SET @Sequence = 1;
		WHEN (SELECT MAX(a.Sequence) FROM `Account` a LEFT JOIN UserAccount ua ON a.AccountId = ua.AccountId WHERE ua.UserId = $UserId) = 0 THEN 
			SET @Sequence = 1;
		WHEN (SELECT MAX(a.Sequence) FROM `Account` a LEFT JOIN UserAccount ua ON a.AccountId = ua.AccountId WHERE ua.UserId = $UserId) > 0 THEN 
			SET @Sequence := (SELECT MAX(a.Sequence) FROM `Account` a LEFT JOIN UserAccount ua ON a.AccountId = ua.AccountId WHERE ua.UserId = $UserId) + 1;
	END CASE;
	
    IF ($OpenDate IS NULL) THEN
		SET @OpenDate = curdate();
	ELSE
		SET @OpenDate = $OpenDate;
	END IF;
    
    INSERT INTO `Account` (
        Title,
        StartAmount,
        Information,
        OpenDate,
        Sequence,
        AccountTypeId,
        Tracking
		) VALUES 
			($Title, $StartAmount, @Information, @OpenDate, @Sequence, $AccountTypeId, $Tracking);
    SET @AccountId = last_insert_id();
    
    INSERT INTO UserAccount (
		UserId,
        AccountId
        ) VALUES 
			($UserId, @AccountId);
	
    -- Insert Starting Transaction
    SET @AccCat = (
		SELECT ac.AccountCategoryId
        FROM AccountType aty
        LEFT JOIN AccountCategory ac ON aty.AccountCategoryId = ac.AccountCategoryId
        WHERE aty.AccountTypeId = $AccountTypeId
	);
    
    SELECT SetLoc FROM UsrCfgNewAccount WHERE UserId = $UserId;
    SET @LocationId = (SELECT SetLoc FROM UsrCfgNewAccount WHERE UserId = $UserId);
    
	-- Set Category & Subcategory
    CASE
		WHEN @AccCat = 1 THEN
			SET @Info = "New Asset Account.";
			SET @CatId = (SELECT AssetCat FROM UsrCfgNewAccount WHERE UserId = $UserId LIMIT 1);
            SET @SubId = (SELECT AssetSub FROM UsrCfgNewAccount WHERE UserId = $UserId LIMIT 1);
		WHEN @AccCat = 2 THEN
			SET @Info = "New Liability Account.";
			SET @CatId = (SELECT LiabilityCat FROM UsrCfgNewAccount WHERE UserId = $UserId LIMIT 1);
            SET @SubId = (SELECT LiabilitySub FROM UsrCfgNewAccount WHERE UserId = $UserId LIMIT 1);
        WHEN @AccCat = 3 THEN
			SET @Info = "New Equity Account.";
			SET @CatId = (SELECT EquityCat FROM UsrCfgNewAccount WHERE UserId = $UserId LIMIT 1);
            SET @SubId = (SELECT EquitySub FROM UsrCfgNewAccount WHERE UserId = $UserId LIMIT 1);
	END CASE;
  
    INSERT INTO `Transaction` (
		DateOf,
        Amount,
        Information,
        AccountId,
        LocationId,
        CategoryId,
        SubcategoryId,
		LedgerEditable,
        Enabled,
        Hidden
        ) VALUES 
			(@OpenDate, $StartAmount, @Info, @AccountId, @LocationId, @CatId, @SubId, 0, 1, 1);
    
    SET @TransId = last_insert_id();
    
    INSERT INTO UserTransaction (UserId, TransactionId) VALUES ($UserId, @TransId);

END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS AccountGetData;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AccountGetData`(
	IN $UserId INT
)
BEGIN
	SELECT 
		*
	FROM
		vAccount
	WHERE
		UserId = $UserId
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS AccountTypeGet; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AccountTypeGet`()
BEGIN
	SELECT * FROM AccountType;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS CategoryCreate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CategoryCreate`(
	IN $UserId INT, 
    IN $Title VARCHAR(45), 
    IN $Information VARCHAR(255),
    IN $FlowId INT
)
BEGIN
	CASE
		WHEN (SELECT MAX(c.Sequence) FROM Category c LEFT JOIN UserCategory uc ON c.CategoryId = uc.CategoryId WHERE uc.UserId = $UserId) IS NULL THEN 
			SET @Sequence = 1;
		WHEN (SELECT MAX(c.Sequence) FROM Category c LEFT JOIN UserCategory uc ON c.CategoryId = uc.CategoryId WHERE uc.UserId = $UserId) = 0 THEN 
			SET @Sequence = 1;
		WHEN (SELECT MAX(c.Sequence) FROM Category c LEFT JOIN UserCategory uc ON c.CategoryId = uc.CategoryId WHERE uc.UserId = $UserId) > 0 THEN 
			SET @Sequence = (SELECT MAX(c.Sequence) FROM Category c LEFT JOIN UserCategory uc ON c.CategoryId = uc.CategoryId WHERE uc.UserId = $UserId) + 1;
	END CASE;
    
     INSERT INTO Category (
        Title,
        Information,
        Sequence,
        FlowId
	) VALUES 
		($Title, $Information, @Sequence, $FlowId);
    SET @CategoryId = last_insert_id();
    
    INSERT INTO UserCategory (
		UserId,
        CategoryId
        ) Values 
			($UserId, @CategoryId);
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS CategoryGetData;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CategoryGetData`(
	IN $UserId INT
)
BEGIN
	SELECT 
		*
	FROM 
		vCategory
	WHERE 
		UserId = $UserId
		AND Hidden = 0
	ORDER BY
		CategoryTitle ASC
	;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS CategoryGetBudgetData;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CategoryGetBudgetData`(
	IN $UserId INT,
    IN $YearOf INT
)
BEGIN
	SELECT
		c.CategoryId,
		(
			SELECT SUM(Budget)
			FROM Subcategory
			WHERE CategoryId = c.CategoryId
		) AS 'Budget',
		c.Title AS 'CategoryTitle',
        COALESCE(
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND YEAR(DateOf) = $YearOf
		), 0) AS 'YearToDate',
        COALESCE(
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 1
			AND YEAR(DateOf) = $YearOf
		), 0) AS 'January',
        COALESCE(
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 2
			AND YEAR(DateOf) = $YearOf
		), 0) AS 'February',
        COALESCE(
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 3
			AND YEAR(DateOf) = $YearOf
		), 0) AS 'March',
        COALESCE(
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 4
			AND YEAR(DateOf) = $YearOf
		), 0) AS 'April',
        COALESCE(
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 5
			AND YEAR(DateOf) = $YearOf
		), 0) AS 'May',
        COALESCE(
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 6
			AND YEAR(DateOf) = $YearOf
		), 0) AS 'June',
        COALESCE(
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 7
			AND YEAR(DateOf) = $YearOf
		), 0) AS 'July',
        COALESCE(
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 8
			AND YEAR(DateOf) = $YearOf
		), 0) AS 'August',
        COALESCE(
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 9
			AND YEAR(DateOf) = $YearOf
		), 0) AS 'September',
        COALESCE(
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 10
			AND YEAR(DateOf) = $YearOf
		), 0) AS 'October',
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 11
			AND YEAR(DateOf) = $YearOf
		) AS 'November',
        COALESCE(
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE CategoryId = c.CategoryId
			AND MONTH(DateOf) = 12
			AND YEAR(DateOf) = $YearOf
		), 0) AS 'December'
	FROM 
		Category c
		LEFT JOIN UserCategory uc ON c.CategoryId = uc.CategoryId
	WHERE 
		c.Hidden = 0
		AND c.Enabled = 1
		AND uc.UserId = $UserId
	ORDER BY
		c.Title ASC
	;
END;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS CategoryUpdate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CategoryUpdate`(
	IN $UserId INT,
    IN $CategoryId INT,
    IN $Title VARCHAR(45),
    IN $FlowId INT,
	IN $InformationId INT,
    IN $Information VARCHAR(255)
)
BEGIN
	UPDATE Category
    SET Title = $Title
	WHERE CategoryId = $CategoryId;
        
	UPDATE CategoryFlow
    SET FlowId = $FlowId
    WHERE CategoryId = $CategoryId;
        
	UPDATE Information
    SET Information = $Information
    WHERE InformationId = $InformationId;
        
END ;;
DELIMITER ;

-- -- ************************************************************************************************
-- -- DROP PROCEDURE IF EXISTS ItemCreate;
-- DELIMITER ;;
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `ItemCreate`(
-- 	IN $UserId INT,
--     IN $Title VARCHAR(255)
-- )
-- BEGIN
-- /*
-- Item
-- UserItem
-- ItemDateOf
-- ItemLocation
-- ItemAmount
-- ItemInformation
-- */
-- 	
--     INSERT INTO Item (
-- 		Title
-- 	) VALUES (
-- 		$Title
-- 	);
--     SET @ItemId = last_insert_id();
--     
--     INSERT INTO UserItem (
-- 		UserId,
--         ItemId
-- 	) VALUES (
-- 		$UserId,
--         @ItemId
-- 	);
--     
--     INSERT INTO DateOf (
-- 		DateOf
-- 	) VALUES (
-- 		$DateOf
-- 	);
--     SET @DateOfId = last_insert_id();
--     
--     INSERT INTO ItemDateOf (
-- 		ItemId,
-- 		DateOfId
-- 	) VALUES (
-- 		@ItemId,
--         @DateOfId
-- 	);
--     
--     INSERT INTO Information (
-- 		Information
-- 	) VALUES (
-- 		$Information
-- 	);
--     SET @InformationId = last_insert_id();
--     
--     INSERT INTO ItemInformation (
-- 		ItemId,
--         InformationId
-- 	) VALUES (
-- 		@ItemId,
--         @InformationId
-- 	);
--     
--     IF ($Location <> "") THEN
-- 		IF (
-- 			SELECT DISTINCT
-- 				l.LocationId
-- 			FROM Location l
--             LEFT JOIN UserLocation ul ON l.LocationId = ul.LocationId
-- 			WHERE l.Title = $Title
-- 				AND ul.UserId = $UserId
-- 			) IS NOT NULL
-- 		THEN 
-- 			SET @LocationId = (
-- 			SELECT DISTINCT
-- 				l.LocationId 
-- 			FROM Location l
--             LEFT JOIN UserLocation ul ON l.LocationId = ul.LocationId
-- 			WHERE l.Title = $Title
-- 				AND ul.UserId = $UserId
-- 			);
-- 		ELSE 
-- 			INSERT INTO Location (Title) VALUES ($Title);
--             SET @LocationId = last_insert_id();
--             INSERT INTO UserLocation (UserId, LocationId) VALUES ($UserId, @LocationId);
--             End IF;
-- 	END IF;
--     INSERT INTO ItemLocation (
-- 		ItemId, 
--         LocationId
-- 	) VALUES (
-- 		@ItemId, 
--         @LocationId
-- 	);
--     
-- END ;;
-- DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS LocationGetData; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `LocationGetData`(
	IN $UserId INT
)
BEGIN
	SELECT
		*
	FROM vLocation
    WHERE UserId = $UserId
    ORDER BY LocationTitle ASC;
END;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS LocationGetList; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `LocationGetList`(
	IN $UserId INT
)
BEGIN
	SELECT 
		TRIM(l.Title) AS 'LocationTitle'
    FROM 
		Location l
        LEFT JOIN UserLocation ul ON l.LocationId = ul.LocationId
    WHERE 
		ul.UserId = $UserId 
    ORDER BY 
		l.Title ASC;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS LocationGetListSearch; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `LocationGetListSearch`(
	IN $UserId INT,
    IN $Term VARCHAR(45)
)
BEGIN
	SELECT
		l.Title
	FROM 
		Location l
        LEFT JOIN UserLocation ul ON l.LocationId = ul.LocationId
	WHERE 
		l.Title LIKE CONCAT($Term, '%')
		AND ul.UserId = $UserId;
END ;;
DELIMITER ;
-- ************************************************************************************************
-- -- DROP PROCEDURE IF EXISTS PresetTransactionCreate; 
-- DELIMITER ;;
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `PresetTransactionCreate`(
-- 	IN $UserId INT,
--     IN $Title VARCHAR(45),
--     IN $Amount DECIMAL(9,2),
--     IN $AccountId INT,
--     IN $Location VARCHAR(45),
-- 	IN $CategoryId INT,
--     IN $SubcategoryId INT,
--     IN $Information VARCHAR(255)
-- )
-- BEGIN

-- 	CASE
-- 		WHEN (
-- 			SELECT MAX(Sequence) 
-- 			FROM PresetTransaction pt 
-- 			LEFT JOIN UserPresetTransaction upt ON pt.PresetTransactionId = upt.PresetTransactionId
-- 			WHERE upt.UserId = $UserId) IS NULL THEN 
-- 				SET @Sequence = 1;
-- 		WHEN (
-- 			SELECT MAX(Sequence) 
-- 			FROM PresetTransaction pt 
-- 			LEFT JOIN UserPresetTransaction upt ON pt.PresetTransactionId = upt.PresetTransactionId
-- 			WHERE upt.UserId = $UserId) = 0 THEN
-- 				SET @Sequence = 1;
-- 		WHEN (
-- 			SELECT MAX(Sequence) 
-- 			FROM PresetTransaction pt 
-- 			LEFT JOIN UserPresetTransaction upt ON pt.PresetTransactionId = upt.PresetTransactionId
-- 			WHERE upt.UserId = $UserId) > 0 THEN
-- 				SET @Sequence := (
-- 					SELECT MAX(Sequence) 
-- 					FROM PresetTransaction pt 
-- 					LEFT JOIN UserPresetTransaction upt ON pt.PresetTransactionId = upt.PresetTransactionId
-- 					WHERE upt.UserId = $UserId) + 1;
-- 	END CASE;

-- 	INSERT INTO PresetTransaction (
-- 		Title,
--         Sequence
-- 	) VALUES (
-- 		$Title,
--         @Sequence
-- 	);
--     SET @PresetId = last_insert_id();
--     
--     INSERT INTO UserPresetTransaction (
-- 		UserId,
--         PresetTransactionId
-- 	) VALUES (
--         $UserId,
--         @PresetId
-- 	);
--     
--     INSERT INTO Amount (
-- 		Amount
-- 	) VALUES (
-- 		$Amount
-- 	);
--     SET @AmountId = last_insert_id();
--     
--     INSERT INTO PresetAmount (
-- 		PresetTransactionId,
--         AmountId
-- 	) VALUES (
-- 		@PresetId,
--         @AmountId
-- 	);
--     
--     INSERT INTO PresetAccount (
-- 		PresetTransactionId,
--         AccountId
-- 	) VALUES (
-- 		@PresetId,
--         $AccountId
-- 	);
--     
--     INSERT INTO PresetCategory (
-- 		PresetTransactionId,
--         CategoryId
-- 	) VALUES (
-- 		@PresetId,
--         $CategoryId
-- 	);
--     
--     IF ($Information IS NULL) THEN 
-- 		SET @Information = " ";
--     ELSE 
-- 		SET @Information = $Information;
--     END IF;
--     INSERT INTO Information (Information) VALUES (@Information);
--     SET @InformationId = last_insert_id();
--     
--     INSERT INTO PresetInformation (
-- 		PresetTransactionId,
--         InformationId
-- 	) VALUES (
-- 		@PresetId,
--         @InformationId
-- 	);
--     
--     IF ($Location <> "") THEN
-- 		IF (
-- 			SELECT DISTINCT
-- 				LocationId
-- 			FROM Location
-- 			WHERE Title = $Title
-- 				AND UserId = $UserId
-- 			) IS NOT NULL 
-- 		THEN 
-- 			SET @LocationId = (
-- 			SELECT DISTINCT
-- 				LocationId
-- 			FROM Location
-- 			WHERE Title = $Title
-- 				AND UserId = $UserId);
-- 		ELSE 
-- 			INSERT INTO Location (UserId, Title) VALUES ($UserId, $Location);
-- 			SET @LocationId = last_insert_id();
-- 		END IF;
-- 	END IF;
--     
--     INSERT INTO PresetSubcategory (
-- 		PresetTransactionId,
--         SubcategoryId
-- 	) VALUES (
-- 		@PresetId,
--         $SubcategoryId
-- 	);

-- END ;;
-- DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS PresetGetData; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `PresetGetData`(
	IN $UserId INT
)
BEGIN
	SELECT
		*
	FROM
		vPresetTransaction
    WHERE 
		UserId = $UserId;
END ;;
DELIMITER ;
-- -- ************************************************************************************************
-- -- DROP PROCEDURE IF EXISTS PresetGetDataById; 
-- DELIMITER ;;
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `PresetGetDataById`(
-- 	IN $UserId INT,
--     IN $PresetId INT
-- )
-- BEGIN
-- 	SELECT
-- 		current_date() AS 'DateOf',
-- 		pt.PresetTransactionId,
--         pt.Title AS 'PresetName',
-- 		pam.AmountId,
--         a.Amount,
--         pac.AccountId,
--         a.Title AS 'AccountTitle',
--         pl.LocationId,
--         l.Title AS 'LocationTitle',
--         pc.CategoryId,
--         c.Title AS 'CategoryTitle',
--         ps.SubcategoryId,
--         s.Title AS 'SubcategoryTitle',
--         pi.InformationId,
--         i.Information,
--         pt.Created,
--         pt.LastUpdated
-- 	FROM 
-- 		PresetTransaction pt
-- 		LEFT JOIN UserPresetTransaction upt ON pt.PresetTransactionId = upt.UserPresetTransactionId
--         LEFT JOIN PresetAccount pac ON pt.PresetTransactionId = pac.PresetTransactionId
-- 		LEFT JOIN `Account` a ON pac.AccountId = a.AccountId
--         LEFT JOIN PresetAmount pam ON pt.PresetTransactionId = pam.PresetTransactionId
--         LEFT JOIN Amount am ON pam.AmountId = am.AmountId
--         LEFT JOIN PresetLocation pl ON pt.PresetTransactionId = pl.PresetTransactionId
--         LEFT JOIN Location l ON pl.LocationId = l.LocationId
--         LEFT JOIN PresetCategory pc ON pt.PresetTransactionId = pc.PresetTransactionId
--         LEFT JOIN Category c ON pc.CategoryId = c.CategoryId
--         LEFT JOIN PresetSubcategory ps ON pt.PresetTransactionId = ps.PresetTransactionId
--         LEFT JOIN Subcategory s ON ps.SubcategoryId = s.SubcategoryId
--         LEFT JOIN PresetInformation pi ON pt.PresetTransactionId = pi.PresetTransactionId
--         LEFT JOIN Information i ON pi.InformationId = i.InformationId
--     WHERE 
-- 		upt.UserId = $UserId
--         AND pt.PresetTransactionId = $PresetId
-- 	;
--     
-- END ;;
-- DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS SubcategoryCreate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SubcategoryCreate`(
	IN $UserId INT,
    IN $CategoryId INT, 
    IN $Title VARCHAR(45), 
    IN $Information VARCHAR(255)
)
BEGIN
	-- Generate random number for id
    CASE
		WHEN (SELECT MAX(Sequence) FROM Subcategory WHERE CategoryId = $CategoryId) IS NULL THEN 
			SET @Sequence = 1;
		WHEN (SELECT MAX(Sequence) FROM Subcategory WHERE CategoryId = $CategoryId) = 0 THEN 
			SET @Sequence = 1;
		WHEN (SELECT MAX(Sequence) FROM Subcategory WHERE CategoryId = $CategoryId) > 0 THEN 
			SET @Sequence := (SELECT MAX(Sequence) FROM Subcategory WHERE CategoryId = $CategoryId) + 1;
	END CASE;
    
    INSERT INTO Subcategory (
        Title,
        Information,
        CategoryId,
        Sequence
		) 
        VALUES 
			($Title, $Information, $CategoryId, @Sequence);
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS SubcategoryGetData; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SubcategoryGetData`(
	IN $UserId INT
)
BEGIN
	SELECT
		*
	FROM
		vSubcategory
	WHERE 
		UserId = $UserId
		AND Hidden = 0
	ORDER BY
		SubcategoryTitle
    ;
END ;;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS SubcategoryGetDataAll; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SubcategoryGetDataAll`(
	IN $UserId INT
)
BEGIN
	SELECT
		*
	FROM
		vSubcategory
	WHERE 
		UserId = $UserId
		AND Hidden = 0
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS SubcategoryGetDataByCatId; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SubcategoryGetDataByCatId`(
	IN $UserId INT,
    IN $CategoryId INT
)
BEGIN
	SELECT
		*
	FROM
		vSubcategory
	WHERE 
		UserId = $UserId
        AND CategoryId = $CategoryId
		AND Hidden = 0
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS SubcategoryGetBudgetData;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SubcategoryGetBudgetData`(
	IN $UserId INT,
    IN $YearOf INT
)
BEGIN
	SELECT
		c.CategoryId,
		c.Title AS 'CategoryTitle',
		s.SubcategoryId,
		uc.UserId,
		s.Title AS 'SubcategoryTitle',
		s.Budget,
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = 1
			AND YEAR(DateOf) = $YearOf
		) AS 'January',
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = 2
			AND YEAR(DateOf) = $YearOf
		) AS 'February',
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = 3
			AND YEAR(DateOf) = $YearOf
		) AS 'March',
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = 4
			AND YEAR(DateOf) = $YearOf
		) AS 'April',
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = 5
			AND YEAR(DateOf) = $YearOf
		) AS 'May',
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = 6
			AND YEAR(DateOf) = $YearOf
		) AS 'June',
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = 7
			AND YEAR(DateOf) = $YearOf
		) AS 'July',
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = 8
			AND YEAR(DateOf) = $YearOf
		) AS 'August',
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = 9
			AND YEAR(DateOf) = $YearOf
		) AS 'September',
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = 10
			AND YEAR(DateOf) = $YearOf
		) AS 'October',
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = 11
			AND YEAR(DateOf) = $YearOf
		) AS 'November',
		(
			SELECT SUM(Amount)
			FROM `Transaction`
			WHERE SubcategoryId = s.SubcategoryId
			AND MONTH(DateOf) = 12
			AND YEAR(DateOf) = $YearOf
		) AS 'December',
		c.Hidden,
		s.Created,
		s.LastUpdated
	FROM 
		Subcategory s
		LEFT JOIN UserCategory uc ON s.CategoryId = uc.CategoryId
		LEFT JOIN Category c ON s.CategoryId = c.CategoryId
	WHERE 
		c.Hidden = 0
		AND c.Enabled = 1
		AND uc.UserId = $UserId
	ORDER BY
		c.Title ASC,
		s.Title ASC
	;
END;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS SubcategoryUpdate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SubcategoryUpdate`(
	IN $UserId INT,
    IN $CategoryId INT,
    IN $SubcategoryId INT,
    IN $Title VARCHAR(45),
	IN $InformationId INT,
    IN $Information VARCHAR(255)
)
BEGIN
	UPDATE Subcategory
    SET CategoryId = $CategoryId,
		Title = $Title
	WHERE SubcategoryId = $SubcategoryId;
        
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransactionCreate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransactionCreate`(
	IN $UserId INT,
    IN $DateOf DATE,
    IN $Amount DECIMAL(9,2),
    IN $AccountId INT,
    IN $Location VARCHAR(45),
    IN $Information VARCHAR(255),
    IN $SubcategoryId INT
)
BEGIN
	CASE
		WHEN ($Location IS NULL) THEN
			SET @LocationId = (SELECT SetLoc FROM UsrCfgNewAccount WHERE UserId = $UserId);
		WHEN ($Location IS NOT NULL AND (
			SELECT DISTINCT
			l.LocationId
			FROM Location l
			LEFT JOIN UserLocation ul ON l.LocationId = ul.LocationId
			WHERE l.Title = $Location
				AND ul.UserId = $UserId
			) IS NOT NULL) THEN
			SET @LocationId = (
				SELECT DISTINCT
					l.LocationId
				FROM Location l
				LEFT JOIN UserLocation ul ON l.LocationId = ul.LocationId
				WHERE l.Title = $Location
					AND ul.UserId = $UserId
			);
		WHEN ($Location IS NOT NULL AND (
			SELECT DISTINCT
			l.LocationId
			FROM Location l
			LEFT JOIN UserLocation ul ON l.LocationId = ul.LocationId
			WHERE l.Title = $Location
				AND ul.UserId = $UserId
			) IS NULL) THEN
            INSERT INTO Location (Title) VALUES ($Location);
			SET @LocationId = last_insert_id();
            INSERT INTO UserLocation (UserId, LocationId) VALUES ($UserId, @LocationId);
	END CASE;
    
    SET@CategoryId = (
		SELECT
			s.CategoryId
		FROM
			Subcategory s
			LEFT JOIN UserCategory uc ON uc.CategoryId = s.CategoryId
		WHERE
			uc.UserId = $UserId
			AND s.SubcategoryId = $SubcategoryId
	);
		
	IF ($Information IS NULL) THEN
		SET @Information = " ";
	ELSE
		SET @Information = $Information;
	END IF;
    
    INSERT INTO `Transaction` (
		DateOf,
        Amount,
        Information,
        AccountId,
        LocationId,
        CategoryId,
        SubcategoryId
        ) VALUES 
			($DateOf, $Amount, @Information, $AccountId, @LocationId, @CategoryId, $SubcategoryId);
    SET @TransactionId = LAST_INSERT_ID();
    
    INSERT INTO UserTransaction (
		UserId, 
        TransactionId
        ) VALUES 
			($UserId, @TransactionId);

END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransactionGetDataFilterV;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransactionGetDataFilterV`(
	IN $UserId INT, 
    IN $DateOf DATE,
	IN $DateMin DATE,
    IN $DateMax DATE,
    IN $DateMonth VARCHAR(10),
    IN $DateYear INT,
    IN $AccountId INT,
    IN $Location VARCHAR(45),
    IN $CategoryId INT,
    IN $SubcategoryId INT,
    IN $Information VARCHAR(255)
)
BEGIN
	SELECT
		*
	FROM
		vLedger
	WHERE UserId = $UserId
		AND DateOf LIKE IF ($DateOf IS NOT NULL, $DateOf, '%')
        AND (CASE WHEN $DateMin IS NOT NULL THEN DateOf >= $DateMin  ELSE DateOf LIKE '%' END)
        AND (CASE WHEN $DateMax IS NOT NULL THEN DateOf <= $DateMax ELSE DateOf LIKE '%' END)
		AND (CASE WHEN $DateMonth IS NOT NULL THEN MONTHNAME(DateOf) = $DateMonth ELSE DateOf LIKE '%' END)
		AND (CASE WHEN $DateYear IS NOT NULL THEN YEAR(DateOf) = $DateYear ELSE DateOf LIKE '%' END)
		AND AccountId LIKE IF($AccountId IS NOT NULL, $AccountId, '%')
        AND LocationTitle LIKE IF ($Location IS NOT NULL, $Location, '%')
        AND CategoryId LIKE IF ($CategoryId IS NOT NULL, $CategoryId, '%')
        AND SubcategoryId LIKE IF ($SubcategoryId IS NOT NULL, $SubcategoryId, '%')
        AND Information LIKE IF ($Information IS NOT NULL, CONCAT('%', $Information, '%'), '%')
		ORDER BY DateOf DESC
	;

END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransactionGetDataFilter;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransactionGetDataFilter`(
	IN $UserId INT, 
    IN $DateOf DATE,
	IN $DateMin DATE,
    IN $DateMax DATE,
    IN $DateMonth VARCHAR(10),
    IN $DateYear INT,
    IN $AccountId INT,
    IN $Location VARCHAR(45),
    IN $CategoryId INT,
    IN $SubcategoryId INT,
    IN $Information VARCHAR(255)
)
BEGIN
	SELECT
		ut.UserId,
		t.TransactionId,
        t.DateOf,
		t.Amount,
        t.AccountId,
		a.Title AS 'AccountTitle',
		t.LocationId,
		l.Title AS 'LocationTitle',
		t.Information,
		t.CategoryId,
		c.Title AS 'CategoryTitle',
        c.FlowId,
        f.Flow,
		t.SubcategoryId,
		s.Title AS 'SubcategoryTitle',
		SUM(t.Amount) 
				OVER (PARTITION BY t.AccountId ORDER BY t.DateOf, t.TransactionId DESC) AS 'Balance',
		IF(t.DateOf > curdate(), '1', '0') AS 'Future',
        t.Reconcile,
        t.HasReceipt,
        t.Hidden,
        t.Created,
        t.LastUpdated
	FROM 
		`Transaction` t
		LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
        LEFT JOIN `Account` a ON t.AccountId = a.AccountId
		LEFT JOIN Location l ON t.LocationId = l.LocationId
		LEFT JOIN Category c ON t.CategoryId = c.CategoryId
		LEFT JOIN Flow f ON c.FlowId = f.FlowId
		LEFT JOIN Subcategory s ON t.SubcategoryId = s.SubcategoryId
        LEFT JOIN Receipt r ON t.TransactionId = r.TransactionId
	WHERE
		ut.UserId = $UserId
        AND t.DateOf LIKE IF ($DateOf IS NOT NULL, $DateOf, '%')
        AND (CASE WHEN $DateMin IS NOT NULL THEN t.DateOf >= $DateMin  ELSE t.DateOf LIKE '%' END)
        AND (CASE WHEN $DateMax IS NOT NULL THEN t.DateOf <= $DateMax ELSE t.DateOf LIKE '%' END)
		AND (CASE WHEN $DateMonth IS NOT NULL THEN MONTHNAME(t.DateOf) = $DateMonth ELSE t.DateOf LIKE '%' END)
		AND (CASE WHEN $DateYear IS NOT NULL THEN YEAR(t.DateOf) = $DateYear ELSE t.DateOf LIKE '%' END)
		AND t.AccountId LIKE IF($AccountId IS NOT NULL, $AccountId, '%')
        AND l.Title LIKE IF ($Location IS NOT NULL, $Location, '%')
        AND t.CategoryId LIKE IF ($CategoryId IS NOT NULL, $CategoryId, '%')
        AND t.SubcategoryId LIKE IF ($SubcategoryId IS NOT NULL, $SubcategoryId, '%')
        -- AND t.Information LIKE IF ($Information IS NOT NULL, CONCAT('%', $Information, '%'), '%')
	ORDER BY
		t.DateOf DESC
        ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransactionDisable; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransactionDisable`(
	IN $UserId INT,
    IN $TransactionId INT
)
BEGIN
	UPDATE `Transaction` t
    LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
    SET t.Enabled = 1
    WHERE t.TransactionId = $TransactionId 
		AND ut.UserId = $UserId
	;
    
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransactionGetBalance;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransactionGetBalance`(
	IN $UserId INT
)
BEGIN
	SELECT 
		SUM(SUM(am.Amount) OVER (PARTITION BY t.AccountId ORDER BY t.DateOf, t.TransactionId DESC)) AS 'Balance'
	FROM 
		`Transaction` t
		LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
        LEFT JOIN `Account` a ON t.AccountId = a.AccountId
		LEFT JOIN Location l ON t.LocationId = l.LocationId
		LEFT JOIN Category c ON t.CategoryId = c.CategoryId
		LEFT JOIN Flow f ON c.FlowId = f.FlowId
		LEFT JOIN Subcategory s ON t.SubcategoryId = s.SubcategoryId
        LEFT JOIN Receipt r ON t.TransactionId = r.TransactionId
	WHERE ut.UserId = $UserId
        AND t.Enabled = 1
        AND a.IncludeInTotal = 1
		ORDER BY t.DateOf DESC
	;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransAccountUpdate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransAccountUpdate`(
	IN $UserId INT,
    IN $TransactionId INT,
    IN $UpdateValue VARCHAR(255)
)
BEGIN
	UPDATE `Transaction` t
    LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
    SET AccountId = $UpdateValue 
    WHERE
		ut.UserId = $UserId
		AND t.TransactionId = $TransactionId
	;

END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransAmountUpdate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransAmountUpdate`(
	IN $UserId INT,
    IN $TransactionId INT,
    IN $UpdateValue VARCHAR(255)
)
BEGIN
	UPDATE `Transaction` t
    LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
    SET t.Amount = $UpdateValue 
    WHERE
		ut.UserId = $UserId
		AND t.TransactionId = $TransactionId
	;

END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransCategoryUpdate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransCategoryUpdate`(
	IN $UserId INT,
    IN $TransactionId INT,
    IN $UpdateValue VARCHAR(255)
)
BEGIN
	UPDATE `Transaction` t
    LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
    SET t.CategoryId = $UpdateValue 
    WHERE
		ut.UserId = $UserId
		AND t.TransactionId = $TransactionId
	;
        
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransSubcategoryUpdate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransSubcategoryUpdate`(
	IN $UserId INT,
    IN $TransactionId INT,
    IN $UpdateValue VARCHAR(255)
)
BEGIN
	UPDATE `Transaction` t
    LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
    SET t.SubcategoryId = $UpdateValue 
    WHERE
		ut.UserId = $UserId
		AND t.TransactionId = $TransactionId
	;

END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransDateOfUpdate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransDateOfUpdate`(
	IN $UserId INT,
    IN $TransactionId INT,
    IN $UpdateValue VARCHAR(255)
)
BEGIN
	UPDATE `Transaction` t
    LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
    SET t.DateOf = $UpdateValue 
    WHERE
		ut.UserId = $UserId
		AND t.TransactionId = $TransactionId
	;
        
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransInformationUpdate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransInformationUpdate`(
	IN $UserId INT,
    IN $TransactionId INT,
    IN $UpdateValue VARCHAR(255)
)
BEGIN
	UPDATE `Transaction` t
    LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
    SET t.Information = $UpdateValue 
    WHERE
		ut.UserId = $UserId
		AND t.TransactionId = $TransactionId
	;
	
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransLocationUpdate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransLocationUpdate`(
	IN $UserId INT,
    IN $TransactionId INT,
    IN $UpdateValue VARCHAR(255)
)
BEGIN
	IF (
		SELECT DISTINCT
			l.LocationId
		FROM 
			Location l
			LEFT JOIN UserLocation ul ON l.Locationid = ul.LocationId
        WHERE 
			l.Title = $UpdateValue
			AND ul.UserId = $UserId) IS NOT NULL
		THEN 
			SET @LocationId = (
			SELECT DISTINCT
				l.LocationId
			FROM 
				Location l
				LEFT JOIN UserLocation ul ON l.LocationId = ul.LocationId
			WHERE 
				l.Title = $UpdateValue
				AND ul.UserId = $UserId
			);
	ELSE 
		INSERT INTO Location (Title) VALUES ($UpdateValue);
		SET @LocationId = last_insert_id();
        INSERT INTO UserLocation (UserId, LocationId) VALUES ($UserId, @LocationId);
	END IF;
    
    UPDATE `Transaction`
    SET LocationId = @LocationId
    WHERE Transactionid = $TransactionId
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS SubcategoryBudgetUpdate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SubcategoryBudgetUpdate`(
	IN $UserId INT,
    IN $SubcategoryId INT,
    IN $UpdateValue VARCHAR(255)
)
BEGIN
	UPDATE Subcategory s
    LEFT JOIN UserCategory uc ON s.CategoryId = uc.Categoryid
    SET s.Budget = $UpdateValue
    WHERE
		uc.UserId = $UserId
		AND s.SubcategoryId = $Subcategoryid
	;

END ;;
DELIMITER ;

-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransactionGetWorth; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransactionGetWorth`(
	IN $UserId INT
)
BEGIN
	SET @IncomeCatId = (
		SELECT c.CategoryId
        FROM Category c
        LEFT JOIN UserCategory uc ON c.CategoryId = uc.CategoryId
        WHERE c.Title LIKE "Income"
        AND uc.UserId = $UserId
	);
    
	SET @Asset = (
		SELECT SUM(t.Amount)
        FROM `Transaction` t
        LEFT JOIN `Account` a ON t.AccountId = a.AccountId
        WHERE a.AccountTypeId IN (1, 2)
        AND a.Tracking = 1
        AND a.IncludeInTotal = 1
	);
    
    SET @Liability = (
		SELECT SUM(t.Amount)
        FROM `Transaction` t
        LEFT JOIN `Account` a ON t.AccountId = a.AccountId
        WHERE a.AccountTypeId IN (3, 4, 5, 6, 7)
        AND a.Tracking = 1
	);
    
    SET @Balance = @Asset + @Liability;
    
    SELECT @Asset;
    SELECT @Liability;
    SELECT @Balance;

END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransactionReconcileSet; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransactionReconcileSet`(
	IN $UserId INT,
    IN $TransactionId INT
)
BEGIN
	UPDATE `Transaction` t
    LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
    SET t.Reconcile = 1
    WHERE t.TransactionId = $TransactionId
    AND ut.UserId = $UserId
    ;

END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransactionReconcileUnSet; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransactionReconcileUnSet`(
	IN $UserId INT,
    IN $TransactionId INT
)
BEGIN
	UPDATE `Transaction` t
    LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
    SET t.Reconcile = 0
    WHERE t.TransactionId = $TransactionId
    AND ut.UserId = $UserId
    ;

END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ConfigSetSidebarSelection; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ConfigSetSidebarSelection`(
	IN $UserId INT,
    IN $Selection VARCHAR(25)
)
BEGIN
	UPDATE UsrCfgNewAccount
    SET SidebarSelection = $Selection
    WHERE UserId = $UserId
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS UserConfigGetData; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UserConfigGetData`(
	IN $UserId INT
)
BEGIN
	SELECT
		*
	FROM
		UsrCfgNewAccount
	WHERE
		UserId = $UserId
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransactionGetDateRange; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransactionGetDateRange`(
	IN $UserId INT
)
BEGIN
	SELECT 
		MIN(t.DateOf) AS 'MinDate',
        MAX(t.DateOf) AS 'MaxDate'
	FROM
		`Transaction` t
        LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
	WHERE 
		t.LedgerEditable = 1
        AND ut.UserId = $UserId
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ReceiptGetList; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReceiptGetList`(
	IN $UserId INT
)
BEGIN
	SELECT 
		r.ReceiptId,
		r.TransactionId,
		l.Title AS 'LocationTitle',
		t.DateOf,
		ABS(t.Amount) AS 'Amount'
	FROM 
		Receipt r
		LEFT JOIN `Transaction` t ON r.TransactionId = t.TransactionId
		LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
		LEFT JOIN Location l ON t.LocationId = l.LocationId
	WHERE 
		ut.UserId = $UserId
	ORDER BY
		t.DateOf DESC
	;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ReceiptGetTransactionsWithoutReceipt; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReceiptGetTransactionsWithoutReceipt`(
	IN $UserId INT
)
BEGIN
	SELECT
		t.TransactionId,
		t.DateOf,
		l.Title AS 'LocationTitle',
		t.Amount
	FROM 
		`Transaction` t
		LEFT JOIN UserTransaction ut ON t.TransactionId = ut.TransactionId
		LEFT JOIN Location l ON t.LocationId = l.LocationId
	WHERE 
		ut.UserId = $UserId
		AND t.LedgerEditable = 1
		AND t.HasReceipt = 0
	ORDER BY
		t.DateOf DESC
	;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ReceiptInsertNewRow; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReceiptInsertNewRow`(
	IN $UserId INT,
    IN $TransactionId INT
)
BEGIN
	INSERT INTO Receipt 
		(TransactionId) 
        VALUES 
        ($TransactionId);
    SET @ReceiptId = last_insert_id();
    
    SELECT @ReceiptId;
    
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ReceiptGetDataById; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReceiptGetDataById`(
	IN $UserId INT,
    IN $ReceiptId INT
)
BEGIN
	SELECT
		r.ReceiptId,
        t.TransactionId,
        t.DateOf,
        l.Title AS 'LocationTitle',
        t.Tax,
        ABS(t.Amount) AS 'Amount',
        r.Information
	FROM Receipt r
    LEFT JOIN `Transaction` t ON r.TransactionId = t.TransactionId
    LEFT JOIN Location l ON t.LocationId = l.LocationId
	WHERE r.ReceiptId = $ReceiptId
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ReceiptItemGetDataById; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReceiptItemGetDataById`(
	IN $UserId INT,
    IN $ReceiptId INT
)
BEGIN
	SELECT
		r.ReceiptId,
		ri.ReceiptItemId,
		ri.ItemId,
		i.Title AS 'ItemTitle',
		ri.Quantity,
		ri.Amount,
		ri.Information
	FROM 
		ReceiptItem ri
		LEFT JOIN Receipt r ON ri.ReceiptId = r.ReceiptId
		LEFT JOIN Item i ON ri.ItemId = i.ItemId
	WHERE 
		r.ReceiptId = $ReceiptId
		AND ri.Enabled = 1
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ItemInsertNew; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ItemInsertNew`(
	IN $UserId INT,
    IN $ItemTitle VARCHAR(75),
    IN $Information VARCHAR(255)
)
BEGIN
	INSERT INTO Item
		(Title, Information)
        VALUES
        ($ItemTitle, $Information)
    ;
    SET @ItemId = last_insert_id();
    
    INSERT INTO UserItem
		(UserId, ItemId)
        VALUES
        ($UserId, @ItemId)
	;
    
    SELECT @ItemId;
END ;;
DELIMITER ;-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ReceiptItemAddBlank; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReceiptItemAddBlank`(
	IN $UserId INT,
    IN $ReceiptId INT
)
BEGIN
	INSERT INTO ReceiptItem
		(ReceiptId)
        VALUES
        ($ReceiptId);
	SET @ReceiptItemId = last_insert_id();
    
    SELECT @ReceiptItemid;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ReceiptItemInsertNew; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReceiptItemInsertNew`(
	IN $UserId INT,
    IN $ReceiptId INT,
    IN $ItemTitle VARCHAR(75),
    IN $Quantity INT,
    IN $Amount DECIMAL(9,2),
    IN $Information VARCHAR(255)
)
BEGIN
	IF (
		SELECT i.ItemId 
        FROM Item i
        LEFT JOIN UserItem ui ON i.ItemId = ui.ItemId
        WHERE i.Title = $ItemTitle
        AND ui.UserId = $UserId
        ) IS NULL
	THEN 
		INSERT INTO Item 
			(Title, Information)
			VALUES
			($ItemTitle, $Information);
		SET @ItemId = last_insert_id();
		INSERT INTO UserItem
			(UserId, ItemId)
			VALUES
			($UserId, @ItemId);
	ELSE
		SET @ItemId = (
			SELECT i.ItemId 
			FROM Item i
			LEFT JOIN UserItem ui ON i.ItemId = ui.ItemId
			WHERE i.Title = $ItemTitle
			AND ui.UserId = $UserId);
	END IF;
    
	INSERT INTO ReceiptItem 
        (ReceiptId, ItemId, Quantity, Amount, Information) 
        VALUES 
        ($ReceiptId, $ItemId, $Quantity, $Amount, $Information);
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ItemSearchByTitle; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ItemSearchByTitle`(
	IN $UserId INT,
    IN $Term VARCHAR(75)
)
BEGIN
	SELECT
		i.Title AS 'ItemTitle'
	FROM 
		Item i
        LEFT JOIN UserItem ui ON i.ItemId = ui.ItemId
	WHERE 
		i.Title LIKE CONCAT($Term, '%')
		AND ui.UserId = $UserId;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ItemGetList; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ItemGetList`(
	IN $UserId INT
)
BEGIN
	SELECT
		i.Title AS 'ItemTitle'
	FROM 
		Item i
        LEFT JOIN UserItem ui ON i.ItemId = ui.ItemId
	WHERE ui.UserId = $UserId;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ItemAddNewFromReceipt; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ItemAddNewFromReceipt`(
	IN $UserId INT,
    IN $ItemTitle VARCHAR(75)
)
BEGIN
	INSERT INTO Item (Title) VALUES
        ($ItemTitle)
	;
    SET @ItemId = last_insert_id();
    
    INSERT INTO UserItem (UserId, ItemId) VALUES 
		($UserId, @ItemId)
	;
    
    -- INSERT INTO UserItem
-- 		(UserId, ItemId)
--         VALUES
--         ($UserId, @ItemId)
-- 	;
--     
--     UPDATE ReceiptItem
--     SET ItemId = @ItemId
--     WHERE ReceiptItemId = $ReceiptItemId
--     AND ReceiptId = $ReceiptId;
    
    SELECT $ItemId;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ReceiptItemAddNewItemToReceipt; 
-- IN PROGRESS
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReceiptItemAddNewItemToReceipt`(
	IN $UserId INT,
    IN $ReceiptId INT,
    IN $ItemId INT
)
BEGIN
	-- INSERT INTO ReceiptItem (
  
    UPDATE ReceiptItem
    SET ItemId = @ItemId
    WHERE ReceiptItemId = $ReceiptItemId
    AND ReceiptId = $ReceiptId;
    
    SELECT $ItemId;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ReceiptItemUpdateItem; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReceiptItemUpdateItem`(
	IN $UserId INT,
    IN $ReceiptItemId INT,
    IN $UpdateValue VARCHAR(75)
)
BEGIN
	IF $ReceiptItemId IS NOT NULL THEN
		SET @ItemId = (
			SELECT i.ItemId
			FROM Item i
			LEFT JOIN UserItem ui ON i.ItemId = ui.ItemId
			WHERE i.Title = $UpdateValue
			AND ui.UserId = $UserId
		);
    ELSE
		INSERT INTO Item (Title) VALUES ($UpdateValue);
        SET @ItemId = last_insert_id();
        INSERT INTO UserItem (UserId, ItemId) VALUES ($UserId, @ItemId);
	END IF;

	UPDATE ReceiptItem
    SET ItemId = @ItemId
    WHERE ReceiptItemId = $ReceiptItemId
    ;
    
    SELECT *
    FROM ReceiptItem
    WHERE ReceiptItemId = $ReceiptItemId
    ;
    
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ReceiptItemUpdateQuantity; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReceiptItemUpdateQuantity`(
	IN $UserId INT,
    IN $ReceiptItemId INT,
    IN $UpdateValue VARCHAR(75)
)
BEGIN
	UPDATE ReceiptItem
    SET Quantity = $UpdateValue
    WHERE ReceiptItemId = $ReceiptItemId
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ReceiptItemUpdateAmount; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReceiptItemUpdateAmount`(
	IN $UserId INT,
    IN $ReceiptItemId INT,
    IN $UpdateValue VARCHAR(75)
)
BEGIN
	UPDATE ReceiptItem
    SET Amount = $UpdateValue
    WHERE ReceiptItemId = $ReceiptItemId
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS TransTaxUpdate; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransTaxUpdate`(
	IN $UserId INT,
    IN $TransactionId INT,
    IN $UpdateValue VARCHAR(75)
)
BEGIN
	UPDATE `Transaction`
    SET Tax = $UpdateValue
    WHERE Transactionid = $TransactionId
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ReceiptItemDisableById; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReceiptItemDisableById`(
	IN $UserId INT,
    IN $ReceiptItemId INT
)
BEGIN
	SET @ReceiptId = (
		SELECT ReceiptId
        FROM ReceiptItem
        WHERE ReceiptItemId = $ReceiptItemId
	);
    
    UPDATE ReceiptItem 
    SET Enabled = 1
    WHERE ReceiptItemId = $ReceiptItemId;
    
    SELECT @ReceiptId;
    
END ;;
DELIMITER ;
-- ************************************************************************************************
-- DROP PROCEDURE IF EXISTS ItemGetData; 
-- DELIMITER ;;
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `ItemGetData`(
-- 	IN $UserId INT
-- )
-- BEGIN
-- 	SET @ReceiptId = (
-- 		SELECT ReceiptId
--         FROM ReceiptItem
--         WHERE ReceiptItemId = $ReceiptItemId
-- 	);
--     
--     UPDATE ReceiptItem 
--     SET Enabled = 0 
--     WHERE ReceiptItemId = $ReceiptItemId;
--     
--     SELECT @ReceiptId;
--     
-- END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ItemAddNew; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ItemAddNew`(
	IN $UserId INT,
    IN $Title VARCHAR(75),
    IN $Information VARCHAR(255)
)
BEGIN
    INSERT INTO Item
		(Title, Information)
        VALUES
        ($Title, $Information)
	;
    SET @ItemId = last_insert_id();
    
    INSERT INTO UserItem
		(UserId, ItemId)
        VALUES
        ($UserId, @ItemId)
	;
    
    SELECT i.*
    FROM Item i
    LEFT JOIN UserItem ui ON i.ItemId = ui.ItemId
    WHERE ui.UserId = $UserId
    AND i.ItemId = @ItemId
    ;
    
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ItemGetData; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ItemGetData`(
	IN $UserId INT
)
BEGIN
    SELECT
		*
	FROM vItem
    WHERE UserId = $UserId
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS ItemGetDataAutoList; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ItemGetDataAutoList`(
	IN $UserId INT
)
BEGIN
    SELECT
		i.ItemId AS 'Id',
        i.Title
	FROM Item i
    LEFT JOIN UserItem ui ON i.ItemId = ui.ItemId
    WHERE ui.UserId = $UserId
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS UsrCfgSidebarViewGetViews; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UsrCfgSidebarViewGetViews`(
	IN $UserId INT
)
BEGIN
    SELECT * 
    FROM vUserConfigSidebarView 
    WHERE UserId = $UserId
    ;
END ;;
DELIMITER ;
-- ************************************************************************************************
-- DROP PROCEDURE IF EXISTS LocationAdd; 
-- DELIMITER ;;
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `LocationAdd`(
-- 	IN $UserId INT,
--     IN $Location VARCHAR(45),
--     IN $Information VARCHAR(45)
-- )
-- BEGIN
--     CASE
-- 		WHEN $Information IS NULL THEN SET @Information = '' END ;
--         
-- END ;;
-- DELIMITER ;

-- ************************************************************************************************
DROP PROCEDURE IF EXISTS CfgNavbarLinksGetData; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CfgNavbarLinksGetData`()
BEGIN
    SELECT *
    FROM vCfgNavbarLinks
    ;
END ;;
DELIMITER ;

-- ************************************************************************************************
DROP PROCEDURE IF EXISTS AdminGetTopics; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AdminGetTopics`()
BEGIN
    SELECT * FROM AdminTopics;
END ;;
DELIMITER ;

-- ************************************************************************************************
DROP PROCEDURE IF EXISTS NavbarSettingsGetTopics; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `NavbarSettingsGetTopics`()
BEGIN
    SELECT * FROM NavbarSettings;
END ;;
DELIMITER ;

-- ************************************************************************************************
DROP PROCEDURE IF EXISTS SidebarSettingsGetTopics; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SidebarSettingsGetTopics`()
BEGIN
    SELECT * FROM SidebarSettings;
END ;;
DELIMITER ;

-- ************************************************************************************************
DROP PROCEDURE IF EXISTS UsrCfgSidebarViewGetViews; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UsrCfgSidebarViewGetViews`(
	IN $UserId INT
)
BEGIN
    SELECT * 
    FROM vUserConfigSidebarView 
    WHERE UserId = $UserId
    ;
END ;;
DELIMITER ;

-- ************************************************************************************************
DROP PROCEDURE IF EXISTS CfgNavbarLinksGetData; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CfgNavbarLinksGetData`()
BEGIN
    SELECT *
    FROM vCfgNavbarLinks
    ;
END ;;
DELIMITER ;

/* TEMPLATE
-- ************************************************************************************************
DROP PROCEDURE IF EXISTS XXXXX; 
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `XXXXX`(
	IN $
)
BEGIN
    
END ;;
DELIMITER ;
*/
