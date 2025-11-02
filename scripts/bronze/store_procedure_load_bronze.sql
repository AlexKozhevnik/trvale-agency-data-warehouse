/*
Store Procedure: Load Data from file to Bronze Layer (Source -> Bronze)

Script Puprose: 
	This store procedure loads data into the bronze layer schema from external csv. file.
	It performs the following actions:
	- Truncate the bronze table before loading data.
	- Uses the BULK INSERT command to load data from csv to bronze layer.

	Parameters:
	- Be shure that data types in columns Booked, C_in and C_out is in correct DATA format. 
*/

CREATE OR ALTER PROCEDURE bronz.load_bronz AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		PRINT '=========================================';
		PRINT 'Loading Bronze Layer from ITO file';
		PRINT '=========================================';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronz.ito';
		TRUNCATE TABLE bronz.ito; 
	
		PRINT '>> Inserting Data Into: bronz.ito';
		BULK INSERT bronz.ito
		FROM 'C:\Users\PC\OneDrive\Plocha\CK_Astra_Data_Warehouse_project\ito_until_zari.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ';',
			CODEPAGE = '65001',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '-- Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	END TRY
	BEGIN CATCH
		PRINT '--------------------------------------------------'
		PRINT 'ERROR OCCURED DURING LOADING FILE TO BRONZE LAYER'
		PRINT '--------------------------------------------------'
		PRINT 'Error message' + ERROR_MESSAGE();
		PRINT 'Error message' + CAST(ERROR_NUMBER() AS NVARCHAR);
	END CATCH
END
