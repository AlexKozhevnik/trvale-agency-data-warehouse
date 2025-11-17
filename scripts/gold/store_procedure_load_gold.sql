/*
	STORE PROCEDURE which load data from Silver Layer to all dim. and fact. tables in GOLD LAYER

	How to execute: EXEC gold.load_gold
	How to control logs: SELECT * FROM gold.load_logs
*/
CREATE OR ALTER PROCEDURE gold.load_gold AS
BEGIN
	DECLARE	@start_time DATETIME, @end_time DATETIME;
	DECLARE @rows_loaded INT;
	DECLARE @duration_sec INT;
	
	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_managers from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_managers';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_managers;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_managers';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_managers (manager_name, is_active) 
		SELECT
			booking_manager AS manager_name,
			CASE WHEN DATEDIFF(day, MAX(booked), GETDATE()) > 90 THEN 0 ELSE 1 END AS is_active
		FROM silver.ito
		WHERE booking_manager IS NOT NULL
		GROUP BY booking_manager;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_managers';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_managers', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_managers';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_managers', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_services from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_services';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_services;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_services';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_services (service_type)
		SELECT DISTINCT
			service_type
		FROM silver.ito
		WHERE service_type IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_services';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_services', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_services';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_services', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_cities from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_cities';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_cities;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_cities';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_cities (city)
		SELECT DISTINCT
			city
		FROM silver.ito
		WHERE city IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_cities';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_cities', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_cities';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_cities', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_hotels from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_hotels';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_hotels;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_hotels';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_hotels (hotel_name)
		SELECT DISTINCT
			hotel
		FROM silver.ito
		WHERE hotel IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_hotels';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_hotels', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_hotels';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_hotels', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_rooms from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_rooms';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_rooms;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_rooms';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_rooms (room_name)
		SELECT DISTINCT
			room_category 
		FROM silver.ito
		WHERE room_category IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_rooms';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_rooms', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_rooms';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_rooms', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_meal_type from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_meal_type';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_meal_type;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_meal_type';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_meal_type (meal_type_name)
		SELECT DISTINCT
			meal_type 
		FROM silver.ito
		WHERE meal_type IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_meal_type';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_meal_type', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_meal_type';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_meal_type', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_agencies from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_agencies';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_agencies;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_agencies';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_agencies (agency_name)
		SELECT DISTINCT
			agency 
		FROM silver.ito
		WHERE agency IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_agencies';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_agencies', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_agencies';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_agencies', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_customers from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_customers';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_customers;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_customers';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_customers (customer)
		SELECT DISTINCT
			tourists 
		FROM silver.ito
		WHERE tourists IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_customers';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_customers', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_customers';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_customers', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_order_status from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_order_status';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_order_status;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_order_status';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_order_status (status_name)
		SELECT DISTINCT
			status 
		FROM silver.ito
		WHERE status IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_order_status';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_order_status', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_order_status';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_order_status', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_currencies from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_currencies';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_currencies;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_currencies';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_currencies (currency_name)
		SELECT DISTINCT
			currency 
		FROM silver.ito
		WHERE currency IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_currencies';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_currencies', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_currencies';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_currencies', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_comapnies from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_comapnies';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_comapnies;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_comapnies';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_comapnies (company_name)
		SELECT DISTINCT
			legal_entity 
		FROM silver.ito
		WHERE legal_entity IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_comapnies';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_comapnies', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_comapnies';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_comapnies', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_payment_typies from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_payment_typies';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_payment_typies;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_payment_typies';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_payment_typies (payment_name)
		SELECT DISTINCT
			payment_type
		FROM silver.ito
		WHERE payment_type IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_payment_typies';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_payment_typies', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_payment_typies';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_payment_typies', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.dim_date from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.dim_date';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.dim_date;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.dim_date';
		PRINT '---------------------------------------';

		INSERT INTO gold.dim_date (
			date_key,
			full_date,
			calendar_year,
			calendar_quarter,
			calendar_month,
			month_name_cz,
			day_of_week_id,
			day_of_week_cz,
			day_name_short_cz,
			is_weekend
		)
		VALUES(-1, CAST('1900-01-01' AS DATE), 1900, 0, 0, 'N/A', 0, 'N/A', 'N/A', 0);

		-- generate & insert data
		WITH DateSeries AS (
			-- start date
			SELECT CAST('2020-01-01' AS DATE) AS dDate
			UNION ALL
			SELECT DATEADD(day, 1, dDate)
			FROM DateSeries
			WHERE dDate < CAST('2030-12-31' AS DATE)
		)
		INSERT INTO gold.dim_date (
			date_key,
			full_date,
			calendar_year,
			calendar_quarter,
			calendar_month,
			month_name_cz,
			day_of_week_id,
			day_of_week_cz,
			day_name_short_cz,
			is_weekend
		)
		SELECT
			-- date_key (YYYYMMDD)
			CAST(FORMAT(dDate, 'yyyyMMdd') AS INT) AS date_key,
			dDate AS full_date,
			YEAR(dDate) AS calendar_year,
			DATEPART(qq, dDate) AS calendar_quarter,
			MONTH(dDate) AS calendar_month,
			-- month's name
			CASE MONTH(dDate)
				WHEN 1 THEN 'leden' WHEN 2 THEN 'unor' WHEN 3 THEN 'brezen'
				WHEN 4 THEN 'duben' WHEN 5 THEN 'kveten' WHEN 6 THEN 'cerven'
				WHEN 7 THEN 'cervenec' WHEN 8 THEN 'srpen' WHEN 9 THEN 'zari'
				WHEN 10 THEN 'rijen' WHEN 11 THEN 'listopad' WHEN 12 THEN 'prosinec'
			END AS month_name_cz,
			-- day of the week
			DATEPART(dw, dDate) AS day_of_week_id,
			-- day of the week in czech
			CASE DATENAME(dw, dDate)
				WHEN 'Sunday' THEN 'nedele' WHEN 'Monday' THEN 'pondeli'
				WHEN 'Tuesday' THEN 'utery' WHEN 'Wednesday' THEN 'streda'
				WHEN 'Thursday' THEN 'ctvrtek' WHEN 'Friday' THEN 'patek'
				WHEN 'Saturday' THEN 'sobota'
			END AS day_of_week_cz,
			-- short name of dow
			CASE DATENAME(dw, dDate)
				WHEN 'Sunday' THEN 'Ne' WHEN 'Monday' THEN 'Po' WHEN 'Tuesday' THEN 'Ut'
				WHEN 'Wednesday' THEN 'St' WHEN 'Thursday' THEN 'Ct' WHEN 'Friday' THEN 'Pa'
				WHEN 'Saturday' THEN 'So'
			END AS day_name_short_cz,
			-- weekend
			CASE
				WHEN DATEPART(dw, dDate) IN (1, 7) THEN 1
				ELSE 0
			END AS is_weekend
		FROM DateSeries
		OPTION (MAXRECURSION 0);

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.dim_date';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.dim_date', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.dim_date';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.dim_date', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH

	BEGIN TRY 
		PRINT '===================================================';
		PRINT 'Load Gold Table gold.fact_bookings from Silver Layer';
		PRINT '===================================================';

		SET @start_time = GETDATE();
		PRINT '--------------------------------------';
		PRINT '>>> Truncate table gold.fact_bookings';
		PRINT '--------------------------------------';

		TRUNCATE TABLE gold.fact_bookings;

		PRINT '---------------------------------------';
		PRINT ' === INSERT DATA INTO gold.fact_bookings';
		PRINT '---------------------------------------';

		INSERT INTO gold.fact_bookings (
			service_key,
			hotel_key,
			city_key,
			room_key,
			meal_type_key,
			agency_key,
			customer_key,
			status_key,
			manager_key,
			booked_date_key,
			check_in_date_key,
			check_out_date_key,
			free_cancel_date_key,
			currency_key,
			payment_key,
			company_key,
			due_date_key,
			payment_date_key,
			total_nights,
			pax,
			netto_price,
			price,
			agency_price,
			invoice_sum,
			paid,
			rest_to_pay,
			profit,
			number,
			reservation_number,
			common_number,
			notes,
			invoice_number,
			invoice_proforma,
			invoice_total
		)
		SELECT
			ser.service_key,
			hot.hotel_key,
			cit.city_key,
			ro.room_key,
			mt.meal_type_key,
			ag.agency_key,
			cus.customer_key,
			os.status_key,
			man.manager_key,
			ISNULL(d_booked.date_key, -1) AS booked_date_key,
			ISNULL(d_cin.date_key, -1) AS check_in_date_key,
			ISNULL(d_cout.date_key, -1) AS check_out_date_key,
			ISNULL(d_free.date_key, -1) AS free_cancel_date_key,
			cur.currency_key,
			pt.payment_key,
			cp.company_key,
			ISNULL(d_da.date_key, -1) AS due_date_key,
			ISNULL(d_pay.date_key, -1) AS payment_date_key,
			ISNULL(sil.total_nights, 0) AS total_nights,
			sil.pax,
			sil.netto_price,
			sil.price,
			sil.agency_price,
			sil.invoice_sum,
			sil.paid,
			sil.rest_to_pay,
			sil.profit,
			sil.number,
			sil.reservation_number,
			sil.common_number,
			sil.notes,
			sil.invoice_number,
			sil.invoice_proforma,
			sil.invoice_total
		FROM silver.ito sil
		LEFT JOIN gold.dim_managers man
		ON sil.booking_manager = man.manager_name
		LEFT JOIN gold.dim_services ser
		ON sil.service_type = ser.service_type
		LEFT JOIN gold.dim_cities cit
		ON sil.city = cit.city
		LEFT JOIN gold.dim_hotels hot
		ON sil.hotel = hot.hotel_name
		LEFT JOIN gold.dim_rooms ro
		ON sil.room_category = ro.room_name
		LEFT JOIN gold.dim_meal_type mt
		ON sil.meal_type = mt.meal_type_name
		LEFT JOIN gold.dim_agencies ag
		ON sil.agency = ag.agency_name
		LEFT JOIN gold.dim_customers cus
		ON sil.tourists = cus.customer
		LEFT JOIN gold.dim_order_status os
		ON sil.status = os.status_name
		LEFT JOIN gold.dim_currencies cur
		ON sil.currency = cur.currency_name
		LEFT JOIN gold.dim_comapnies cp
		ON sil.legal_entity = cp.company_name
		LEFT JOIN gold.dim_payment_typies pt
		ON sil.payment_type = pt.payment_name
		LEFT JOIN gold.dim_date d_booked
		ON sil.booked = d_booked.full_date
		LEFT JOIN gold.dim_date d_cin
		ON sil.check_in = d_cin.full_date
		LEFT JOIN gold.dim_date d_cout
		ON sil.check_out = d_cout.full_date
		LEFT JOIN gold.dim_date d_free
		ON sil.free_cancel_till = d_free.full_date
		LEFT JOIN gold.dim_date d_da
		ON sil.due_date = d_da.full_date
		LEFT JOIN gold.dim_date d_pay
		ON sil.payment_date = d_pay.full_date;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into gold.fact_bookings';

		PRINT '---------------------------------------';
		PRINT ' === LOAD LOGS INTO gold.load_logs';
		PRINT '---------------------------------------';
		
		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status)
		VALUES('gold.fact_bookings', 'silver.ito', @rows_loaded, @duration_sec, 'SUCCESS');
	END TRY
	BEGIN CATCH
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'ERRROR DURING LOAD DATA INTO TABLE gold.fact_bookings';
		PRINT '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO gold.load_logs (table_name, source_name, number_of_rows, duration_seconds, status, error_message)
		VALUES('gold.fact_bookings', 'silver.ito', 0, @duration_sec, 'ERROR', 'Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE());
		THROW;
	END CATCH
END
