USE STARCASH0003;

DROP PROCEDURE IF EXISTS SpRegisterNewUser;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpRegisterNewUser`(
	IN _Id CHAR(36)
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    -- Add Identity
    INSERT INTO
		Identity
        (
			IdentityId
		)
        VALUES
        (
			_Id
		);
    -- Add UserProfile
    INSERT INTO
		UserProfile
        (
			IdentityId,
            ActiveId
		)
	VALUES
		(
			_Id,
            _Id
		);
	SET @UserProfileId = last_insert_id();
    
    COMMIT;
    -- Return VwUserProfile
	SELECT
		UserProfileId,
		IdentityId,
		UserName,
		Email,
		ActiveId,
		PersonId,
		FirstName,
		LastName,
		Created,
		Updated
	FROM
		VwUserProfile
	WHERE
		UserProfileId = @UserProfileId;
    
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpUserProfileAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUserProfileAdd`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _PersonId INT
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    INSERT INTO
		UserProfile
        (
			IdentityId,
            ActiveId,
            PersonId
		)
	VALUES
		(
			_IdentityId,
            _ActiveId,
            _PersonId
		);
	SET @UserProfileId = last_insert_id();
    
    COMMIT;
    
    SELECT
		UserProfileId,
        IdentityId,
        ActiveId,
        PersonId,
        Created,
        Updated
	FROM
		UserProfile
	WHERE
		UserProfileId = @UserProfileId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpUserProfileGetByIdentityId;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUserProfileGetByIdentityId`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		UserProfileId,
        IdentityId,
        ActiveId,
        PersonId,
        Created,
        Updated
	FROM
		UserProfile
	WHERE
		IdentityId = _ActiveId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAccountGetAll;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAccountGetAll`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		AccountId,
		IdentityId,
		AccountName,
		AccountDescription,
		ReconileAmount,
		ReconcileDate,
		LkAccountTypeId,
		IsTracked,
		IsEnabled,
		IsDeleted,
		Created,
		Updated
	FROM
		Account
	WHERE
		IdentityId = _ActiveId;    
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAccountGetById;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAccountGetById`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		AccountId,
		IdentityId,
		AccountName,
		AccountDescription,
		ReconileAmount,
		ReconcileDate,
		LkAccountTypeId,
		IsTracked,
		IsEnabled,
		IsDeleted,
		Created,
		Updated
	FROM
		Account
	WHERE
		AccountId = _AccountId;    
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAccountGetView;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAccountGetView`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN  
    SELECT
		AccountId,
		IdentityId,
		AccountName,
		AccountDescription,
		ReconileAmount,
		ReconcileDate,
		LkAccountTypeId,
		IsTracked,
		IsEnabled,
		IsDeleted,
		Created,
		Updated,
        AccountLimitId,
        AccountLimitAmount,
        InterestRateId,
        InterestRateAmount,
        Balance,
        Future,
        ThisMonth
	FROM
		VwAccount
	WHERE
		IdentityId = _ActiveId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAccountAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAccountAdd`(
    IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _AccountName VARCHAR(50),
    IN _AccountDescription VARCHAR(255),
    IN _ReconileAmount DECIMAL(13,2),
    IN _ReconcileDate DATETIME,
    IN _InterestRate DECIMAL(6,4),
    IN _LimitAmount DECIMAL(13,2),
    IN _LkAccountTypeId INT,
    IN _IsTracked BOOL,
    IN _IsEnabled BOOL,
    IN _IsDeleted BOOL
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
		(
			IdentityId,
			AccountName,
			AccountDescription,
			ReconileAmount,
			ReconcileDate,
            InterestRate,
			LimitAmount,
			LkAccountTypeId,
			IsTracked,
			IsEnabled,
			IsDeleted
		)
	VALUES
        (
			_ActiveId,
            _AccountName,
            _AccountDescription,
            _ReconileAmount,
            _ReconcileDate,
            _InterestRate,
			_LimitAmount,
            _LkAccountTypeId,
            CASE
				WHEN _IsTracked IS NOT NULL THEN _IsTracked
                WHEN _IsEnabled IS NOT NULL THEN _IsEnabled
                WHEN _IsDeleted IS NOT NULL THEN _IsDeleted
			END
        );
    SET @AccountId = last_insert_id();
    
    CASE
		WHEN (_LkAccountTypeId = 1) 
			THEN 
				SET @CategoryId = 1;
                SET @SubcategoryId = 1;
		WHEN (_LkAccountTypeId = 2) 
			THEN 
				SET @CategoryId = 1;
                SET @SubcategoryId = 2;
		WHEN (_LkAccountTypeId = 3) 
			THEN 
				SET @CategoryId = 2;
                SET @SubcategoryId = 3;
		WHEN (_LkAccountTypeId = 4) 
			THEN 
				SET @CategoryId = 2;
                SET @SubcategoryId = 4;
		WHEN (_LkAccountTypeId = 5) 
			THEN 
				SET @CategoryId = 2;
                SET @SubcategoryId = 5;
	END CASE;
    
    INSERT INTO Transaction
		(
			IdentityId,
			TransactionDate,
			TransactionAmount,
			AccountId,
			LocationId,
			CategoryId,
			SubcategoryId,
			IsEnabled,
			IsDeleted
		)
		VALUES
		(
			_ActiveId,
			_ReconcileDate,
            _ReconcileAmount,
            @AccountId,
            1, -- System Location Id
            @CategoryId, -- System new account category
            @SubcategoryId -- System new account subcategory
		);
    
    COMMIT;
    SELECT
		AccountId,
		IdentityId,
		AccountName,
		AccountDescription,
		ReconileAmount,
		ReconcileDate,
        InterestRate,
		LimitAmount,
		LkAccountTypeId,
		IsTracked,
		IsEnabled,
		IsDeleted,
		Created,
		Updated
	FROM
		Account
	WHERE
		AccountId = @AccountId;
        
	-- TODO: Log
		
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAccountUpdate;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAccountUpdate`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _AccountName VARCHAR(50),
    IN _AccountDescription VARCHAR(255),
    IN _ReconileAmount DECIMAL(13,2),
    IN _ReconcileDate DATETIME,
    IN _InterestRate DECIMAL(6,4),
    IN _LimitAmount DECIMAL(13,2),
    IN _LkAccountTypeId INT,
    IN _IsTracked BOOL,
    IN _IsEnabled BOOL,
    IN _IsDeleted BOOL
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
            
    UPDATE
		Account
	SET
		AccountName = IFNULL(_AccountName, AccountName),
		AccountDescription = IFNULL(_AccountDescription, AccountDescription),
		ReconcileDate = IFNULL(_ReconcileDate, ReconcileDate),
		ReconcileAmount = IFNULL(_ReconcileAmount, ReconcileAmount),
        InterestRate = IFNULL (_InterestRate, InterestRate),
        LimitAmount = IFNULL (_LimitAmount, LimitAmount),
		LkAccountTypeId = IFNULL(_LkAccountTypeId, LkAccountTypeId),
		IsTracked = IFNULL(_IsTracked, IsTracked),
		IsEnabled = IFNULL(_IsEnabled, IsEnabled),
        IsDeleted = IFNULL(_IsDeleted, IsDeleted)
	WHERE
		AccountId = _AccountId;
        
    COMMIT;
    SELECT
		AccountId,
		IdentityId,
		AccountName,
		AccountDescription,
		ReconileAmount,
		ReconcileDate,
        InterestRate,
		LimitAmount,
		LkAccountTypeId,
		IsTracked,
		IsEnabled,
		IsDeleted,
		Created,
		Updated
	FROM
		Account
	WHERE
		AccountId = @AccountId;
        
	-- TODO: Log
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAddressAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAddressAdd`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
	IN _LineOne VARCHAR(50),
	IN _LineTwo VARCHAR(50),
	IN _LkZipCodeId INT,
	IN _LkCityId INT,
	IN _LkStateId INT,
	IN _IsEnabled BOOL,
	IN _IsDeleted BOOL
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    INSERT INTO
		Address
        (
			IdentityId,
			LineOne,
			LineTwo,
			LkZipCodeId,
			LkCityId,
			LkStateId,
			IsEnabled,
			IsDeleted
        )
	VALUES
		(
			_ActiveId,
			_LineOne,
			_LineTwo,
			_LkZipCodeId,
			_LkCityId,
			_LkStateId,
			_IsEnabled,
			_IsDeleted
        );
	SET @AddressId = last_insert_id();
    
    COMMIT;

    SELECT
		AddressId,
		IdentityId,
		LineOne,
		LineTwo,
		LkZipCodeId,
		LkCityId,
		LkStateId,
		IsEnabled,
		IsDeleted,
		Created,
		Updated
	FROM
		Address
	WHERE
		AddressId = @AddressId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAddressUpdate;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAddressUpdate`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _AddressId INT,
	IN _LineOne VARCHAR(50),
	IN _LineTwo VARCHAR(50),
	IN _LkZipCodeId INT,
	IN _LkCityId INT,
	IN _LkStateId INT,
	IN _IsEnabled BOOL,
	IN _IsDeleted BOOL
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    UPDATE
		Address
	SET
		LineOne = IFNULL (_LineOne, LineOne),
		LineTwo = IFNULL (_LineTwo, LineTwo),
		LkZipCodeId = IFNULL (_LkZipCodeId, LkZipCodeId),
		LkCityId = IFNULL (_LkCityId, LkCityId),
		LkStateId = IFNULL (_LkStateId, LkStateId),
		IsEnabled = IFNULL (_IsEnabled, IsEnabled),
		IsDeleted = IFNULL (_IsDeleted, IsDeleted)
	WHERE
		AddressId = _AddressId;
    
    COMMIT;

    SELECT
		AddressId,
		IdentityId,
		LineOne,
		LineTwo,
		LkZipCodeId,
		LkCityId,
		LkStateId,
		IsEnabled,
		IsDeleted,
		Created,
		Updated
	FROM
		Address
	WHERE
		AddressId = @AddressId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAssociationAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAssociationAdd`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _AssociationName VARCHAR(50),
    IN _AssociationDescription  VARCHAR(25)
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    SET @AsscIdentityId = UUID();
    
    INSERT INTO
		Identity
        (
			IdentityId
		)
        VALUES
        (
			@AsscIdentityId
		);
	
    INSERT INTO
		Association
        (
			IdentityId,
            Title,
            DisplayName,
            Description
		)
        VALUES
        (
			@AsscIdentityId,
            _Title,
            _DisplayName,
            _Description
		);
	SET @AssociationId = last_insert_id();
    
    INSERT INTO
		AssociationMember
        (
			AssociationId,
            IdentityId,
            CanRead,
            CanUpdate,
            CanCreate,
            CanDelete,
            CanInvite,
            CanRemove
		)
        VALUES
        (
			@AssociationId,
            _IdentityId,
            1,
            1,
            1,
            1,
            1,
            1
		);
    
    COMMIT;
    SELECT
		AssociationId, 
        IdentityId,
        Title,
        DisplayName,
        Description,
        Created,
        Updated
	FROM
		Association
	WHERE
		AssociationId = @AssociationId;
    
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAssociationInviteAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAssociationInviteAdd`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _ReceiverEmail VARCHAR(100),
    IN _Message VARCHAR(255)
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    SET @ReceiverIdentityId = 
		(
			SELECT
				IdentityId
			FROM
				UserProfile
			WHERE
				Email = _ReceiverEmail			
        );
    
    SET @AssociationId = 
		(
			SELECT
				AssociationId
			FROM
				Association
			WHERE
				IdentityId = _ActiveId
        );
    
    INSERT INTO
		AssociationInvite
        (
			AssociationId,
            SenderIdentityId,
            ReceiverIdentityId,
            Message
		)
        VALUES
        (
			@AssociationId,
			_IdentityId,
            @ReceiverIdentityId,
            _Message
        );
        SET @AssociationInviteId = last_insert_id();
    
    COMMIT;
    SELECT
		AssociationInviteId,
        AssociationId,
		SenderIdentityId,
		ReceiverIdentityId,
		Message,
		Accepted,
		Created,
		Updated
	FROM
		AssociationInvite
	WHERE
		AssociationInviteId = @AssociationInviteId;
    
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAssociationMemberAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAssociationMemberAdd`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _AssociationId INT,
    IN _AssociationInviteId INT
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    SET @AssociationIdentityId =
		(
			SELECT
				IdentityId
			FROM
				Association
			WHERE
				IdentityId = _ActiveId
        );
        
	SET @AssociationId =
		(
			SELECT
				AssociationId
			FROM
				Association
			WHERE
				IdentityId = _ActiveId
        );
    
    CASE
		WHEN (@AssociationIdentityId = _ActiveId and @AssociationId = _AssociationId)
			THEN
				INSERT INTO
					AssociationMember
					(
						AssociationId,
                        IdentityId
					)
					VALUES
					(
						_AssociationId,
                        _IdentityId
					);
				SET @AssociationMemberId = last_insert_id();
                
				UPDATE
					AssociationInvite
				SET
					Accepted = true
				WHERE
					AssociationInviteId = _AssociationInviteId;
	END CASE;    	
    
    COMMIT;
    SELECT
		AssociationMemberId,
		AssociationId,
		IdentityId,
		CanRead,
		CanUpdate,
		CanCreate,
		CanDelete,
		CanInvite,
		CanRemove,
		Created,
		Updated
	FROM
		AssociationMember
	WHERE
		AssociationMemberId = @AssociationMemberId;
		
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpCategoryGetView;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpCategoryGetView`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		CategoryId,
		IdentityId,
		CategoryName,
		CategoryDescription,
		LkFlowId,
		FlowName,
		FlowRate,
		IsEnabled,
        IsDeleted,
		Created,
		Updated,
        ThisMonth
	FROM
		VwCategory
	WHERE
		IdentityId = _ActiveId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpCategoryAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpCategoryAdd`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _CategoryName VARCHAR(50),
    IN _CategoryDescription VARCHAR(255),
    IN _LkFlowId INT,
    IN _IsEnabled BOOL,
    IN _IsDeleted BOOL
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    INSERT INTO 
		Category
		(
			IdentityId, 
            CategoryName,
            CategoryDescription, 
            LkFlowId
		)
	VALUES
        (
			_ActiveId,
			_CategoryName,
            _CategoryDescription,
            _LkFlowId
        );
    SET @CategoryId = last_insert_id();
    
    COMMIT;
    SELECT
		CategoryId,
        IdentityId,
        CategoryName,
        CategoryDescription,
        LkFlowId,
        IsEnabled,
        IsDeleted,
        Created,
        Updated
	FROM
		Category
	WHERE
		CategoryId = @CategoryId;
        
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpCategoryUpdate;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpCategoryUpdate`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _CategoryId INT,
    IN _CategoryName VARCHAR(50),
    IN _CategoryDescription VARCHAR(255),
    IN _LkFlowId INT,
    IN _IsEnabled BOOL,
    IN _IsDeleted BOOL
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    UPDATE
		Category
	SET
		CategoryName = IFNULL(_CategoryName, CategoryName),
        CategoryDescription = IFNULL(_CategoryDescription, CategoryDescription),
        LkFlowId = IFNULL(_LkFlowId, LkFlowId),
        IsEnabled = IFNULL(_IsEnabled, IsEnabled),
        IsDeleted = IFNULL(_IsDeleted, IsDeleted)
	WHERE
		IdentityId = _ActiveId
        AND
			CategoryId = _CategoryId;
    
    COMMIT;
    SELECT
		CategoryId,
        IdentityId,
        CategoryName,
        CategoryDescription,
        LkFlowId,
        IsEnabled,
        IsDeleted,
        Created,
        Updated
	FROM
		Category
	WHERE
		CategoryId = _CategoryId;
        
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpLocationGet;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpLocationGet`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		LocationId,
        IdentityId,
        LocationName,
        LocationDescription,
        IsEnabled,
        IsDeleted,
        Created,
        Updated
	FROM
		Location
	WHERE
		IdentityId = _ActiveId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpLocationGetById;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpLocationGetById`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _LocationId INT
    )
