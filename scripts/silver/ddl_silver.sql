 /*
 DDL Script: Create Silver Table

 Script Puprose:
	This script creates table in the silver layer schema, dropping existing table if it already exists.
 */
 
 IF OBJECT_ID ('silver.ito', 'U') IS NOT NULL
	DROP TABLE silver.ito;
 CREATE TABLE silver.ito (
	number INT,
	reservation_number NVARCHAR(50),
	common_number NVARCHAR(50),
	booked DATE,
	check_in DATE,
	check_out DATE,
	total_nights INT,
	service_type NVARCHAR(20),
	pax INT,
	city NVARCHAR(50),
	hotel NVARCHAR(250),
	room_category NVARCHAR(200),
	meal_type NVARCHAR(200),
	notes NVARCHAR(250),
	rn NVARCHAR(50),
	agency NVARCHAR(200),
	tourists NVARCHAR(250),
	status NVARCHAR(50),
	ref_number NVARCHAR(50),
	free_cancel_till DATE,
	netto_price DECIMAL(19, 4),
	price DECIMAL(19, 4),
	agency_price DECIMAL(19, 4),
	invoice_number NVARCHAR(50),
	invoice_proforma NVARCHAR(50),
	invoice_total NVARCHAR(50),
	invoice_sum DECIMAL(19, 4),
	due_date DATE,
	paid DECIMAL(19, 4),
	rest_to_pay DECIMAL(19, 4),
	currency NVARCHAR(50),
	payment_date DATE,
	voucher_number NVARCHAR(50),
	hotel_confirmation_number NVARCHAR(50),
	legal_entity NVARCHAR(50),
	booking_manager NVARCHAR(50),
	payment_type NVARCHAR(50),
	profit DECIMAL(19, 4),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
 );

/*
DDL script: Create logs table

 Script Puprose:
	This script creates table in the silver layer schema, dropping existing table if it already exists.
*/
 IF OBJECT_ID ('silver.ito_load_logs', 'U') IS NOT NULL
	DROP TABLE silver.ito_load_logs;
 CREATE TABLE silver.ito_load_logs (
	load_number INT IDENTITY(1,1) PRIMARY KEY,
	source NVARCHAR(25) NOT NULL,
	load_date DATETIME2 NOT NULL DEFAULT GETDATE(),
	number_of_rows INT NOT NULL,
	duration_seconds INT NULL,
	status NVARCHAR(20) DEFAULT 'SUCCESS'
 );
