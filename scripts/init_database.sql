/*
========================================
Create Databse and Schema
==========================================

Script Purpose:
	This script creates a new database named 'DataWarehouse' after checking if it alread exists.
	If the database exists, it is dropped and recreated. Additionally, the script sets up theree schemas
	within the databse: bronze, silver and gold

Warning:
	Running this script will drop the entire 'DataWarehouse' database if it exists.
	All data in the database will be permanently deleted. Proceed with caution and 
	ensure you have proper backups before running this scrpt.

*/

USE master;
GO

-- DROP and recreate the 'DataWarehouse' databsae

IF EXISTS (SELECT 1 FROM sys.database WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO


--Create the 'DataWarehouse' databse

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--Create Schemas
	
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
