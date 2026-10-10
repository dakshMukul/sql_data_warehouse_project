/*
==================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
==================================================================

Script Purpose:
	This stored Procedure load data into the bronze schema from external CSV files.
	It performs the followring actions:
	- Truncate the bronze tables before loading the data.
	- Uses the Buld Insert command to load the data from CSV files to bronze tables.

Parameters:
	none.
	This stored procedure does not accept any parameters or return any value.

Usage Example:
	EXEC bronze.load_bronze;
==================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '===================================================';
		PRINT 'Loading the bronze layer';
		PRINT '===================================================';

		PRINT '---------------------------------------------------';
		PRINT 'Loading the crm tables';
		PRINT '---------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info
		PRINT '>> Inserting Date Into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\daksh\Desktop\SQL Warehouse Project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time)AS NVARCHAR) + 'seconds';
		PRINT '>>--------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT '>> Inserting Date Into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\daksh\Desktop\SQL Warehouse Project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
		PRINT '>>--------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details
		PRINT '>> Inserting Date Into: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\daksh\Desktop\SQL Warehouse Project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
		PRINT '>>--------------------------------------------------';


		PRINT '---------------------------------------------------';
		PRINT 'Loading the erp tables';
		PRINT '---------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12
		PRINT '>> Inserting Date bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\daksh\Desktop\SQL Warehouse Project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
		PRINT '>>--------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101
		PRINT '>> Inserting Date Into: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\daksh\Desktop\SQL Warehouse Project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>>--------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		PRINT '>> Inserting Date Into: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\daksh\Desktop\SQL Warehouse Project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'second';
		PRINT '>>--------------------------------------------------';
		SET @batch_end_time = GETDATE();
		PRINT 'Batch Completion Time: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVarchar) + 'seconds';
	END TRY
	BEGIN CATCH
		PRINT '============================================================='
		PRINT 'Error Occured During Loading Bronze Layer'
		PRINT 'Error Message' + ERROR.MESSAGE();
		PRINT 'Error Message' + CAST(ERROR.NUMBER() AS NVARCHAR(50));
		PRINT 'Error Message' + CAST(ERROR.STATE() AS NVARCHAR(50));
		PRINT '============================================================='
	END CATCH
END
