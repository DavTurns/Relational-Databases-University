--1. no rollback procedure needed-------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE changeColumnType (
    @tableName VARCHAR(30),
    @columnName VARCHAR(30),
    @newColumnType VARCHAR(30)
	)
AS
BEGIN
    -- Find former attributetype
    DECLARE @oldAttributeType VARCHAR(30); -- Adjust size based on your needs
    SELECT @oldAttributeType = DATA_TYPE +
        CASE
            WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(5)) + ')'
            ELSE ''
        END
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @tableName AND COLUMN_NAME = @columnName;

    DECLARE @query AS VARCHAR(MAX);
    SET @query = 'ALTER TABLE ' + @tableName + ' ALTER COLUMN ' + @columnName + ' ' + @newColumnType;
    PRINT(@query);
    EXEC(@query);

    -- If we are calling this function using the last version
    IF dbo.getCurrentVersionNr() = dbo.getLastVersionNr()
    BEGIN
        -- Adding a new column to Versions
        SET @query = 'INSERT INTO Versions (procedureName, parameter_1, parameter_2, parameter_3, parameter_4)
                      VALUES (''changeColumnType'',''' + @tableName + ''',''' + @columnName + ''',''' + @newColumnType + ''',''' + @oldAttributeType + ''');';
        PRINT(@query);
        EXEC(@query);
    END
	--updating currentfunction	
	EXEC incrementCurrentVersionNr;
END;

drop procedure changeColumnType

exec changeColumnType 'Beispiel2', 'new_Column', 'varchar(30)'

--ROLLBACK 1 -----------------------------------------------------------------------------
--TODO
--be careful when executing rollbackfunctions!!!!!!!
CREATE OR ALTER PROCEDURE rollback_changeColumnType (@tableName varchar(30), @columnName varchar(30), @newColumnType varchar(30))
as
	begin
	declare @query as varchar(MAX)
	set @query = 'Alter Table '+ @tableName+' Alter Column ' + @columnName + ' ' + @newColumnType
	print(@query)
	exec(@query)
	
	EXEC decrementCurrentVersionNr;
	end

drop procedure rollback_changeColumnType

exec rollback_changeColumnType 'Beispiel2', 'new_Column', 'varchar(20)'
