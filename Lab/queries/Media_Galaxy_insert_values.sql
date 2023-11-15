-- Insert into Abteilung table
INSERT INTO Abteilung (abteilungsname, adresse)
VALUES
    ('Vivo Cluj-Napoca', 'Strada Avram Iancu 492-500, Cluj-Napoca 407280'),
    ('Brasov', 'Calea București 109, Brașov 500299'),
    ('Oradea Lotus', 'str. Nufărului, nr. 30, Complex Comercial Lotus, Oradea 410533');

-- Insert into Position table
INSERT INTO Position (position_name)
VALUES
    ('Abteilungsleiter'),
    ('Kassierer'),
    ('Service'),
    ('Kundenberatung'),
    ('Lieferant');

-- Insert into Mitarbeiter table
INSERT INTO Mitarbeiter (abteilungs_id, vorname, name, adresse, position_id)
VALUES
    (1, 'Bob', 'Cheffler', 'Hamburgerstraße 3', 1),
    (1, 'Dob', 'Dichter', 'Berlinerstraße 8', 4),
    (1, 'Mob', 'Schlosser', 'Münchnerstraße 1', 5),
    (2, 'Wilhelm', 'Kaiser', 'Mangoallee 3', 1),
    (2, 'David', 'Svistea', 'Pfirsichgasse 130', 3),
    (2, 'Manuel', 'Neuer', 'Apfelplatz 64', 5);

-- Insert into Kunden table
INSERT INTO Kunden (vorname, name, emailadresse)
VALUES
    ('Ioana', 'Klein', 'ik@gmail.com'),
    ('Maria', 'Groß', 'mg@web.de'),
    ('Steff', 'Mittel', 'ik@yahoo.com'),
    ('Mark', 'Streicher', 'ik@gmail.com');

-- Insert into Lieferwagen table
INSERT INTO Lieferwagen (marke, baujahr, abteilungs_id)
VALUES
    ('Honda', 1999, 1),
    ('Mercedes', 2010, 1),
    ('Nissan', 2002, 2),
    ('Iveco', 2015, 2);

-- Insert into Hersteller table
INSERT INTO Hersteller (name, adresse)
VALUES
    ('Apple', 'Applestraße 13'),
    ('Samsung', 'Samsaracluster 4'),
    ('Dell', 'Deltastraße 113'),
    ('Lenovo', 'Mirfalltnixeinstraße 2'),
	('Microsoft', 'Deinkraftstraße 33');

INSERT INTO Produkte (produktname, gewicht, hersteller_id)
VALUES
	('Smart TV', 20, 1),
    ('Gaming Laptop', 5, 2),
    ('iPhone 13', 0.2, 1),
    ('Xbox Series X', 4, 5),
    ('4K Monitor', 6, 2),
    ('Gaming Mouse', 0.15, 3),
    ('Bluetooth Kopfhörer', 0.3, 2),
    ('Smartphone Stand', 0.05, 1),
    ('PlayStation 5', 4, 4),
    ('External Hard Drive', 0.3, 2);

INSERT INTO Lager (produkt_id,abteilungs_id,anzahl)
VALUES
	(1,1,30),
	(2,1,50),
	(3,1,25),
	(4,1,48),
	(5,1,24),
	(6,1,54),
	(7,1,87),
	(8,1,53),

	(3,2,53),
	(4,2,54),
	(5,2,34),
	(6,2,8),
	(7,2,13),
	(8,2,41),
	(9,2,55),
	(10,2,66),

	(1,3,58),
	(2,3,52),
	(3,3,44),
	(4,3,41),
	(7,3,10),
	(8,3,76),
	(9,3,2),
	(10,3,5);

INSERT INTO Lieferung (lieferdatum, status, lieferwagen_id)
VALUES
  ('2023-10-18', 'Wird geliefert', 1),
  ('2023-10-19', 'Geliefert', 2),
  ('2023-10-20', 'Wird geliefert', 3),
  ('2023-10-21', 'Geliefert', 4);

INSERT INTO Bestellungstatus ( beschreibung )
VALUES
	('Bezahlt'),
	('In Bearbeitung'),
	('Abgeschlossen'),
	('Storniert');

INSERT INTO Bestellungen (kunden_id, abteilungs_id, lieferung_id, zeitpunkt, bestellungstatus_id)
VALUES
  (1, 1, 1, '20231018 10:00:00.000', 1),
  (2, 1, 2, '20231019 11:30:00.000', 3),
  (3, 2, 3, '20231020 14:15:00.000', 1),
  (4, 2, 4, '20231021 09:45:00.000', 3),
  (NULL, 3, NULL, '20231023 13:10:00.000', 3),
  (NULL, 3, NULL, '20231023 13:10:00.000', 3);

INSERT INTO Bestellungen_Produkte (bestellungs_id,produkt_id, anzahl, preis_pro_einheit)
VALUES
	(1,1,1,800),
	(1,6,2,50),
	(1,4,3,500),
	(1,2,2,1400),
	(2,3,1,1200),
	(2,4,2,500),
	(2,5,2,200),
	(3,7,1,20),
	(3,8,2,15),
	(4,2,1,1400),
	(4,1,1,800),
	(5,10,2,50),
	(5,9,1,500),
	(6,8,1,15);