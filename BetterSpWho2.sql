--DatawarehouseRenRe
--BenchmarkTPOT
--InvestmentsDataWarehouse

USE master
DECLARE @DbName NVARCHAR(1000) = 'DatawarehouseRenRe'
DECLARE @KillProcesses BIT = 1

IF (SELECT OBJECT_ID('tempdb..#tempProcesses')) IS NOT NULL
	DROP TABLE #tempProcesses

IF (SELECT OBJECT_ID('tempdb..#KillProcessesDriver')) IS NOT NULL
	DROP TABLE #KillProcessesDriver

CREATE TABLE #tempProcesses
(
	SPID char(5)
	,STATUS NVARCHAR(100)
	,LOGIN NVARCHAR(100)
	,HostName NVARCHAR(100)
	,BlkBy  NVARCHAR(1000)
	,DBName  NVARCHAR(1000)
	,Command NVARCHAR(1000)
	,CpuTime NVARCHAR(1000)
	,DiskIO NVARCHAR(1000)
	,LastBatch NVARCHAR(1000)
	,ProgramName NVARCHAR(1000)
	,SPID_ char(5)
	,REQUESTID INT
)

INSERT INTO 
	#tempProcesses 
EXEC sp_who2;

ALTER TABLE #tempProcesses ADD TimeTaken DATETIME NULL

UPDATE
	#tempProcesses 
SET
	TimeTaken = GETUTCDATE()

SELECT * FROM #tempProcesses WHERE DBName = @DbName

SELECT
	row_number() OVER (ORDER BY SPID) AS RowId
	,SPID
INTO
	#KillProcessesDriver
FROM
	#tempProcesses WHERE DBName = @DbName

SELECT * FROM #KillProcessesDriver

DECLARE @CurrRowId INT = 1
DECLARE @MaxRowId INT, @Sql NVARCHAR(MAX)

SELECT @MaxRowId = MAX(RowId) FROM #KillProcessesDriver

WHILE @CurrRowId <= @MaxRowId
BEGIN
	SELECT @Sql = 'kill ' + SPID from #KillProcessesDriver WHERE RowId = @CurrRowId
	PRINT @Sql
	
	IF(@KillProcesses = 1)
		EXEC sp_executesql @sql

	SET @CurrRowId = @CurrRowId + 1
END