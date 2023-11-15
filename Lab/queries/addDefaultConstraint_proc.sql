--2 adds default constraint to a column of table -----------------------------------------

create or alter procedure addDefaultConstraint (@tableName varchar(30), @constraintName varchar(30), @constraintValue varchar(30), @columnName varchar(30))
as
	begin
	declare @query as varchar(MAX)
	set @query = 'ALTER TABLE ' + @tableName + ' ADD CONSTRAINT ' + @constraintName + ' DEFAULT ' +  @constraintValue + ' FOR ' + @columnName + ';'
	print(@query)
	exec(@query)

	-- If we are calling this function using the last version
    IF dbo.getCurrentVersionNr() = dbo.getLastVersionNr()
    BEGIN
        -- Adding a new column to Versions

		--!!!! IF CONSTRAINTVALUE IS STRING
		DECLARE @oldAttributeType VARCHAR(30); -- Adjust size based on your needs
		SELECT @oldAttributeType = COLUMN_NAME 
	   	FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = @tableName AND COLUMN_NAME = @columnName
		AND DATA_TYPE IN ('VARCHAR', 'NVARCHAR', 'CHAR', 'NCHAR', 'TEXT', 'NTEXT');
		
		IF  @oldAttributeType IS NULL
			BEGIN
			SET @query = 'INSERT INTO Versions (procedureName, parameter_1, parameter_2, parameter_3, parameter_4)
                      VALUES (''addDefaultConstraint'',''' + @tableName + ''',''' + @constraintName + ''',''' + @constraintValue + ''',''' + @columnName + ''');';

			END
		ELSE
			BEGIN
			SET @query = 'INSERT INTO Versions (procedureName, parameter_1, parameter_2, parameter_3, parameter_4)
                      VALUES (''addDefaultConstraint'',''' + @tableName + ''',''' + @constraintName + ''',''''' + @constraintValue + ''''',''' + @columnName + ''');';
			END
        PRINT(@query);
        EXEC(@query);
    END
	--updating currentfunction	
	EXEC incrementCurrentVersionNr;
	END

drop procedure addDefaultConstraint

exec addDefaultConstraint @tableName='Beispiel2',@constraintName='dc_new_Column', @columnName='new_Column',@constraintValue='''test''' 


--2 ROLLBACK -----------------------------------------------------------------------------

create or alter procedure rollback_addDefaultConstraint (@tableName varchar(30), @constraintName varchar(30))
as
	begin
	declare @query as varchar(MAX)
	set @query = 'ALTER TABLE ' + @tableName + ' DROP CONSTRAINT ' + @constraintName
	
	print(@query)
	exec(@query)

	EXEC decrementCurrentVersionNr;
	end

drop procedure rollback_addDefaultConstraint

exec rollback_addDefaultConstraint 'Beispiel2', 'dc_new_column'
