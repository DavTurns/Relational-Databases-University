--4.3 Trigger

CREATE TABLE queryLogTable(
	id INT IDENTITY(1,1) PRIMARY KEY,
	dateTime DATETIME,
	type Varchar(1),
	tableName Varchar(64),
	nrAffectedTuples INT
);

CREATE OR ALTER TRIGGER TriggerKunden
ON Kunden
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

	DECLARE @AffectedRows INT;
	SET @AffectedRows = @@ROWCOUNT;
	
    IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    BEGIN
        INSERT INTO queryLogTable(dateTime, type, tableName, nrAffectedTuples) VALUES (
		GETDATE(),'I','Kunden', @AffectedRows
		) 
    END

	IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
	BEGIN
		INSERT INTO queryLogTable(dateTime, type, tableName, nrAffectedTuples) VALUES (
		GETDATE(),'U','Kunden', @AffectedRows
		) 
	END

	IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
	BEGIN
		INSERT INTO queryLogTable(dateTime, type, tableName, nrAffectedTuples) VALUES (
		GETDATE(),'D','Kunden', @AffectedRows
		) 
	END
END;

SELECT * FROM queryLogTable;
SELECT * FROM Kunden;
SELECT count(*) FROM Kunden;

DROP TABLE queryLogTable;

Insert INTO Kunden(vorname,name,emailadresse) VALUES 
('Ana','Test','at@at.com'),
('Lisa','Test2','ata@at.com')
;

--examples
UPDATE Kunden SET vorname = 'Birte' WHERE vorname = 'Ana';
DELETE FROM Kunden WHERE kunden_id = 9 OR kunden_id = 10;

--4.4 CURSOR

CREATE OR ALTER PROCEDURE aufstockung
    @nr INT OUTPUT
AS
BEGIN
	IF @nr < 50 AND @nr >=20
	BEGIN
		SET @nr = @nr + 10;
	END
	IF @nr < 20
	BEGIN
		SET @nr = @nr + 50;
	END
END;
 
SELECT * FROM Lager;

DECLARE @produktId INT, @abteilungsId INT, @anzahl INT, @anzahlVorher INT;
DECLARE lagerCursor CURSOR FOR
SELECT produkt_id, abteilungs_id, anzahl
FROM Lager;

OPEN lagerCursor;

FETCH NEXT FROM lagerCursor INTO @produktId, @abteilungsId, @anzahl;

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @anzahlVorher = @anzahl;
	EXEC aufstockung @nr = @anzahl OUTPUT;

	UPDATE Lager
    SET anzahl = @anzahl 
	WHERE produkt_id = @produktId AND abteilungs_id = @abteilungsId;

	IF @anzahl != @anzahlVorher
	BEGIN
		PRINT 'Abteilung ' + CAST(@abteilungsId AS VARCHAR(10)) + ' hat die Anzahl des Warenbestands von Produkt ' + CAST(@produktId AS VARCHAR(10)) + ' von ' + CAST(@anzahlVorher AS VARCHAR(10)) + ' auf ' + CAST(@anzahl AS VARCHAR(10)) + ' vergrößert';
	END
    FETCH NEXT FROM lagerCursor INTO @produktId, @abteilungsId, @anzahl;
END

CLOSE lagerCursor;
DEALLOCATE lagerCursor;

SELECT * FROM Lager;