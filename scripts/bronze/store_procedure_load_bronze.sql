/*
Store Procedure: Load Data from file to Bronze Layer (Source -> Bronze)

Script Puprose: 
	This store procedure loads data into the bronze layer schema from external csv. file.
	It performs the following actions:
	- Truncate the bronze table before loading data.
	- Uses the BULK INSERT command to load data from csv to bronze layer.

How to execute: EXEC bronze.load_bronze
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		PRINT '=========================================';
		PRINT 'Loading Bronze Layer from ITO file';
		PRINT '=========================================';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.ito';
		TRUNCATE TABLE bronze.ito; 
	
		PRINT '>> Inserting Data Into: bronze.ito';
		BULK INSERT bronze.ito
		FROM 'C:\Users\PC\astra_project\ito_09_cleaned_safe.csv'
		WITH (
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ';',
			ROWTERMINATOR = '0x0D0A',
			CODEPAGE = '65001',
			ERRORFILE = 'C:\Users\PC\astra_project\temp_errors.txt',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '-- Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS: Data loaded into bronze.ito';
	END TRY
	BEGIN CATCH
		PRINT '--------------------------------------------------'
		PRINT 'ERROR OCCURED DURING LOADING FILE TO BRONZE LAYER'
		PRINT '--------------------------------------------------'
		PRINT 'Error message' + ERROR_MESSAGE();
		PRINT 'Error message' + CAST(ERROR_NUMBER() AS NVARCHAR);
	END CATCH
END
