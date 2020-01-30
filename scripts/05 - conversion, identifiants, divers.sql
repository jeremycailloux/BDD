------------------------------------------------------------
-- Cast et convert transforment un type en un autre

-- Les deux syntaxes suivantes sont �quivalentes
select cast('2017-02-28' as date)
select convert(date, '2017-02-28')

-- Convert permet de sp�cifier en plus un style en 3�me param�tre,
-- ce qui est tr�s utile pour les dates. La liste de styles est consultable sur
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql
-- Ex : conversion d'une date en cha�ne au format fran�ais (24/02/1997)
select convert(nvarchar(30), OrderDate, 103) from Orders where orderid = 10455

-- Depuis SQL Server 2012, on a aussi les possibilit�s suivantes :
select TRY_CAST('2017-02-29' as date) -- renvoie NULL
select TRY_CONVERT(date, '2017-02-29') -- renvoie NULL
select format(OrderDate, 'd', 'fr') from Orders where orderid = 10455


------------------- Gestion des identifiants ----------------------------

----------------- avec des Guid ----------------------------
-- Cr�ation d'une adresse
declare @idAddr as uniqueidentifier
set @idAddr = newid() -- g�n�re un Guid
insert Address (AddressId, Street, City, PostalCode, Country)
values (@idAddr, 'Rue Vistor Hugo', 'Paris', '75000', 'France') 

------------ avec un champ auto-incr�ment� ----------------
-- Cr�ation d'une commande (OrderId est auto-incr�ment�)
insert Orders(AddressId, CustomerID, EmployeeId, ShipperId, OrderDate)
values (@idAddr, 'ALFKI', 1, 1, GETDATE())

-- R�cup�ration de la derni�re valeur d'id cr��e
select cast(IDENT_CURRENT('Product') as int)
-- /!\ IDENT_CURRENT renvoie par d�faut un d�cimal, m�me si le champ auto-incr�ment�
-- est de type Int. Il est donc pr�f�rable de faire une conversion en int,
-- surtout si on r�cup�re la valeur dans du code C#

-- Cr�ation d'une ligne de d�tail associ�e � la derni�re commande
insert OrderDetail(OrderID, ProductID, UnitPrice)
values (IDENT_CURRENT('orders'), 1, 39)

-- Quand on supprime des lignes � la fin de la table, on peut forcer
-- l'auto-incr�mentation � repartir de la valeur maxi des lignes restantes
-- de la fa�on suivante :
declare @id as int
select @id = max(OrderId) from Orders
DBCC CHECKIDENT ('Orders', RESEED, @id) 

----------------- avec une s�quence ------------------------
-- Cr�ation d'une s�quence
create�sequence�Seq1�start�with�1�increment�by�1
go

-- Utilisation de la s�quence comme VPD de l'id d'une table
CREATE TABLE Personne  
(  
    Id int PRIMARY KEY CLUSTERED DEFAULT (NEXT VALUE FOR Seq1),  
    Nom nvarchar(40) NOT NULL,
    Prenom nvarchar(40) NOT NULL
)
go

insert Personne (Nom, Prenom) values
('Tournesol', 'Triphon'),
('Lampion', 'S�raphin'),
('Ben Salaad', 'Omar')
go
-- Les valeurs d'id sont automatiquement fournies par la s�quence

select * from personne

-- Obtention de la prochaine valeur de la s�quence
DECLARE @id int
SET @id = NEXT VALUE FOR Seq1

-- Contrairement � un id autoincr�ment�, on peut affecter 
-- explicitement la valeur de l'id 
insert Personne (Id, Nom, Prenom) values
(@id, 'Castafiore', 'Bianca')

select * from personne
drop table Personne

-- Depuis SQL Server 2016 :
drop table if exists Personne
-- Fontionne avec table, vue, type, proc�dure, fonction...

------------------------ Divers ---------------------------------
-- isnull : remplace les valeurs null par une valeur par d�faut
-- Tr�s utile dans les calculs

-- Ex 1 : Sommme des frais de livraison des commandes
-- La 1�re requ�te renvoie NULL si une des valeurs est NULL
-- La 2de renvoie la somme m�me si des valeurs sont NULL
select sum(freight) from orders
select sum(isnull(freight, 0)) from orders

-- Ex 2 : Calcul du d�lai moyen de livraison en estimant
--  une valeur de 21j pour les commandes pas encore livr�es
select avg(isnull(datediff(day, OrderDate, ShippedDate), 21) * 1.0)
from orders

-- coalesce renvoie la premi�re expression non null parmi une liste
select EmployeeId, coalesce (ReportsTo, EmployeeId)
from Employee

-- Depuis SQL Server 2012 :
-- iif
select orderid, iif(ShippedDate <= RequiredDate, 'OK', 'Retard')
from Orders
where ShipCountry = 'France'

-- choose permet de choisir une valeur � partir d'un indice 
-- Le premier param�tre repr�sente l'indice et doit �tre un entier
select * from Region
select RegionId, choose(RegionId, 'E', 'W', 'N', 'S') from region
