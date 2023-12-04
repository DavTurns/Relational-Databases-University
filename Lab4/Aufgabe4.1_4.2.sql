--4.1)	

CREATE TABLE Students (
	id INT IDENTITY(1,1) PRIMARY KEY,
	firstName VARCHAR(30),
	lastName VARCHAR(30),
	creditScore INT,
	country VARCHAR(30),
);

CREATE OR ALTER FUNCTION validateCredit(@creditScore INT)
RETURNS BIT
AS
BEGIN
	IF @creditScore >= 100
	BEGIN
		RETURN 1;
	END
	RETURN 0;
END

CREATE OR ALTER FUNCTION validateCountry(@country VARCHAR(30))
RETURNS BIT
AS
BEGIN
	IF @country IN ('de', 'fr', 'en', 'it', 'ro', 'hu', 'esp', 'bg', 'b')
	BEGIN
		RETURN 1;
	END
	RETURN 0;
END



CREATE OR ALTER PROCEDURE insertIntoStudents (@firstName VARCHAR(30),
	@lastName VARCHAR(30),
	@creditScore INT,
	@country VARCHAR(30))
AS
BEGIN
	IF dbo.validateCountry(@country) = 1 AND dbo.validateCredit(@creditScore) = 1
	BEGIN
		DECLARE @query VARCHAR(MAX);
		SET @query = 
		'INSERT INTO Students (
		firstName,
		lastName,
		creditScore,
		country) VALUES ('''+@firstName+''','''+@lastName+''','+cast(@creditScore as varchar(MAX))+','''+@country+''');';
		PRINT (@query);
		EXEC (@query);
		
	END
	ELSE
	BEGIN
		DECLARE @ErrorMessage NVARCHAR(200) = 'INSERT parameters are invalid';
        DECLARE @ErrorSeverity INT = 16;

        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
	END
END

SELECT * FROM Students;

EXEC insertIntoStudents Bob, Dob, 200, 'de'; 


--4.2

CREATE FUNCTION LieferungenMitAnzahlTagenBis(@date Date)
RETURNS @LieferungMitAnzahlTagen TABLE
( id INT,
tage INT,
Status varchar(20),
lieferwagen_id INT)
AS
BEGIN
	INSERT INTO @LieferungMitAnzahlTagen (id, tage, Status, lieferwagen_id)
    SELECT
        lieferung_id AS id,
        DATEDIFF(DAY, lieferdatum, @date) AS tage,
        Status,
        lieferwagen_id
    FROM
        Lieferung;

    RETURN;
END

CREATE OR ALTER VIEW AbteilungsIdAdresse
AS
SELECT A.abteilungs_id, A.adresse
FROM Abteilung A
JOIN (
SELECT abteilungs_id
FROM Mitarbeiter
GROUP BY abteilungs_id
HAVING count(*) >= 3) AS AD
ON AD.abteilungs_id = A.abteilungs_id

SELECT * FROM LieferungenMitAnzahlTagenBis('2023-11-18');

SELECT L.*, LW.marke, LW.baujahr, A.adresse
FROM LieferungenMitAnzahlTagenBis('2023-11-18') L
JOIN Lieferwagen LW ON LW.lieferwagen_id = L.lieferwagen_id
JOIN AbteilungsIdAdresse A ON A.abteilungs_id = LW.abteilungs_id