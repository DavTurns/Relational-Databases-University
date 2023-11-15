--4 ---------------------------------------
create or alter procedure addColumn (@tableName varchar(30), @columnName varchar(30), @columnType varchar(30))
as
	begin
	declare @query as varchar(MAX)
	set @query = 'Alter Table ' + @tableName + ' add ' + @columnName + ' ' + @columnType + ';'
	
	print(@query)
	exec(@query)

			-- If we are calling this function using the last version
    IF dbo.getCurrentVersionNr() = dbo.getLastVersionNr()
    BEGIN
        -- Adding a new column to Versions
        SET @query = 'INSERT INTO Versions (procedureName, parameter_1, parameter_2,parameter_3)
                      VALUES (''addColumn'',''' + @tableName + ''',''' + @columnName+ ''',''' +@columnType+''');';
        PRINT(@query);
        EXEC(@query);
    END

	--updating currentfunction	
	EXEC incrementCurrentVersionNr;	
	end

drop procedure addColumn

exec addColumn 'Beispiel2', 'kunden_id', 'INT'

--4 rollback ----------------------------------------

create or alter procedure rollback_addColumn (@tableName varchar(20), @columnName varchar(20))
as
	begin
	declare @query as varchar(MAX)
	set @query = 'ALTER TABLE ' + @tableName + ' DROP COLUMN ' + @columnName + ';'
	
	print(@query)
	exec(@query)

	EXEC decrementCurrentVersionNr
	end


drop procedure rollback_addColumn

exec rollback_addColumn 'Beispiel', 'new_Column'