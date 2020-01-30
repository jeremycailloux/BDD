/* --------------------- Création / supression d'une base --------------------- */

-- Créer une base Essai avec les options par défaut
CREATE DATABASE Essai
 ON  PRIMARY (NAME = Essai, FILENAME = N'C:\Users\Adminl\Desktop\Jeremy\BDD\Mes BDD\Essai.mdf')
 LOG ON (NAME = Essai_log, FILENAME = N'C:\Users\Adminl\Desktop\Jeremy\BDD\Mes BDD\Essai.ldf')
GO

-- En faire la base courante pour le script
USE Essai

-- Supprimer une base si elle existe
-- Attention : il ne doit pas y avoir de connexion ouverte sur la base,
-- c'est pourquoi il faut changer de base courante avant de faire la suppression
--use MASTER
--DROP DATABASE IF EXISTS Essai

/* --------------------- Création / supression de tables --------------------- */

-- Créer une table avec ses colonnes et définir sa clé primaire
CREATE TABLE Categorie 
(
   IdCategorie UNIQUEIDENTIFIER NOT NULL, 
   Nom NVARCHAR(50) NOT NULL, 
	CONSTRAINT Categorie_PK PRIMARY KEY(IdCategorie)
)

CREATE TABLE Produit 
(
   IdProduit INTEGER NOT NULL, 
   IdCate UNIQUEIDENTIFIER NOT NULL, 
   Nom NVARCHAR(100) NOT NULL, 
   PU DECIMAL(6,2),
   CONSTRAINT Produit_PK PRIMARY KEY(IdProduit)
)
GO

-- Supprimer une table si elle existe
--DROP TABLE IF EXISTS Categorie

/* --------------- Création / supression de clés étrangères ---------------- */

-- Ajouter une contrainte de clé étrangère entre 2 tables
ALTER TABLE Produit ADD CONSTRAINT Produit_Categorie_FK
	FOREIGN KEY(IdCate) REFERENCES Categorie(IdCategorie)

-- Supprimer une contrainte de clé étrangère si elle existe
ALTER TABLE Produit DROP CONSTRAINT IF EXISTS Produit_Categorie_FK


/* Remarque :
On peut aussi créer les contraintes de clés étrangères en même temps que les tables,
à l'intérieur de l'instruction CREATE TABLE. Mais dans ce cas, 
il faut faire attention de créer les tables dans le bon ordre.
Il est donc plus simple de créer ces contraintes après avoir créé toutes les tables.
*/


backup database Essai to disk = N'C:\Users\Adminl\Desktop\Jeremy\BDD\backups\Essai.bak' with format
restore database Essai from disk = N'C:\Users\Adminl\Desktop\Jeremy\BDD\backups\Essai.bak' with replace