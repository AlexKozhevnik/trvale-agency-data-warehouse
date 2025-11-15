 /*
Store Procedure: Load Data from file to Bronze Layer (Source -> Bronze)

Script Puprose: 
	This store procedure loads data into the bronze layer schema from external csv. file.
	It performs the following actions:
	- Truncate the bronze table before loading data.
	- Uses the BULK INSERT command to load data from csv to bronze layer.
	- Load log into special logs table

How to execute: EXEC bronze.load_bronze
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME2, @end_time DATETIME2;
	DECLARE @rows_loaded INT;
	DECLARE @duration_sec INT;

	BEGIN TRY
		PRINT '=========================================';
		PRINT 'Loading Bronze Layer from ITO file';
		PRINT '=========================================';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.ito';
		TRUNCATE TABLE bronze.ito; 
	
		PRINT '>> Inserting Data Into: bronze.ito';
		BULK INSERT bronze.ito
		FROM 'C:\'
		WITH (
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ';',
			ROWTERMINATOR = '0x0D0A',
			CODEPAGE = '65001',
			ERRORFILE = 'C:\',
			TABLOCK
		);
		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into bronze.ito';

		PRINT '=== INSERT LOAD LOG INTO bronze.ito_load_logs'
		INSERT INTO bronze.ito_load_logs (source, number_of_rows, duration_seconds, status)
		VALUES('ito_file', @rows_loaded, @duration_sec, 'SUCCESS');
		PRINT '=== LOG ENTRY CREATED';

	END TRY
	BEGIN CATCH
		PRINT '--------------------------------------------------'
		PRINT 'ERROR OCCURED DURING LOADING FILE TO BRONZE LAYER'
		PRINT '--------------------------------------------------'
		PRINT 'Error message' + ERROR_MESSAGE();
		PRINT 'Error message' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO bronze.ito_load_logs (source, number_of_rows, duration_seconds, status)
		VALUES('ito_file', 0, DATEDIFF(SECOND, @start_time, GETDATE()), 'FAILED');
	END CATCH
END
