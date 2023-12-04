--5 add a foreign key constraint to a column of a table -------------------------------

create or alter procedure addForeignKeyConstraint (@tableName varchar(20), 
										  @foreignKeyName varchar(20), 
										  @columnName varchar(20), 
										  @referencedTable varchar(20), 
										  @columnReferencedTable varchar(20))
as
	begin
	declare @query as varchar(MAX)
	set @query = 'ALTER TABLE ' + @tableName + 
				 ' ADD CONSTRAINT ' + @foreignKeyName +
				 ' FOREIGN KEY (' + @columnName + 
				 ') REFERENCES ' + @referencedTable + ' (' + @columnReferencedTable  + ');'
	
	print(@query)
	exec(@query)

	-- If we are calling this function using the last version
    IF dbo.getCurrentVersionNr() = dbo.getLastVersionNr()
    BEGIN
        -- Adding a new column to Versions
        SET @query = 'INSERT INTO Versions (procedureName, parameter_1, parameter_2,parameter_3,parameter_4, parameter_5)
                      VALUES (''addForeignKeyConstraint'',''' + @tableName + ''',''' + @foreignKeyName+ ''',''' +@columnName+ ''',''' + @referencedTable + ''',''' +@columnReferencedTable+''');';
        PRINT(@query);
        EXEC(@query);
    END

	--updating currentfunction	
	EXEC incrementCurrentVersionNr;	
	end

drop procedure addForeignKeyConstraint

exec addForeignKeyConstraint 'Beispiel2', 'FK_Beispiel_Kunden', 'kunden_id', 'Kunden', 'kunden_id'


--ROLLBACK 5 --------------------------------------------------------------------------------------------------------

create or alter procedure rollback_addForeignKeyConstraint (@tableName varchar(30), @constraintName varchar(30))
as
	begin
	declare @query as varchar(MAX)
	set @query = 'ALTER TABLE ' + @tableName + ' DROP CONSTRAINT ' + @constraintName
	
	print(@query)
	exec(@query)

	EXEC decrementCurrentVersionNr;
	end

drop procedure rollback_addForeignKeyConstraint

exec rollback_addForeignKeyConstraint 'Beispiel2', 'dc_new_column'
