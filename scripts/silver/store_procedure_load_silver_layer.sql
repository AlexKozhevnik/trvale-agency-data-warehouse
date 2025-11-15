/*
Store Procedure: Load Silver Layer (Bronze --> Silver)

Script Purpose:
Thist store procedure performs the ETL process to populate the silver table from the bronze schema.
- Truncates Silver table.
- Insert transformed and cleansed data from Bronze into Silver layer.
- Insert logs data into log table.

How to execute: EXEC silver.load_silver
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	DECLARE @rows_loaded INT;
	DECLARE @duration_sec INT;
	BEGIN TRY
		PRINT '----------------------------------------';
		PRINT 'Loading Silver Layer from Bronze layer';
		PRINT '----------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Trancating table silver.ito and inserting Data'
		TRUNCATE TABLE silver.ito;

		PRINT '>> Inserrting Data Into: silver.ito';
	
		INSERT INTO silver.ito (
			number,
			reservation_number,
			common_number,
			booked,
			check_in,
			check_out,
			total_nights,
			service_type,
			pax,
			city,
			hotel,
			room_category,
			meal_type,
			notes,
			rn,
			agency,
			tourists,
			status,
			ref_number,
			free_cancel_till,
			netto_price,
			price,
			agency_price,
			invoice_number,
			invoice_proforma,
			invoice_total,
			invoice_sum,
			due_date,
			paid,
			rest_to_pay,
			currency,
			payment_date,
			voucher_number,
			hotel_confirmation_number,
			legal_entity,
			booking_manager,
			payment_type,
			profit
		)
		SELECT
			number,
			reservation_number,
			common_number,
			CAST(booked AS DATE) AS booked,
			CAST(check_in AS DATE) AS check_in,
			CAST(check_out AS DATE) AS check_out,
			-- Create new column 'Total nights in hotel'
			DATEDIFF(day, check_in, check_out) AS total_nights, 
			-- Identify potential transfers among all orders
			CASE	WHEN hotel IS NULL AND room_category IS NULL AND meal_type IS NULL OR room_category LIKE 'NO%'
					THEN 'POSSIBLE TRANSFER'
					ELSE 'BOOKING'
			END AS service_type,
			pax,
			-- Standardization of city names
			CASE	WHEN TRIM(UPPER(city)) = 'KARLSBAD' THEN 'KARLOVY VARY' 
					WHEN TRIM(city) = '<Not defined>' THEN 'UNKNOWN'
					ELSE city
			END AS city,
			-- Several variants of the name of one hotel are reduced to the standard name.
			-- In agreement with the system operators, only the first value from the list has been selected as relevant.
			TRIM(ISNULL(CASE	WHEN hotel LIKE 'KARLSBAD%' THEN 'KARLSBAD GRANDE MADONNA'
								WHEN CHARINDEX(',', hotel) > 0 THEN LEFT(hotel, CHARINDEX(',', hotel) -1)
								ELSE hotel
						END, 'n/a')) AS hotel,
			TRIM(ISNULL(CASE	WHEN CHARINDEX(',', room_category) > 0 THEN LEFT(room_category, CHARINDEX(',', room_category) -1)
								ELSE room_category
						END, 'n/a')) AS room_category,
			TRIM(ISNULL(CASE	WHEN CHARINDEX(',', meal_type) > 0 THEN LEFT(meal_type, CHARINDEX(',', meal_type) -1)
								ELSE meal_type
						END, 'n/a')) AS meal_type,
			ISNULL(TRIM(notes), 'n/a') AS notes,
			ISNULL(rn, 'n/a') AS rn,
			-- Standardization of customer group names
			CASE	WHEN agency = 'INDIVIDUALS' THEN 'INDIVIDUAL'
					WHEN agency = 'INDIVIDUAL/MOSKVA' THEN 'INDIVIDUAL'
					WHEN agency = 'INDIVIDUAL*' THEN 'INDIVIDUAL'
					ELSE agency
			END AS agency,
			-- Removing unnecessary system tags from client names
			TRIM(ISNULL(CASE
							WHEN TRIM(tourists) LIKE '%Dite%' THEN 'System name'
							WHEN TRIM(tourists) LIKE '%Group%' THEN 'System name'
							WHEN TRIM(tourists) LIKE '%Kind%' THEN 'System name'
							WHEN TRIM(tourists) LIKE '1%' THEN 'System name'
							WHEN TRIM(tourists) LIKE '2%' THEN 'System name'
							WHEN TRIM(tourists) LIKE '#%' THEN 'System name'
							WHEN TRIM(tourists) LIKE '0%' THEN 'System name'
							WHEN TRIM(tourists) LIKE '5%' THEN 'System name'
							WHEN tourists = 'nan' THEN 'n/a'
							WHEN CHARINDEX('+', tourists) > 0 THEN LEFT(tourists, CHARINDEX('+', tourists) -1)
							ELSE TRIM(tourists)
						END, 'n/a')) AS tourists,
			status,
			ISNULL(ref_number, 'n/a') AS ref_number,
			CAST(free_cancel_till AS DATE) AS free_cancel_till,
			ISNULL(netto_price, 0) AS netto_price, 
			ISNULL(price, 0) AS price,
			ISNULL(agency_price, 0) AS agency_price,
			ISNULL(invoice_number, 'n/a') AS invoice_number, 
			ISNULL(invoice_proforma, 'n/a') AS invoice_proforma,
			ISNULL(invoice_total, 'n/a') AS invoice_total,
			ISNULL(invoice_sum, 0) AS invoice_sum,
			CAST(due_date AS DATE) AS due_date,
			ISNULL(paid, 0) AS paid,
			ISNULL(rest_to_pay, 0) AS rest_to_pay,
			currency,
			CAST(payment_date AS DATE) AS payment_date,
			ISNULL(voucher_number, 'n/a') AS voucher_number, 
			ISNULL(hotel_confirmation_number, 'n/a') AS hotel_confirmation_number,
			-- Not all transactions were conducted through companies that are in the system.
			ISNULL(legal_entity, 'UNKNOWN') AS legal_entity,
			booking_manager,
			ISNULL(payment_type, 'unknown') AS payment_type,
			ISNULL(profit, 0) AS profit
		FROM bronze.ito
			-- Remove test orders from dataset
		WHERE	agency != 'Test part' 
				AND tourists NOT LIKE 'Test%' 
				AND tourists NOT LIKE 'ZELSOFT' 
				AND tourists NOT LIKE '%proxymo%';
		SET @rows_loaded = @@ROWCOUNT;
		
		SET @end_time = GETDATE();
		SET @duration_sec = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT '-- Load Duration: ' + CAST(@duration_sec AS NVARCHAR) + ' seconds';
		PRINT '-- SUCCESS ' + CAST(@rows_loaded AS NVARCHAR) + ' rows loaded into silver.ito';

		PRINT '=== INSERT LOAD LOG INTO silver.ito_load_logs';
		INSERT INTO silver.ito_load_logs (source, number_of_rows, duration_seconds, status)
		VALUES('bronze.ito', @rows_loaded, @duration_sec, 'SUCCESS');
		PRINT '=== LOG ENTRY CREATED';

	END TRY
	BEGIN CATCH
		PRINT '--------------------------------------------------'
		PRINT 'ERROR OCCURED DURING LOADING DATA TO SILVER LAYER'
		PRINT '--------------------------------------------------'
		PRINT 'Error message' + ERROR_MESSAGE();
		PRINT 'Error message' + CAST(ERROR_NUMBER() AS NVARCHAR);

		INSERT INTO silver.ito_load_logs (source, number_of_rows, duration_seconds, status)
		VALUES('bronze.ito', 0, DATEDIFF(SECOND, @start_time, GETDATE()), 'FAILED');
	END CATCH
END
