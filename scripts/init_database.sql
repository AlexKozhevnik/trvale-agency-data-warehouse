/*
Create Database and Schemas

	This scrip creates a new database named 'ItoDataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated. The script sets up three schemas: bronze, silver and gold
*/

USE master;
GO

-- Drop and recreate the 'ItoDataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'ItoDataWarehouse')
BEGIN
	ALTER DATABASE ItoDataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE ItoDataWarehouse;
END;
GO

-- Create the ItoDataWarehouse database
CREATE DATABASE ItoDataWarehouse;
GO

USE ItoDataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
