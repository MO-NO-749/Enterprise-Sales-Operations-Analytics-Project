CREATE OR ALTER PROCEDURE dbo.load_Data_Transactions
 AS 
BEGIN 
	DECLARE @START_TIME DATETIME,@END_TIME DATETIME 
BEGIN TRY
		-- USE TURNICATE IF FILE DATA IS DUPLICATAD 
		-- CONDITIONAL INSERT OR USEING NOT EXIST
		PRINT '==========================';
		PRINT 'loading into transaction table ';
		PRINT '==========================';
	SET @START_TIME = GETDATE();
		PRINT '>> LOADING DATA INTO dbo.Transactions';
		-- 1. Check if the table exists in the database schema
	IF OBJECT_ID('dbo.Transactions', 'U') IS NOT NULL
	BEGIN
    -- 2. If it exists, wipe all existing data instantly
		TRUNCATE TABLE dbo.Transactions;
	END
		BULK INSERT dbo.Transactions
		FROM 'E:\EXCEL_POWERBI_SQL_PROJECT\End-to-End Commerce Analytics\normalizatin - quistion_MAIN FILE\Transactions.csv'
	-- please use your own file location 
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR= ',',
			ROWTERMINATOR = '\n',
			TABLOCK 
			);
	SET @END_TIME = GETDATE();
	PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND,@START_TIME,@END_TIME) AS NVARCHAR) + ' SECOUNDS';
	PRINT '-------------------------------------'
END TRY
BEGIN CATCH 
	PRINT '=========================================';
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER' ;
	PRINT 'ERROR MESSAGE'+ ERROR_MESSAGE();
	PRINT 'ERROR MESSAGE'+ CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT 'ERROR MESSAGE'+ CAST(ERROR_STATE() AS NVARCHAR);
	PRINT '========================================='
END CATCH
END
