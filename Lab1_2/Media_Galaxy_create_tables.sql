CREATE TABLE Abteilung (
  abteilungs_id INTEGER IDENTITY(1,1) PRIMARY KEY,
  abteilungsname VARCHAR(30),
  adresse VARCHAR(70)
);
CREATE TABLE Position (
  position_id INTEGER IDENTITY(1,1) PRIMARY KEY,
  position_name varchar(20)
);

CREATE TABLE Mitarbeiter (
  mitarbeiter_id INTEGER IDENTITY(1,1) PRIMARY KEY,
  abteilungs_id INTEGER,
  vorname VARCHAR(20),
  name VARCHAR(20),
  adresse VARCHAR(70),
  position_id INTEGER,
  FOREIGN KEY (abteilungs_id) REFERENCES Abteilung (abteilungs_id),
  FOREIGN KEY (position_id) REFERENCES Position (position_id)
);

CREATE TABLE Kunden (
  kunden_id INTEGER IDENTITY(1,1) PRIMARY KEY,
  vorname VARCHAR(20),
  name VARCHAR(20),
  emailadresse VARCHAR(30)
);

CREATE TABLE Lieferwagen (
  lieferwagen_id INTEGER IDENTITY(1,1) PRIMARY KEY,
  marke VARCHAR(20),
  baujahr INTEGER,
  abteilungs_id INTEGER,
  FOREIGN KEY (abteilungs_id) REFERENCES Abteilung (abteilungs_id)
);

CREATE TABLE Hersteller (
  hersteller_id INTEGER IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  adresse VARCHAR(70),
);

CREATE TABLE Produkte (
  produkt_id INTEGER IDENTITY(1,1) PRIMARY KEY,
  produktname VARCHAR(40),
  gewicht FLOAT,
  hersteller_id INTEGER,
  FOREIGN KEY (hersteller_id) REFERENCES Hersteller (hersteller_id)
);

CREATE TABLE Lager (
  produkt_id INTEGER,
  abteilungs_id INTEGER,
  anzahl INTEGER,
  PRIMARY KEY (produkt_id,abteilungs_id),
  FOREIGN KEY (produkt_id) REFERENCES Produkte (produkt_id),
  FOREIGN KEY (abteilungs_id) REFERENCES Abteilung (abteilungs_id)
);

CREATE TABLE Lieferung (
  lieferung_id INTEGER IDENTITY(1,1) PRIMARY KEY,
  lieferdatum DATE,
  status VARCHAR(20),
  lieferwagen_id INTEGER,
  FOREIGN KEY (lieferwagen_id) REFERENCES Lieferwagen (lieferwagen_id)
);

CREATE TABLE Bestellungstatus (
	bestellungstatus_id INTEGER IDENTITY(1,1) PRIMARY KEY,
	beschreibung VARCHAR(20)
);

CREATE TABLE Bestellungen (
  bestellung_id INTEGER IDENTITY(1,1) PRIMARY KEY,
  kunden_id INTEGER,
  abteilungs_id INTEGER,
  lieferung_id INTEGER,
  zeitpunkt DATETIME,
  bestellungstatus_id INTEGER
  FOREIGN KEY (kunden_id) REFERENCES Kunden (kunden_id),
  FOREIGN KEY (abteilungs_id) REFERENCES Abteilung (abteilungs_id),
  FOREIGN KEY (lieferung_id) REFERENCES Lieferung (lieferung_id),
  FOREIGN KEY (bestellungstatus_id) REFERENCES Bestellungstatus (bestellungstatus_id),
);

CREATE TABLE Bestellungen_Produkte (
  bestellungs_id INTEGER,
  produkt_id INTEGER,
  anzahl INTEGER,
  preis_pro_einheit Float,
  PRIMARY KEY (bestellungs_id, produkt_id),
  FOREIGN KEY (produkt_id) REFERENCES Produkte (produkt_id),
  FOREIGN KEY (bestellungs_id) REFERENCES Bestellungen (bestellung_id)
);



