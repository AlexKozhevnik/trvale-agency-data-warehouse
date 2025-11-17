/*
Create an orchestrator procedure that calls all ETL procedures for the Bronze, Silver, and Gold layers.

This script creates a master procedure called dbo.dwh_etl_pipeline, which executes all three layers in sequence.

If any procedure fails, all changes are rolled back to avoid loading bad or incomplete data.

In the CATCH block, the error message "Check the text" is returned together with the system error message.
*/
CREATE OR ALTER PROCEDURE dwh_etl_pipeline AS
BEGIN

	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	
	DECLARE @PipelineStartTime DATETIME = GETDATE();
	DECLARE @PipelineDuration INT;

	BEGIN TRANSACTION;

	BEGIN TRY
		PRINT '=================================================================';
		PRINT 'DWH ETL PIPELINE STARTED: ' + CAST(@PipelineStartTime AS NVARCHAR);
		PRINT '=================================================================';

		PRINT '>>> STEP 1: Executing Bronze Layer: bronze.load_bronze';
		EXEC bronze.load_bronze;

		PRINT '>>> STEP 2: Executing Silver Layer: silver.load_silver';
		EXEC silver.load_silver;

		PRINT '>>> STEP 3: Executing Gold Layer: gold.load_gold';
		EXEC gold.load_gold;

		COMMIT TRANSACTION;

		SET @PipelineDuration = DATEDIFF(SECOND, @PipelineStartTime, GETDATE());
		PRINT '========================================================================================';
		PRINT 'DWH ETL PIPELINE SUCCESS. Duration: ' + CAST(@PipelineDuration AS NVARCHAR) + ' secinds.';
		PRINT '========================================================================================';
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		
		SET @PipelineDuration = DATEDIFF(SECOND, @PipelineStartTime, GETDATE());

		PRINT '=======================================================================================';
		PRINT 'DWH ETL PIPELINE FAILED! Duration: ' + CAST(@PipelineDuration AS NVARCHAR) + ' seconds.';
		PRINT 'Error: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + ERROR_NUMBER();
		PRINT 'Error state: ' + ERROR_STATE();
		PRINT '=======================================================================================';

		THROW;
	END CATCH
END
