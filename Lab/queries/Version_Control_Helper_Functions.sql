-- Helper functions ----------------------------------------
EXEC goToVersion -11;
CREATE FUNCTION getCurrentVersionNr()
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;
    SELECT @Result = number
    FROM CurrentVersion;
    RETURN @Result;
END;

CREATE OR ALTER FUNCTION getLastVersionNr()
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;
    SELECT @Result = max(number)
    FROM Versions
	
	if @Result IS NULL
		begin
		RETURN 0;
		end
    RETURN @Result;
END;

CREATE OR ALTER PROCEDURE setCurrentVersionNr(@newVersionNr INT)
AS
BEGIN
    UPDATE CurrentVersion
    SET number = @newVersionNr;
END;


DECLARE @Result INT;
SET @Result = dbo.getLastVersionNr();
PRINT @Result;

CREATE OR ALTER PROCEDURE incrementCurrentVersionNr
AS
BEGIN
	DECLARE @newVersionNr int;
	SET @newVersionNr = dbo.getCurrentVersionNr() + 1;
    
	UPDATE CurrentVersion
    SET number = @newVersionNr;
END;


CREATE OR ALTER PROCEDURE decrementCurrentVersionNr
AS
BEGIN
	DECLARE @newVersionNr int;
	SET @newVersionNr = dbo.getCurrentVersionNr() - 1;
    
	UPDATE CurrentVersion
    SET number = @newVersionNr;
END;



DECLARE @Result INT;
SET @Result = dbo.getLastVersionNr();
PRINT @Result;