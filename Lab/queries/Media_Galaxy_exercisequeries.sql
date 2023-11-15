--1c
--INSERT Anfrage, welche gegen die Fremdschlüssel-Integritätsregel verstößt
INSERT INTO Bestellungen_Produkte (bestellungs_id,produkt_id, anzahl, preis_pro_einheit)
VALUES
	(7,1,1,800);
--1d

UPDATE Bestellungen_Produkte
SET preis_pro_einheit = 500.00
WHERE bestellungs_id = 1 and anzahl = 7;

UPDATE Bestellungen
SET status = 'STORNIERT'
WHERE kunden_id IS NULL;

UPDATE Bestellungen_Produkte
SET anzahl = 3
WHERE preis_pro_einheit IN (200,500);

DELETE Mitarbeiter
WHERE adresse LIKE '_%straße%';

UPDATE Bestellungen_Produkte
SET anzahl = 7
WHERE preis_pro_einheit BETWEEN 50 and 500;

--Aufgabe 2)

--Wähle alle Produkte aus die jeder einzelne Kunde jemals gekauft hat aus Abteilung 3

SELECT P.produktname, SUM(BP.anzahl) AS GesamteAnzahlGekauft
FROM Produkte P
LEFT JOIN Bestellungen_Produkte BP ON P.produkt_id = BP.produkt_id
GROUP BY P.produktname;

--Zeige alle Bestellungen Zusammen mit der Abteilung an, und wenn ein Kunde diese aufgegeben hat, den Vornamen und Namen des Kunden
--Verwendet 1 Join und 1 OUTER JOIN

--1
SELECT Abteilung.abteilungs_id, Abteilung.abteilungsname, Bestellungen.bestellung_id, Bestellungen.name, Bestellungen.vorname
FROM Abteilung
JOIN ( 
	SELECT Bestellungen.abteilungs_id, Bestellungen.bestellung_id, Kunden.name, Kunden.vorname
	FROM Bestellungen
	LEFT JOIN Kunden ON Bestellungen.kunden_id = Kunden.kunden_id
	)
AS Bestellungen ON Abteilung.abteilungs_id = Bestellungen.abteilungs_id;

--2

--3
SELECT K.name, L.status AS lieferstatus, L.lieferdatum, LW.marke, LW.baujahr
FROM Bestellungen B
JOIN Lieferung L ON B.lieferung_id = L.lieferung_id
JOIN Lieferwagen LW ON LW.lieferwagen_id = L.lieferwagen_id
JOIN Kunden K ON K.kunden_id = B.kunden_id
WHERE B.status = 'Bezahlt';

--4
--Wähle alle bestellungsids zusammen mit der Anzahl an bestellten Produkte für jede Bestellung, das mehr als 100 euro kostet
SELECT TOP 3 BP.bestellungs_id, COUNT(*) AS productcount
FROM Bestellungen_Produkte BP
WHERE BP.preis_pro_einheit > 100
GROUP BY BP.bestellungs_id
ORDER BY productcount DESC

--5 wähle alle kritischen abteilungen


--6
SELECT B.*
FROM Bestellungen B
WHERE zeitpunkt > CONVERT(DATETIME, '2023-10-19', 120)
INTERSECT
SELECT B2.*
FROM Bestellungen B2
WHERE B2.bestellung_id NOT IN (
    SELECT bestellungs_id
    FROM Bestellungen_Produkte
    GROUP BY bestellungs_id
    HAVING COUNT(produkt_id) < 2
);

--7
SELECT *
FROM Produkte P
JOIN Hersteller H ON H.hersteller_id = P.hersteller_id
WHERE P.gewicht >= ALL(SELECT gewicht FROM Produkte);




--NEUER VERSUCH

--das kann ich immer verwenden
SELECT P.*, H.name, H.adresse 
FROM Produkte P
JOIN Hersteller H ON H.hersteller_id = P.hersteller_id;

SELECT M.*, P.position_name
FROM Mitarbeiter M
JOIN Position P ON P.position_id = M.position_id;

SELECT B.*, BS.beschreibung
FROM Bestellungen B
JOIN Bestellungstatus BS ON B.bestellungstatus_id = BS.bestellungstatus_id;

SELECT B.*, A.abteilungsname, A.adresse
FROM Bestellungen B
JOIN Abteilung A ON A.abteilungs_id = B.abteilungs_id;



--1

-- select alle Bestellungen die mehr als ein Produkt haben und dessen günstiges produkt mehr als 100 kostet, die neusten



--1
SELECT B.*, BS.beschreibung, SUMME.Gesamtpreis
FROM Bestellungen B
JOIN Bestellungstatus BS ON B.bestellungstatus_id = BS.bestellungstatus_id
JOIN (
    SELECT BP.bestellungs_id, SUM(BP.anzahl * BP.preis_pro_einheit) AS Gesamtpreis
    FROM Bestellungen_Produkte BP
    GROUP BY BP.bestellungs_id
    HAVING SUM(BP.anzahl * BP.preis_pro_einheit) > 1000
) AS SUMME ON SUMME.bestellungs_id = B.bestellung_id;

