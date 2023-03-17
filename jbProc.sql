USE JBOOKS001;

DROP PROCEDURE IF EXISTS SpLkAccountCategoryGet;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpLkAccountCategoryGet`()
BEGIN
    SELECT
		LkAccountCategoryId
        ,AccountCategory
	FROM
		LkAccountCategory
	;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpLkAccountTypeGet;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpLkAccountTypeGet`()
BEGIN
	SELECT
		LkAccountTypeId
		,LkAccountCategoryId
		,AccountType
	FROM
		LkAccountType
	;
    
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpUserProfileGet;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUserProfileGet`(
	IN _IdentityId CHAR(36)
)
BEGIN
    SELECT
		UserProfileId,
        IdentityId,
        ActiveId,
        Created,
        Updated
	FROM
		UserProfile
	WHERE
		IdentityId = _IdentityId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAccountGet;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAccountGet`(
	IN _LookupId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		a.AccountId
        ,a.AccountId
		,a.AccountTitle
		,a.LkAccountTypeId
        ,a.Created
        ,a.Updated
	FROM
		Account a
	JOIN
		IdentityAccount ia
        ON a.AccountId = ia.AccountId
	WHERE
		ia.IdentityId = _LookupId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAccountAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAccountAdd`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _AccountTitle VARCHAR(50),
    IN _LkAccountTypeId INT
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
		INSERT INTO
			Account
				(AccountTitle, LkAccountTypeId)
			VALUES
				(_AccountTitle, _LkAccountTypeId);
		SET @accountId = last_insert_id();
        
        INSERT INTO
			IdentityAccount
				(IdentityId, AccountId)
			VALUES
				(_ActiveId, @AccountId);
    COMMIT;
    
    SELECT
		a.AccountId
        ,a.AccountId
		,a.AccountTitle
		,a.LkAccountTypeId
        ,a.Created
        ,a.Updated
	FROM
		Account a
	JOIN
		IdentityAccount ia
        ON a.AccountId = ia.AccountId
	WHERE
		ia.IdentityId = _ActiveId;
        
END ;;
DELIMITER ;

-- Add account starting balance
DROP PROCEDURE IF EXISTS SpAccountAddBalance;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAccountAddBalance`(
	IN _AccountId INT,
    IN _Amount DECIMAL(13,2)
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
		INSERT INTO
			Amount
            (Value)
            VALUES
            (_Amount);
		SET @amountId = last_insert_id();
        
        INSERT INTO
			Transaction
            (
    COMMIT;
    
END ;;
DELIMITER ;

/*
DROP PROCEDURE IF EXISTS xxx;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `xxx`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    COMMIT;
    
END ;;
DELIMITER ;
*/
/*
DROP PROCEDURE IF EXISTS xxx;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `xxx`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    
END ;;
DELIMITER ;
*/