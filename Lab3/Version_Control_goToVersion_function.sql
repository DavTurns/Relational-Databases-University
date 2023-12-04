create or alter PROCEDURE goToVersion(@endVersionNumber Integer)
as
	begin

	IF @endVersionNumber > dbo.getLastVersionNr() or @endVersionNumber < 0
		BEGIN
			RAISERROR ('Versionnumber does not exist', 10, 1) 
		END

	DECLARE @currentVersionNumber Integer;
	DECLARE @procedureName VARCHAR(30), @p1 VARCHAR(30), @p2 VARCHAR(100), @p3 VARCHAR(30), @p4 VARCHAR(30), @p5 VARCHAR(30);

	Set @currentVersionNumber = dbo.getCurrentVersionNr();
	
	while @currentVersionNumber != @endVersionNumber
		begin

		Set @currentVersionNumber = dbo.getCurrentVersionNr();

		--select veriontuple from versions
		if @currentVersionNumber > @endVersionNumber
			begin
			--rollback function
			SELECT @procedureName = procedureName, @p1 = parameter_1, @p2 = parameter_2, @p3 = parameter_3, @p4 = parameter_4, @p5 = parameter_5
			FROM Versions
			WHERE @currentVersionNumber = number;


			IF @procedureName = 'changeColumnType'
				BEGIN
				exec rollback_changeColumnType @p1, @p2, @p4
				END

			IF @procedureName = 'addDefaultConstraint'
				BEGIN
				exec rollback_addDefaultConstraint @p1, @p2
				END

			IF @procedureName = 'createNewTable'
				BEGIN
				exec rollback_createNewTable @p1
				END

			IF @procedureName = 'addColumn'
				BEGIN
				exec rollback_addColumn @p1, @p2
				END

			IF @procedureName = 'addForeignKeyConstraint'
				BEGIN
				exec rollback_addForeignKeyConstraint @p1, @p2
				END
			
			end
		
		if @currentVersionNumber < @endVersionNumber
			begin
			print('go version forwards');
			SELECT @procedureName = procedureName, @p1 = parameter_1, @p2 = parameter_2, @p3 = parameter_3, @p4 = parameter_4, @p5 = parameter_5
			FROM Versions
			WHERE @currentVersionNumber + 1 = number;
			
			print(@procedureName);

			IF @procedureName = 'changeColumnType'
				BEGIN
				exec changeColumnType @p1, @p2, @p3
				END

			IF @procedureName = 'addDefaultConstraint'
				BEGIN
				exec addDefaultConstraint @p1, @p2, @p3, @p4
				END

			IF @procedureName = 'createNewTable'
				BEGIN
				--exec createNewTable @p1, @p2
				END

			IF @procedureName = 'addColumn'
				BEGIN
				exec addColumn @p1, @p2, @p3
				END

			IF @procedureName = 'addForeignKeyConstraint'
				BEGIN
				exec addForeignKeyConstraint @p1, @p2, @p3, @p4, @p5
				END
			end
		end
	end
go