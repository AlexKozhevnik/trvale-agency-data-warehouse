/*
SCRIP PUPROSE:

	This script creates tables on Gold Layer and one special table for logs.
*/

-- create table gold.load_logs for logs on gold layer.
CREATE TABLE gold.load_logs (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    load_time DATETIME DEFAULT GETDATE(),
    table_name NVARCHAR(100) NOT NULL, 
    source_name NVARCHAR(100),
    number_of_rows INT,
    duration_seconds INT,
    status NVARCHAR(50) NOT NULL,
    error_message NVARCHAR(MAX)
);
-- create table gold.dim_managers
IF OBJECT_ID ('gold.dim_managers', 'U') IS NOT NULL
	DROP TABLE gold.dim_managers
CREATE TABLE gold.dim_managers (
	manager_key INT PRIMARY KEY IDENTITY(1,1),
	manager_name NVARCHAR(100) NOT NULL,
	is_active BIT NOT NULL
 );
 -- create table gold.dim_services
IF OBJECT_ID('gold.dim_services', 'U') IS NOT NULL
	DROP TABLE gold.dim_services
CREATE TABLE gold.dim_services (
	service_key INT PRIMARY KEY IDENTITY(1,1),
	service_type NVARCHAR(50) NOT NULL
);

 -- create table gold.dim_cities
IF OBJECT_ID('gold.dim_cities', 'U') IS NOT NULL
	DROP TABLE gold.dim_cities
CREATE TABLE gold.dim_cities (
	city_key INT PRIMARY KEY IDENTITY(1,1),
	city NVARCHAR(50) NOT NULL
);

 -- create table gold.dim_hotels
IF OBJECT_ID('gold.dim_hotels', 'U') IS NOT NULL
	DROP TABLE gold.dim_hotels
CREATE TABLE gold.dim_hotels (
	hotel_key INT PRIMARY KEY IDENTITY(1,1),
	hotel_name NVARCHAR(50) NOT NULL
);

 -- create table gold.dim_rooms
IF OBJECT_ID('gold.dim_rooms', 'U') IS NOT NULL
	DROP TABLE gold.dim_rooms
CREATE TABLE gold.dim_rooms (
	room_key INT PRIMARY KEY IDENTITY(1,1),
	room_name NVARCHAR(50) NOT NULL
);

 -- create table gold.dim_meal_type
IF OBJECT_ID('gold.dim_meal_type', 'U') IS NOT NULL
	DROP TABLE gold.dim_meal_type
CREATE TABLE gold.dim_meal_type (
	meal_type_key INT PRIMARY KEY IDENTITY(1,1),
	meal_type_name NVARCHAR(50) NOT NULL
);

 -- create table gold.dim_agencies
IF OBJECT_ID('gold.dim_agencies', 'U') IS NOT NULL
	DROP TABLE gold.dim_agencies
CREATE TABLE gold.dim_agencies (
	agency_key INT PRIMARY KEY IDENTITY(1,1),
	agency_name NVARCHAR(100) NOT NULL
);

 -- create table gold.dim_customers
IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL
	DROP TABLE gold.dim_customers
CREATE TABLE gold.dim_customers (
	customer_key INT PRIMARY KEY IDENTITY(1,1),
	customer NVARCHAR(100) NOT NULL
);

 -- create table gold.dim_order_status
IF OBJECT_ID('gold.dim_order_status', 'U') IS NOT NULL
	DROP TABLE gold.dim_order_status
CREATE TABLE gold.dim_order_status (
	status_key INT PRIMARY KEY IDENTITY(1,1),
	status_name NVARCHAR(50) NOT NULL
);

 -- create table gold.dim_currencies
IF OBJECT_ID('gold.dim_currencies', 'U') IS NOT NULL
	DROP TABLE gold.dim_currencies
CREATE TABLE gold.dim_currencies (
	currency_key INT PRIMARY KEY IDENTITY(1,1),
	currency_name NVARCHAR(20) NOT NULL
);

 -- create table gold.dim_comapnies
IF OBJECT_ID('gold.dim_comapnies', 'U') IS NOT NULL
	DROP TABLE gold.dim_comapnies
CREATE TABLE gold.dim_comapnies (
	company_key INT PRIMARY KEY IDENTITY(1,1),
	company_name NVARCHAR(50) NOT NULL
);

 -- create table gold.dim_payment_typies
IF OBJECT_ID('gold.dim_payment_typies', 'U') IS NOT NULL
	DROP TABLE gold.dim_payment_typies
CREATE TABLE gold.dim_payment_typies (
	payment_key INT PRIMARY KEY IDENTITY(1,1),
	payment_name NVARCHAR(100) NOT NULL
);

-- 1. create dim_date
IF OBJECT_ID('gold.dim_date', 'U') IS NOT NULL
	DROP TABLE gold.dim_date;
-- 2. create table
CREATE TABLE gold.dim_date (
	date_key INT PRIMARY KEY,
	full_date DATE NOT NULL,
	calendar_year INT NOT NULL,
	calendar_quarter INT NOT NULL,
	calendar_month INT NOT NULL,
	month_name_cz NVARCHAR(20) NOT NULL,
	day_of_week_id INT NOT NULL,
	day_of_week_cz NVARCHAR(20) NOT NULL,
	day_name_short_cz NVARCHAR(10) NOT NULL,
	is_weekend BIT NOT NULL,
	is_current_day BIT NOT NULL DEFAULT 0,
	CONSTRAINT uq_full_date UNIQUE (full_date)
);

 -- create table gold.fact_bookings
IF OBJECT_ID('gold.fact_bookings', 'U') IS NOT NULL
	DROP TABLE gold.fact_bookings
CREATE TABLE gold.fact_bookings (
	booking_fact_key BIGINT PRIMARY KEY IDENTITY(1,1),
	service_key INT NOT NULL,
	hotel_key INT NOT NULL,
	city_key INT NOT NULL,
	room_key INT NOT NULL,
	meal_type_key INT NOT NULL,
	agency_key INT NOT NULL,
	customer_key INT NOT NULL,
	status_key INT NOT NULL,
	manager_key INT NOT NULL,
	booked_date_key INT NOT NULL,
	check_in_date_key INT NOT NULL,
	check_out_date_key INT NOT NULL,
	free_cancel_date_key INT NOT NULL,
	currency_key INT NOT NULL,
	payment_key INT NOT NULL,
	company_key INT NOT NULL,
	due_date_key INT NOT NULL,
	payment_date_key INT NOT NULL,
	total_nights INT NOT NULL,
	pax INT NOT NULL,
	netto_price DECIMAL(18, 2),
	price DECIMAL(18, 2),
	agency_price DECIMAL(18, 2),
	invoice_sum DECIMAL(18, 2),
	paid DECIMAL(18, 2),
	rest_to_pay DECIMAL(18, 2),
	profit DECIMAL(18, 2),
	number NVARCHAR(50),
	reservation_number NVARCHAR(50),
	common_number NVARCHAR(50),
	notes NVARCHAR(250),
	invoice_number NVARCHAR(250),
	invoice_proforma NVARCHAR(250),
	invoice_total NVARCHAR(250)
);
