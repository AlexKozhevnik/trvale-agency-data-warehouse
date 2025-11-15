/*
-----------------------------------------
Some Quality Checks
-----------------------------------------
Script Purpose:
  This script puprose varoius quality checks for data consistencym accuracy and standardization across silver schema
*/

-- Check for Duplicates in Primary Key
-- Expectation: No results
-- AS EXPECTED
SELECT
	common_number,
	COUNT(*)
FROM silver.ito
GROUP BY common_number
HAVING COUNT(*) > 1 OR common_number IS NULL

-- Check for unwanted spaces in columns with string data type
SELECT 
	tourists
FROM silver.ito
WHERE tourists != TRIM(tourists)

-- Data Standardization & Consistency
/* 
- WHERE hotel IS NULL and status = 'Confirmed' - only transfers and excursions.
- some rows with hotel, mela_type and room_category contains more then one type, because one order may has more then one guest with different types of hotel and meal ans so on. 
- agnecy = 'Test part' - not the real reservations, tests only.
- tourist - we have some system names like 0569, Grop30 and so on. 
*/
SELECT DISTINCT tourists
FROM silver.ito

-- Check for NULL values
SELECT payment_type 
FROM bronze.ito
WHERE payment_type IS NULL

-- Check for Negative Numbers
-- We have negative numbers in columns: rest_to_pay (money back) and profit (big values in new reservations where we are waiting for paying 
-- and samll values in confirmed reservations with with proice in EUR but profint in CZK 
SELECT profit
FROM silver.ito
WHERE profit < 0

-- Check for Invalid Date between check-in and check-out
-- AS EXPECTED
SELECT * FROM silver.ito
WHERE check_out < check_in

-- Check for Invalid Date between check-in and check-out where dates are same
-- We have 221 rows with same date of check-in and check-out, there are no hotels, so it is transfers or excursions. 
SELECT * FROM bronze.ito
WHERE check_in > check_out

-- Check Out-of-range Dates
SELECT DISTINCT 
booked
FROM bronze.ito
WHERE booked > GETDATE()

-- Identify possible transfers
SELECT *, COUNT(*) OVER () FROM bronze.ito
WHERE hotel IS NULL 
AND room_category IS NULL 
AND meal_type IS NULL 
OR room_category LIKE 'NO%'

-- Identify and resolve bad customers name
SELECT TRIM(ISNULL(CASE
					WHEN TRIM(tourists) LIKE '%Dite%' THEN 'System name'
					WHEN TRIM(tourists) LIKE '%Group%' THEN 'System name'
					WHEN TRIM(tourists) LIKE '%Kind%' THEN 'System name'
					WHEN TRIM(tourists) LIKE '1%' THEN 'System name'
					WHEN TRIM(tourists) LIKE '2%' THEN 'System name'
					WHEN TRIM(tourists) LIKE '#%' THEN 'System name'
					WHEN TRIM(tourists) LIKE '0%' THEN 'System name'
					WHEN TRIM(tourists) LIKE '5%' THEN 'System name'
					WHEN CHARINDEX('+', tourists) > 0 THEN LEFT(tourists, CHARINDEX('+', tourists) -1)
					WHEN TRIM(tourists) = '' THEN 'n/a'
					ELSE TRIM(tourists)
				END, 'n/a')) AS tourists
FROM bronze.ito
ORDER BY tourists

-- indentify anpossible staying duration
SELECT 
	check_in,
	check_out,
	DATEDIFF(day, check_in, check_out) AS nights
FROM bronze.ito
WHERE DATEDIFF(day, check_in, check_out) > 30
