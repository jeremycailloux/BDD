-- 1. Ajouter ci-dessous le code de création d'une base nommée Ciqual
-- L'exécuter et en faire la base courante pour le script
CREATE DATABASE Ciqual
 ON  PRIMARY (NAME = Ciqual, FILENAME = N'C:\temp\BDD\bases\Ciqual.mdf')
 LOG ON (NAME = Ciqual_log, FILENAME = N'C:\temp\BDD\bases\Ciqual.ldf')
go
use Ciqual

-- 2. A partir du MPD décrit dans le fichier Ciqual.pdf,
-- écrire ci-dessous le code SQL de création des tables de la base
-- avec les clés primaires, mais sans les clés étrangères.
-- Exécuter le code au fur et à mesure pour créer les tables une par une dans la base 
CREATE TABLE Famille 
(
	IdFamille INTEGER NOT NULL, 
	Nom NVARCHAR(50) NOT NULL,
	CONSTRAINT Famille_PK PRIMARY KEY (IdFamille)
)

CREATE TABLE Aliment 
(
	IdAliment INTEGER NOT NULL, 
	Nom NVARCHAR(150) NOT NULL, 
	IdFamille INTEGER NOT NULL 
	CONSTRAINT Aliment_PK PRIMARY KEY (IdAliment)
)

CREATE TABLE Constituant 
(
	IdConstituant INTEGER NOT NULL, 
	Nom NVARCHAR(60) NOT NULL, 
	Unite VARCHAR(4) NOT NULL
	CONSTRAINT Constituant_PK PRIMARY KEY (IdConstituant)
)

CREATE TABLE Composition 
(
	IdAliment INTEGER NOT NULL, 
	IdConstituant INTEGER NOT NULL, 
	ValeurMoy FLOAT, 
	ValeurMin FLOAT, 
	ValeurMax FLOAT, 
	NoteConfiance CHAR 
	CONSTRAINT Composition_PK PRIMARY KEY (IdAliment, IdConstituant)
)

-- 3. Ajouter ci-dessous le code de création des contraintes de clés étrangères
-- Exécuter le code au fur et à mesure pour créer les contraintes une par une dans la base
-- NB/ Si besoin, vous pouvez à tout moment supprimer et recréer la base puis son schéma
ALTER TABLE Aliment ADD CONSTRAINT Aliment_Famille_FK
   FOREIGN KEY (IdFamille) REFERENCES Famille (IdFamille) 

ALTER TABLE Composition ADD CONSTRAINT Composition_Aliment_FK
	FOREIGN KEY (IdAliment) REFERENCES Aliment (IdAliment) 

ALTER TABLE Composition ADD CONSTRAINT Composition_Constituant_FK
	FOREIGN KEY (IdConstituant) REFERENCES Constituant (IdConstituant)

-- 4. Ajouter ci-dessous le code pour sauvegarder la base dans un fichier Ciqual.bak,
-- puis l'exécuter
--BACKUP DATABASE Ciqual TO DISK = 'D:\Databases\Backups\Ciqual.bak' WITH FORMAT


-- 5. Ajouter ci-dessous le code pour restaurer la sauvegarde créée précédemment.
-- L'exécuter et vérifier le schéma dans l'explorateur d'objets SQL Server
--RESTORE DATABASE Ciqual FROM DISK = 'D:\Databases\Backups\Ciqual.bak' WITH REPLACE
