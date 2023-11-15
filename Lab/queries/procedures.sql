--PROZEDUREN

exec createNewTable 'TableForVersionLab', 'id INTEGER IDENTITY(1,1) PRIMARY KEY'
exec addColumn 'TableForVersionLab', 'kunden_id', 'INT'
exec changeColumnType 'TableForVersionLab', 'kunden_id', 'varchar(30)'
exec addDefaultConstraint @tableName='TableForVersionLab',@constraintName='dc_kunden_id', @columnName='kunden_id',@constraintValue='''placeholder''' 
exec addColumn 'TableForVersionLab', 'kundenid', 'INT'
exec addForeignKeyConstraint 'TableForVersionLab', 'FK_version_Kunden', 'kundenid', 'Kunden', 'kunden_id'
exec goToVersion 9;

SELECT *
FROM Versions
SELECT *
FROM CurrentVersion

Exec createNewTable 'T1' , 'ID INTEGER IDENTITY(1,1) PRIMARY KEY'
Exec addColumn 'T1' , 'nume', 'varchar(20)'
Exec addColumn 'T1', 'salariu' , 'int'
Exec changeColumnType 'T1' , 'nume', 'char(40)'
Exec addDefaultConstraint 'T1' , 'dc_nume', '''test''', 'nume'
Exec addDefaultConstraint 'T1' , 'dc_salariu', '0', 'salariu'
Exec CreateNewTable 'T2' , 'ID INTEGER IDENTITY(1,1) PRIMARY KEY' 
Exec addColumn 'T2' , 'fk' , 'int' 
Exec addForeignKeyConstraint 'T2', 'FK_name', 'fk', 'T1', 'ID'



