 /*
 DDL Script: Create Bronze Table

 Script Puprose:
	This script creates table in the bronze layer schema, dropping existing table if it already exists.

WARNING:
	Columns with name 'Free_cancel_till', 'Due_date', 'Payment_date' are NVARCHAR data type, need to cast it late. 
 */
 
 IF OBJECT_ID ('bronz.ito', 'U') IS NOT NULL
	DROP TABLE bronz.ito;
 CREATE TABLE bronz.ito (
	Number INT,
	Resv_Nr NVARCHAR(50),
	Common_Nr NVARCHAR(50),
	Booked DATE,
	C_in DATE,
	C_out DATE,
	Pax INT,
	City NVARCHAR(50),
	Hotel NVARCHAR(250),
	Room_category NVARCHAR(200),
	Meal_type NVARCHAR(200),
	Notes NVARCHAR(250),
	R_N NVARCHAR(50),
	Agency NVARCHAR(200),
	Tourists NVARCHAR(250),
	State NVARCHAR(50),
	T_O_Ref_Nr NVARCHAR(50),
	Free_cancel_till NVARCHAR(50),
	Net NVARCHAR(50),
	Price NVARCHAR(50),
	Agency_price NVARCHAR(50),
	Invoice_number NVARCHAR(50),
	Invoice_proforma NVARCHAR(50),
	Invoice_total NVARCHAR(50),
	Invoice_sum NVARCHAR(50),
	Due_date NVARCHAR(50),
	Paid NVARCHAR(50),
	Rest_to_pay NVARCHAR(50),
	Currency NVARCHAR(50),
	Payment_date NVARCHAR(50),
	Voucher_nr NVARCHAR(50),
	Hotel_conf_nr NVARCHAR(50),
	Legal_entity NVARCHAR(50),
	Booking_manager NVARCHAR(50),
	Payment_type NVARCHAR(50),
	Profit NVARCHAR(50)
 );
