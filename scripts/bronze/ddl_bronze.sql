 /*
 DDL Script: Create Bronze Table

 Script Puprose:
	This script creates table in the bronze layer schema, dropping existing table if it already exists.
 */
 
 IF OBJECT_ID ('bronze.ito', 'U') IS NOT NULL
	DROP TABLE bronze.ito;
 CREATE TABLE bronze.ito (
	number INT,
	reservation_number NVARCHAR(50),
	common_number NVARCHAR(50),
	booked DATETIME2,
	check_in DATETIME2,
	check_out DATETIME2,
	pax INT,
	city NVARCHAR(50),
	hotel NVARCHAR(250),
	room_category NVARCHAR(200),
	meal_type NVARCHAR(200),
	notes NVARCHAR(250),
	rn DECIMAL(10, 4),
	agency NVARCHAR(200),
	tourists NVARCHAR(250),
	status NVARCHAR(50),
	ref_number DECIMAL(10, 4),
	free_cancel_till DATETIME2,
	netto_price DECIMAL(19, 4),
	price DECIMAL(19, 4),
	agency_price DECIMAL(19, 4),
	invoice_number DECIMAL(10, 4),
	invoice_proforma DECIMAL(10, 4),
	invoice_total NVARCHAR(50),
	invoice_sum DECIMAL(19, 4),
	due_date DATETIME2,
	paid DECIMAL(19, 4),
	rest_to_pay DECIMAL(19, 4),
	currency NVARCHAR(50),
	payment_date DATETIME2,
	voucher_number DECIMAL(10, 4),
	hotel_confirmation_number DECIMAL(10, 4),
	legal_entity NVARCHAR(50),
	booking_manager NVARCHAR(50),
	payment_type NVARCHAR(50),
	profit DECIMAL(19, 4)
 );