BEGIN
    SELECT
		LocationId,
        IdentityId,
        LocationName,
        LocationDescription,
        IsEnabled,
        IsDeleted,
        Created,
        Updated
	FROM
		Location
	WHERE
		LocationId = _LocationId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpLocationAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpLocationAdd`(
/*
Summary
	Insert new location into EntityLocation
    Insert new LkEntityLocation
    Returns new EntityLocation
History
	11/19/22:	Create
*/
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _LocationName VARCHAR(50),
    IN _LocationDescription VARCHAR(255)
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    INSERT INTO 
		Location
		(
			IdentityId, 
            LocationName,
            LocationDescription
		)
	VALUES
        (
			_ActiveId,
            _LocationName,
            _LocationDescription
		);
	SET @LocationId = last_insert_id();
        
    COMMIT;
    SELECT
		LocationId,
        IdentityId,
        LocationName,
        LocationDescription,
        IsEnabled,
        IsDeleted,
        Created,
        Updated
	FROM
		Location
	WHERE
		LocationId = @LocationId;
    
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpLocationUpdate;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpLocationUpdate`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _LocationId INT,
    IN _LocationName VARCHAR(50),
    IN _LocationDescription VARCHAR(255),
    IN _IsEnabled BOOL,
    IN _IsDeleted BOOL
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
		
        UPDATE
			Location
		SET
			LocationName = IFNULL(_LocationName, LocationName),
            LocationDescription = IFNULL(_LocationDescription, LocationDescription),
            IsEnabled = IFNULL(_IsEnabled, IsEnabled),
            IsDeleted = IFNULL(_IsDeleted, IsDeleted)
		WHERE
			LocationId = _LocationId
            AND
				IdentityId = _ActiveId
		;
        
    COMMIT;
    SELECT
		LocationId,
        IdentityId,
        LocationName,
        LocationDescription,
        IsEnabled,
        IsDeleted,
        Updated,
        Created
	FROM
		Location
	WHERE
		IdentityId = _ActiveId;
        
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpSubcategoryGetView;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpSubcategoryGetView`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		SubcategoryId,
        IdentityId,
		CategoryId,
        CategoryName,
        SubcategoryName,
        SubcategoryDescription,
        LkFlowId,
        FlowName,
        FlowRate,
        IsEnabled,
        IsDeleted,
        Created,
        Updated
	FROM
		VwSubcategory
	WHERE
		IdentityId = _ActiveId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpSubcategoryAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpSubcategoryAdd`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _CategoryId INT,
    IN _Title VARCHAR(50),
    IN _SubcategoryName VARCHAR(25),
    IN _SubcategoryDescription VARCHAR(255),
    IN _LkFlowId INT,
    IN _IsEnabled BOOL,
    IN _IsDeleted BOOL
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
	SET @FlowId = 
		(
			SELECT
				LkFlowId
			FROM
				Category
			WHERE
				CategoryId = _CategoryId
		);
    
    INSERT INTO 
		Subcategory
		(
			IdentityId, 
            CategoryId,
            SubcategoryName, 
            SubcategoryDescription,
            LkFlowId
		)
	VALUES
        (
			_ActiveId,
            _CategoryId,
            _SubcategoryName,
            _SubcategoryDescription,
            IFNULL(_LkFlowId, @FlowId)
        );
    SET @SubcategoryId = last_insert_id();
		
    COMMIT;
    SELECT
		SubcategoryId,
        IdentityId,
        CategoryId,
        SubcategoryName,
        SubcategoryDescription,
        LkFlowId,
        IsEnabled,
        IsDeleted,
        Created,
        Updated
	FROM
		Subcategory
	WHERE
		SubcategoryId = @SubcategoryId;
        
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpSubcategoryUpdate;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpSubcategoryUpdate`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _SubcategoryId INT,
    IN _CategoryId INT,
    IN _SubcategoryName VARCHAR(50),
    IN _SubcategoryDescription VARCHAR(255),
    IN _LkFlowId INT,
    IN _IsEnabled BOOL,
    IN _IsDeleted BOOL
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
		UPDATE
			Subcategory
		SET
			SubcategoryName = IFNULL(_SubcategoryName, SubcategoryName),
            CategoryId = IFNULL(_CategoryId, CategoryId),
			DisplayName = IFNULL(_DisplayName, DisplayName),
			SubcategoryDescription = IFNULL(_SubcategoryDescription, SubcategoryDescription),
            LkFlowId = IFNULL(_LkFlowId, LkFlowId),
            IsEnabled = IFNULL(_IsEnabled, IsEnabled),
            IsDeleted = IFNULL(_IsDeleted, IsDeleted)
		WHERE
			SubcategoryId = _SubcategoryId
            AND
				IdentityId = _ActiveId
		;
    COMMIT;
    
    SELECT
		SubcategoryId,
        IdentityId,
        CategoryId,
        SubcategoryName,
        SubcategoryDescription,
        LkFlowId,
        IsEnabled,
        IsDeleted,
        Created,
        Updated
	FROM
		Subcategory
	WHERE
		SubcategoryId = _SubcategoryId;
    
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpTransactionGetView;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpTransactionGetView`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		TransactionId,
        IdentityId,
        TransactionDate,
		TransactionAmount,
        AccountId,
        AccountName,
        LkAccountTypeId,
        AccountTypeName,
        LocationId,
        LocationName,
        CategoryId,
		CategoryName,
        SubcategoryId,
        SubcategoryName,
		LkFlowId,
        FlowName,
        FlowRate,
        TransactionDescription,
        IsEnabled,
        IsDeleted,
        Created,
        Updated,
        Balance,
        Future
	FROM
		VwTransaction
	WHERE
		IdentityId = _ActiveId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpTransactionAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpTransactionAdd`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _TransactionDate DATE,
    IN _TransactionAmount DECIMAL(13,2),
    IN _AccountId INT,
    IN _LocationId INT,
    IN _CategoryId INT,
    IN _SubcategoryId INT,
    IN _TransactionDescription VARCHAR(255)
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
        
    INSERT INTO Transaction
		(
			IdentityId, 
            TransactionDate, 
            TransactionAmount, 
            AccountId, 
            LocationId, 
            CategoryId, 
            SubcategoryId, 
            TransactionDescription
		)
        VALUES
		(
			_ActiveId,
            _TransactionDate,
            @AmountId,
            _AccountId,
            _LocationId,
            _CategoryId,
            _SubcategoryId,
            _TransactionDescription
        );
    SET @TransactionId = last_insert_id();
    
    SET @ReconcileDate = 
		(
			SELECT
				ReconcileDate
			FROM
				Account
			WHERE
				AccountId = _AccountId
		);
    
    IF (_TransactionDate < @ReconcileDat) 
		THEN
			SET @ReconcileAmountOriginal = 
				(
					SELECT
						ReconileAmount
					FROM
						Account
					WHERE
						a.AccountId = _AccountId
				);
			SET @FlowRate =
				(
					SELECT
						l.Rate
					FROM
						LkFlow l
					JOIN
						Subcategory s
						ON l.LkFlowId = s.LkFlowId
					WHERE
						s.SubcategoryId = _SubcategoryId
				);
			SET @NewReconcileAmount = (@ReconcileAmountOriginal - (_TransactionAmount * @FlowRate));
			UPDATE 
				Account
			SET
				ReconcileAmount = @NewReconcileAmount
				
			WHERE
				Account = _AccountId;
	END IF;
    
    COMMIT;
    SELECT
		TransactionId,
        IdentityId,
        TransactionDate,
        TransactionAmount,
        AccountId,
        LocationId,
        CategoryId,
        SubcategoryId,
        TransactionDescription,
        IsEnabled,
        IsDeleted,
        Created,
        Updated
	FROM
		Transaction
	WHERE
		TransactionId = @TransactionId;
    
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpTransactionUpdate;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpTransactionUpdate`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _TransactionId INT,
    IN _TransactionDate DATE,
    IN _TransactionAmount DECIMAL(13,2),
    IN _AccountId INT,
    IN _LocationId INT,
    IN _CategoryId INT,
    IN _SubcategoryId INT,
    IN _Description VARCHAR(255),
    IN _IsEnabled BOOL,
    IN _IsDeleted BOOL
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    UPDATE
		Transaction
	SET
		TransactionDate = IFNULL(_TransactionDate, TransactionDate),
        TransactionAmount = IFNULL(_TransactionAmount, TransactionAmount),
        AccountId = IFNULL(_AccountId, AccountId),
        LocationId = IFNULL(_LocationId, LocationId),
        CategoryId = IFNULL(_CategoryId, CategoryId),
        SubcategoryId = IFNULL(_SubcategoryId, SubcategoryId),
        TransactionDescription = IFNULL(_TransactionDescription, TransactionDescription),
        IsEnabled = IFNULL(_IsEnabled, IsEnabled),
        IsDeleted = (_IsDeleted, IsDeleted)
	WHERE
		TransactionId = _TransactionId
        AND
			IdentityId = _ActiveId;
            
    COMMIT;
    SELECT
		TransactionId,
        IdentityId,
        TransactionDate,
        TransactionAmount,
        AccountId,
        LocationId,
        CategoryId,
        SubcategoryId,
        TransactionDescription,
        IsEnabled,
        IsDeleted,
        Created,
        Updated
	FROM
		Transaction
	WHERE
		TransactionId = _TransactionId;
