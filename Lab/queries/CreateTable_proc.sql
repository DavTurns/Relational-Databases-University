--3 creates simple table only with id column ---------------------------------------------

create or alter procedure createNewTable (@tableName varchar(30), @columnDefinition varchar(MAX))
as
	begin


	declare @query as varchar(MAX)
	set @query = 'Create Table '+ @tableName + ' ( '+ @columnDefinition  + ' )'
	print(@query)
	exec(@query)
		-- If we are calling this function using the last version
    IF dbo.getCurrentVersionNr() = dbo.getLastVersionNr()
    BEGIN
        -- Adding a new column to Versions
        SET @query = 'INSERT INTO Versions (procedureName, parameter_1, parameter_2)
                      VALUES (''createNewTable'',''' + @tableName + ''',''' + @columnDefinition+ ''');';
        PRINT(@query);
        EXEC(@query);
    END

	--updating currentfunction	
	EXEC incrementCurrentVersionNr;	
	end

Drop procedure createNewTable;

exec createNewTable 'Beispiel2', 'id INTEGER IDENTITY(1,1) PRIMARY KEY'

--3 Rollback

create or alter procedure rollback_createNewTable (@tableName varchar(30))

as
	begin
	declare @query as varchar(MAX)
	set @query = 'Drop Table ' + @tableName
	print(@query)
	exec(@query)

	EXEC decrementCurrentVersionNr
	end

Drop procedure rollback_createNewTable;

exec rollback_createNewTable 'Beispiel'