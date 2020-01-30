-- 1. Ajouter ci-dessous le code de création d'une base nommée Ciqual
-- L'exécuter et en faire la base courante pour le script

CREATE DATABASE Ciqual
 ON  PRIMARY (NAME = Ciqual, FILENAME = N'C:\Users\Adminl\Desktop\Jeremy\BDD\Mes BDD\Ciqual.mdf')
 LOG ON (NAME = Ciqual_log, FILENAME = N'C:\Users\Adminl\Desktop\Jeremy\BDD\Mes BDD\Ciqual.ldf')
GO

USE Ciqual
GO


-- 2. A partir du MPD décrit dans le fichier Ciqual.pdf,
-- écrire ci-dessous le code SQL de création des tables de la base
-- avec les clés primaires, mais sans les clés étrangères.
-- Exécuter le code au fur et à mesure pour créer les tables une par une dans la base 

CREATE Table Aliment (
    IdAliment INTEGER NOT NULL, 
    Nom NVARCHAR(50) NOT NULL, 
    IdFamille INTEGER NOT NULL,
	CONSTRAINT Aliment_PK PRIMARY KEY(IdAliment)
)
GO

CREATE Table Famille (
    IdFamille INTEGER NOT NULL,
    Nom NVARCHAR(50),
    CONSTRAINT Famille_PK PRIMARY KEY(IdFamille)
)
GO

CREATE Table Composition (
   IdAliment INTEGER,
   IdConstituant INTEGER,
   ValeurMoy FLOAT NOT NULL,
   ValeurMin FLOAT NOT NULL,
   ValeurMax FLOAT NOT NULL,
   NoteConfiance CHAR NOT NULL,
   CONSTRAINT Composition_PK PRIMARY KEY(IdAliment, IdConstituant)
)
GO

CREATE Table Constituant (
    IdConstituant INTEGER NOT NULL,
    Nom NVARCHAR(4),
    Unite VARCHAR(4),
    CONSTRAINT Constituant_PK PRIMARY KEY(IdConstituant)
)
GO

-- 3. Ajouter ci-dessous le code de création des contraintes de clés étrangères
-- Exécuter le code au fur et à mesure pour créer les contraintes une par une dans la base
-- NB/ Si besoin, vous pouvez à tout moment supprimer et recréer la base puis son schéma

ALTER TABLE Composition ADD CONSTRAINT Composition_Aliment_FK
FOREIGN KEY(IdAliment) REFERENCES Aliment(IdAliment)
GO

ALTER TABLE Aliment ADD CONSTRAINT Aliment_Famille_FK
FOREIGN KEY(IdFamille) REFERENCES Famille(IdFamille)
GO

-- 4. Ajouter ci-dessous le code pour sauvegarder la base dans un fichier Ciqual.bak,
-- puis l'exécuter

backup database Ciqual to disk = N'C:\Users\Adminl\Desktop\Jeremy\BDD\backups\Ciqual.bak' with format

-- 5. Ajouter ci-dessous le code pour restaurer la sauvegarde créée précédemment.
-- L'exécuter et vérifier le schéma dans l'explorateur d'objets SQL Server

restore database Ciqual from disk = N'C:\Users\Adminl\Desktop\Jeremy\BDD\backups\Ciqual.bak' with replace

