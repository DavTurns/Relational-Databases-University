--reset tables
DROP TABLE Versions;
DROP TABLE CurrentVersion;


CREATE TABLE CurrentVersion(
	number INTEGER PRIMARY KEY
);


CREATE TABLE Versions(
	number INTEGER IDENTITY(1,1) PRIMARY KEY,
	procedureName varchar(30),
	parameter_1 varchar(30),
	parameter_2 varchar(100),
	parameter_3 varchar(30),
	parameter_4 varchar(30),
	parameter_5 varchar(30),
	parameter_6 varchar(30),
);

INSERT INTO CurrentVersion(number)
VALUES (0)
DROP TABLE T1;
DROP TABLE T2;