END ;;
DELIMITER ;

/* TESTING */
DROP PROCEDURE IF EXISTS SpTestError;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpTestError`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _TestVariable VARCHAR(25)
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    INSERT INTO
		TestTable
		(
			TestString
        )
	VALUES
		(
			_TestVariable
        );
	SET @Id = last_insert_id();
    
    COMMIT;
    SELECT
		*
	FROM
		TestTable
	WHERE
		TestId = @Id;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpLkZipCodeGet;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpLkZipCodeGet`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		LkZipCodeId
        ,ZipCode
        ,LkStateId
	FROM
		LkZipCode;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpLkStateGet;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpLkStateGet`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		LkStateId,
		State,
		Abbreviation
	FROM
		LkState;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpLkStateGetById;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpLkStateGetById`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _LkStateId INT
    )
BEGIN
    SELECT
		LkStateId,
		State,
		Abbreviation
	FROM
		LkState
	WHERE
		LkStateId = _LkStateId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpLkCityGet;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpLkCityGet`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		LkCityId,
		City,
		LkStateId,
        LkZipCodeId
	FROM
		LkCity;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpIdentityAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpIdentityAdd`(
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
    
    INSERT INTO
		Identity
        (
			IdentityId
		)
        VALUES
        (
			_IdentityId
		);
    
    COMMIT;
    
    SELECT
		IdentityId,
        Created,
        Updated
	FROM
		Identity
	WHERE
		IdentityId = _IdentityId;
    
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpAddressGetById;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAddressGetById`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _AddressId INT
    )
BEGIN
    SELECT
		AddressId,
		IdentityId,
		LineOne,
		LineTwo,
		LkZipCodeId,
		LkCityId,
		LkStateId,
		IsEnabled,
		IsDeleted,
		Created,
		Updated
	FROM
		Address
	WHERE
		AddressId = _AddressId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpPersonAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpPersonAdd`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _FirstName VARCHAR(25),
    IN _LastName VARCHAR(25)
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    INSERT INTO
		Person
        (
			IdentityId,
            FirstName,
            LastName
		)
        VALUES
		(
			_ActiveId,
            _FirstName,
            _LastName
		);
        SET @PersonId = last_insert_id();
    
    COMMIT;
		SELECT
			PersonId,
            IdentityId,
            FirstName,
            LastName,
            IsEnabled,
            Created,
            Updated
		FROM
			Person
		WHERE
			PersonId = @PersonId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpPersonUpdate;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpPersonUpdate`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _PersonId INT,
    IN _FirstName VARCHAR(25),
    IN _LastName VARCHAR(25),
    IN _IsEnabled BOOL
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    Update
		Person
	SET
		FirstName = IFNULL(_FirstName, FirstName),
        LastName = IFNULL(_LastName, LastName),
        IsEnabled = IFNULL(_IsEnabled, IsEnabled)
	WHERE
		PersonId = _PersonId;
    
    COMMIT;
		SELECT
			PersonId,
            IdentityId,
            FirstName,
            LastName,
            IsEnabled,
            Created,
            Updated
		FROM
			Person
		WHERE
			PersonId = @PersonId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpPersonGetById;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpPersonGetById`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _PersonId INT
    )