--2

SELECT Produkte.*, H.name, H.adresse
FROM
 (SELECT P.produkt_id, P.produktname, hersteller_id
FROM Produkte P
WHERE P.gewicht < 5

EXCEPT

SELECT P2.produkt_id, P2.produktname,hersteller_id
FROM Lager L
JOIN Produkte P2 ON P2.produkt_id = L.produkt_id) AS Produkte

JOIN Hersteller H ON H.hersteller_id = Produkte.hersteller_id;

--3


SELECT DISTINCT K.vorname, K.name
FROM Kunden K, Bestellungen B, Bestellungen_Produkte BP, Produkte P, Hersteller H
WHERE P.produkt_id NOT IN (
    SELECT L.produkt_id
    FROM Lager L
    WHERE L.abteilungs_id = B.abteilungs_id
)
AND K.kunden_id = B.kunden_id
AND B.bestellung_id = BP.bestellungs_id
AND BP.produkt_id = P.produkt_id
AND P.hersteller_id = H.hersteller_id;

--4

SELECT TOP 1 K.name AS KundenName, B.*, BS.beschreibung
FROM Bestellungen B
JOIN Bestellungstatus BS ON B.bestellungstatus_id = BS.bestellungstatus_id
LEFT JOIN Kunden K ON B.kunden_id = K.kunden_id
WHERE B.bestellung_id IN (
	SELECT BP.bestellungs_id
	FROM Bestellungen_Produkte BP
	GROUP By BP.bestellungs_id
	HAVING COUNT(BP.bestellungs_id) > 1
	INTERSECT
	SELECT BP.bestellungs_id
	FROM Bestellungen_Produkte BP
	GROUP By BP.bestellungs_id
	HAVING Min(BP.preis_pro_einheit) > 100
)
ORDER BY zeitpunkt DESC

--5
SELECT K.name
FROM Kunden K
WHERE 'Storniert' = ANY (
    SELECT BS.beschreibung
    FROM Bestellungen B
	JOIN Bestellungstatus BS ON BS.bestellungstatus_id = B.bestellungstatus_id
	WHERE K.kunden_id = B.kunden_id
);

--6
SELECT B.*
FROM Bestellungen B
WHERE 'Apple' = ALL (
    SELECT H.name
    FROM Bestellungen_Produkte BP
	JOIN Produkte P ON BP.produkt_id = P.produkt_id
    JOIN Hersteller H ON P.hersteller_id = H.hersteller_id
    WHERE BP.bestellungs_id = B.bestellung_id
);

--7

SELECT A.abteilungs_id, A.abteilungsname, SUM(BP.anzahl * BP.preis_pro_einheit) AS Umsatz
FROM Abteilung A
JOIN Bestellungen B ON A.abteilungs_id = B.abteilungs_id
JOIN Bestellungen_Produkte BP ON B.bestellung_id = BP.bestellungs_id
GROUP BY A.abteilungs_id, A.abteilungsname

--8

SELECT mitarbeiter_id AS ID, vorname, name, 'Mitarbeiter' AS Typ
FROM Mitarbeiter

UNION

SELECT kunden_id AS ID, vorname, name, 'Kunde' AS Typ
FROM Kunden;

--9

SELECT B.*, BS.beschreibung
FROM Bestellungen B
JOIN Bestellungstatus BS ON B.bestellungstatus_id = BS.bestellungstatus_id
JOIN Abteilung A ON A.abteilungs_id = B.abteilungs_id
WHERE 5000 < (
	SELECT MAX(BP.preis_pro_einheit)
    FROM Bestellungen_Produkte BP
    WHERE BP.bestellungs_id = B.bestellung_id
	)
OR 100 < (
	SELECT MIN(BP.preis_pro_einheit)
    FROM Bestellungen_Produkte BP
    WHERE BP.bestellungs_id = B.bestellung_id
);

	
--10
SELECT M.name, P.position_name, A.abteilungsname
FROM Mitarbeiter M
JOIN Position P ON M.position_id = P.position_id
JOIN Abteilung A ON A.abteilungs_id = M.abteilungs_id;

--IN Hinzufügen SI UNION NACHMACHEN

SELECT A.abteilungs_id, A.abteilungsname, A.adresse, 'Keine Kunden' AS typ
FROM Abteilung A
LEFT JOIN Kunden K ON A.abteilungs_id = K.abteilungs_id
WHERE K.kunden_id IS NULL
UNION
SELECT A.abteilungs_id, A.abteilungsname, A.adresse, 'Keine Bestellungen' AS typ
FROM Abteilung A
LEFT JOIN Bestellungen B ON A.abteilungs_id = B.abteilungs_id
WHERE B.bestellung_id IS NULL;

SELECT *
FROM Lieferung L
WHERE L.lieferwagen_id IN (
	SELECT LW.lieferwagen_id
	FROM Lieferwagen LW
	WHERE LW.baujahr > 2000
	)

