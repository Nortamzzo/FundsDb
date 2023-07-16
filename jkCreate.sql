-- DROP DATABASE IF EXISTS JKITCHEN001;
-- CREATE DATABASE JKITCHEN001;
USE JKITCHEN001;

SET FOREIGN_KEY_CHECKS = 0;

-- Associate AspNetUsers to Identity table
/*
DROP TABLE IF EXISTS Identity;
CREATE TABLE Identity (
	IdentityId CHAR(36) NOT NULL UNIQUE,
    Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (IdentityId)
);
*/

DROP TABLE IF EXISTS Recipe;
CREATE TABLE Recipe (
	RecipeId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(75),
    Description VARCHAR(255),
    PRIMARY KEY (RecipeId)
);

DROP TABLE IF EXISTS Item;
CREATE TABLE Item (
	ItemId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(50),
    Description VARCHAR(255),
    PRIMARY KEY (ItemId)
);

DROP TABLE IF EXISTS Unit;
CREATE TABLE Unit (
	UnitId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(15),
    BaseUnits DECIMAL(10,5),
    PRIMARY KEY (UnitId)
);

DROP TABLE IF EXISTS Measurement;
CREATE TABLE Measurement (
	MeasurementId INT NOT NULL AUTO_INCREMENT,
    UnitId INT,
    Quantity DECIMAL(10,5),
    PRIMARY KEY (MeasurementId),
    FOREIGN KEY (UnitId) REFERENCES Unit (UnitId)
);

DROP TABLE IF EXISTS Ingredient;
CREATE TABLE Ingredient (
	IngredientId INT NOT NULL AUTO_INCREMENT,
    ItemId INT,
    Name VARCHAR(50),
    PRIMARY KEY (IngredientId),
    FOREIGN KEY (ItemId) REFERENCES Item (ItemId)
);

DROP TABLE IF EXISTS RecipeIngredient;
CREATE TABLE RecipeIngredient (
	RecipeIngredientId INT NOT NULL AUTO_INCREMENT,
    RecipeId INT,
    IngredientId INT,
    UnitId INT,
    Quantity DECIMAL(10,5),
    Note VARCHAR(50),
    PRIMARY KEY (RecipeIngredientId),
    FOREIGN KEY (RecipeId) REFERENCES Recipe (RecipeId),
    FOREIGN KEY (IngredientId) REFERENCES Ingredient (IngredientId),
    FOREIGN KEY (UnitId) REFERENCES Unit (UnitId)
);

DROP TABLE IF EXISTS Direction;
CREATE TABLE Direction (
	DirectionId INT NOT NULL AUTO_INCREMENT,
    Description TEXT,
    PRIMARY KEY (DirectionId)
);

DROP TABLE IF EXISTS RecipeDirection;
CREATE TABLE RecipeDirection (
	RecipeDirectionId INT NOT NULL AUTO_INCREMENT,
    RecipeId INT,
    DirectionId INT,
    Sequence INT NOT NULL DEFAULT 1,
    PRIMARY KEY (RecipeDirectionId),
    FOREIGN KEY (RecipeId) REFERENCES Recipe (RecipeId),
    FOREIGN KEY (DirectionId) REFERENCES Direction (DirectionId)
);

DROP TABLE IF EXISTS Nutrition;
CREATE TABLE Nutrition (
	NutritionId INT NOT NULL AUTO_INCREMENT,
    ItemId INT,
    UnitId INT,
    Calories DECIMAL(7,2),
    Fat DECIMAL(4,2),
    PRIMARY KEY (NutritionId),
    FOREIGN KEY (ItemId) REFERENCES Item (ItemId)
);

DROP TABLE IF EXISTS Category;
CREATE TABLE Category (
	CategoryId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(50),
    Desciprtion VARCHAR(255),
    PRIMARY KEY (CategoryId)
);

DROP TABLE IF EXISTS LkRecipeCategory;
CREATE TABLE LkRecipeCategory (
	LkRecipeCategoryId INT NOT NULL AUTO_INCREMENT,
    RecipeId INT,
    CategoryId INT,
    PRIMARY KEY (LkRecipeCategoryId),
    FOREIGN KEY (RecipeId) REFERENCES Recipe (RecipeId),
    FOREIGN KEY (CategoryId) REFERENCES Category (CategoryId)
);

/*
DROP TABLE IF EXISTS xxx;
CREATE TABLE xxx (
);
*/