BEGIN
    SELECT
			PersonId,
            IdentityId,
            FirstName,
            LastName,
            IsEnabled,
            Created,
            Updated
		FROM
			Person
		WHERE
			PersonId = _PersonId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpPersonGetByIdentityId;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpPersonGetByIdentityId`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		PersonId,
		IdentityId,
		FirstName,
		LastName,
		IsEnabled,
		Created,
		Updated
	FROM
		Person
	WHERE
		IdentityId = _ActiveId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpTransactionGetWorth;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpTransactionGetWorth`(
/*
Summary
	Get new worth for entity
History
	11/19/22: Create
*/
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
	SELECT 
	SUM(
		CASE 
			WHEN ac.LkAccountTypeId = 1 THEN t.TransactionAmount * l.FlowRate
			WHEN ac.LkAccountTypeId = 2 THEN t.TransactionAmount * l.FlowRate
            WHEN ac.LkAccountTypeId = 3 THEN t.TransactionAmount * l.FlowRate
            WHEN ac.LkAccountTypeId = 4 THEN t.TransactionAmount * l.FlowRate
            WHEN ac.LkAccountTypeId = 5 THEN t.TransactionAmount * l.FlowRate
        END
        ) AS 'NetWorth',
	SUM(
		CASE 
			WHEN ac.LkAccountTypeId = 1 THEN t.TransactionAmount * l.FlowRate
			WHEN ac.LkAccountTypeId = 2 THEN t.TransactionAmount * l.FlowRate
        END
        ) AS 'Assets',
	SUM(
		CASE 
            WHEN ac.LkAccountTypeId = 3 THEN t.TransactionAmount * l.FlowRate
            WHEN ac.LkAccountTypeId = 4 THEN t.TransactionAmount * l.FlowRate
            WHEN ac.LkAccountTypeId = 5 THEN t.TransactionAmount * l.FlowRate
        END
        ) AS 'Liabilities'
	FROM 
		Transaction t
	LEFT JOIN
		Account ac
        ON t.AccountId = ac.AccountId
	LEFT JOIN
		Subcategory s
        ON t.SubcategoryId = s.Subcategoryid
	LEFT JOIN
		LkFlow l
        ON s.LkFlowId = l.LkFlowId
	WHERE
		t.IdentityId = _ActiveId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpUserProfileGetByIdentityId;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUserProfileGetByIdentityId`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpGeo;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `xxx`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpLkPhoneTypeGet;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpLkPhoneTypeGet`()
BEGIN
	SELECT
		LkPhoneTypeId,
        PhoneTypeName
	FROM
		LkPhoneType;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpVwUserProfileGetByIdentityId;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpVwUserProfileGetByIdentityId`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36)
    )
BEGIN
    SELECT
		UserProfileId,
        IdentityId,
        UserName,
        Email,
        ActiveId,
        PersonId,
        FirstName,
        LastName,
        Created,
        Updated
	FROM
		VwUserProfile
	WHERE
		IdentityId = _ActiveId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpPhoneNumberAdd;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpPhoneNumberAdd`(
	IN _IdentityId CHAR(36),
    IN _ActiveId CHAR(36),
    IN _LkPhoneTypeId INT,
    IN _PhoneNumberValue VARCHAR(15)
    )
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END; 
	START TRANSACTION;
    
    INSERT INTO
		PhoneNumber
        (
			IdentityId,
			LkPhoneTypeId,
            PhoneNumberValue
		)
	VALUES
		(
			_ActiveId,
            _LkPhoneTypeId,
            _PhoneNumberValue
		);
	SET @PhoneNumberId = last_insert_id();
    
    COMMIT;
    SELECT
		*
	FROM
		PhoneNumber
	WHERE
		PhoneNumberId = @PhoneNumberId;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpGeoGetByZipCode;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpGeoGetByZipCode`(
	IN _ZipCode VARCHAR(11)
    )
BEGIN
    SELECT DISTINCT
		LkCityId,
        City,
        LkSateId,
        StateName,
        Abbreviation,
        LkZipCodeId,
        ZipCode
	FROM
		VwGeo
	WHERE
		ZipCode = _ZipCode;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpGeoGetZipCodesByStateId;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpGeoGetZipCodesByStateId`(
	IN _LkStateId INT
    )
BEGIN
    SELECT DISTINCT
		LkZipCodeId,
        ZipCode
	FROM
		LkZipCode
	WHERE
		LkStateId = _LkStateId
	ORDER BY
		ZipCode;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS SpGeoGetCitiesByStateId;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpGeoGetCitiesByStateId`(
	IN _LkStateId INT
    )
BEGIN
    SELECT DISTINCT
		LkCityId,
        City,
        LkStateId,
        LkZipCodeId
	FROM
		LkCity
	WHERE
		LkStateId = _LkStateId
	ORDER BY
		City;
END ;;
DELIMITER ;