
DECLARE @id INT = 51
DECLARE @limit INT = 600
WHILE @id < @limit
BEGIN
	DECLARE @sql NVARCHAR(1000)
	SET @sql = 'KILL ' + convert(varchar(10), @id)
	PRINT @sql
	EXEC sp_executesql @sql
	SET @id = @id + 1
END