-- Cast et convert transforment un type en un autre

-- Les deux syntaxes suivantes sont équivalentes
select cast('2017-02-28' as date)
select convert(date, '2017-02-28')

-- Convert permet de spécifier en plus un style en 3ème paramètre,
-- ce qui est très utile pour les dates. La liste de styles est consultable sur
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql
-- Ex : conversion d'une date en chaîne au format français (24/02/1997)
select convert(nvarchar(30), OrderDate, 103) from Orders where orderid = 10455

-- Depuis SQL Server 2012, on a aussi les possibilités suivantes :
select TRY_CAST('2017-02-29' as date) -- renvoie NULL
select TRY_CONVERT(date, '2017-02-29') -- renvoie NULL
select format(OrderDate, 'd', 'fr') from Orders where orderid = 10455


------------------- Gestion des identifiants ----------------------------

----------------- avec des Guid ----------------------------
-- Création d'une adresse
declare @idAddr as uniqueidentifier
set @idAddr = newid() -- génère un Guid
insert Address (AddressId, Street, City, PostalCode, Country)
values (@idAddr, 'Rue Vistor Hugo', 'Paris', '75000', 'France') 

------------ avec un champ auto-incrémenté ----------------
-- Création d'une commande (OrderId est auto-incrémenté)
insert Orders(AddressId, CustomerID, EmployeeId, ShipperId, OrderDate)
values (@idAddr, 'ALFKI', 1, 1, GETDATE())

-- Récupération de la dernière valeur d'id créée
select cast(IDENT_CURRENT('Product') as int)
-- /!\ IDENT_CURRENT renvoie par défaut un décimal, même si le champ auto-incrémenté
-- est de type Int. Il est donc préférable de faire une conversion en int,
-- surtout si on récupère la valeur dans du code C#

-- Création d'une ligne de détail associée à la dernière commande
insert OrderDetail(OrderID, ProductID, UnitPrice)
values (IDENT_CURRENT('orders'), 1, 39)

-- Quand on supprime des lignes à la fin de la table, on peut forcer
-- l'auto-incrémentation à repartir de la valeur maxi des lignes restantes
-- de la façon suivante :
declare @id as int
select @id = max(OrderId) from Orders
DBCC CHECKIDENT ('Orders', RESEED, @id) 

----------------- avec une séquence ------------------------
-- Création d'une séquence
create sequence Seq1 start with 1 increment by 1
go

-- Utilisation de la séquence comme VPD de l'id d'une table
CREATE TABLE Personne  
(  
    Id int PRIMARY KEY CLUSTERED DEFAULT (NEXT VALUE FOR Seq1),  
    Nom nvarchar(40) NOT NULL,
    Prenom nvarchar(40) NOT NULL
)
go

insert Personne (Nom, Prenom) values
('Tournesol', 'Triphon'),
('Lampion', 'Séraphin'),
('Ben Salaad', 'Omar')
go
-- Les valeurs d'id sont automatiquement fournies par la séquence

select * from personne

-- Obtention de la prochaine valeur de la séquence
DECLARE @id int
SET @id = NEXT VALUE FOR Seq1

-- Contrairement à un id autoincrémenté, on peut affecter 
-- explicitement la valeur de l'id 
insert Personne (Id, Nom, Prenom) values
(@id, 'Castafiore', 'Bianca')

select * from personne
drop table Personne

-- Depuis SQL Server 2016 :
drop table if exists Personne
-- Fontionne avec table, vue, type, procédure, fonction...

------------------------ Divers ---------------------------------
-- isnull : remplace les valeurs null par une valeur par défaut
-- Très utile dans les calculs

-- Ex 1 : Sommme des frais de livraison des commandes
-- La 1ère requête renvoie NULL si une des valeurs est NULL
-- La 2de renvoie la somme même si des valeurs sont NULL
select sum(freight) from orders
select sum(isnull(freight, 0)) from orders

-- Ex 2 : Calcul du délai moyen de livraison en estimant
--  une valeur de 21j pour les commandes pas encore livrées
select avg(isnull(datediff(day, OrderDate, ShippedDate), 21) * 1.0)
from orders

-- coalesce renvoie la première expression non null parmi une liste
select EmployeeId, coalesce (ReportsTo, EmployeeId)
from Employee

-- Depuis SQL Server 2012 :
-- iif
select orderid, iif(ShippedDate <= RequiredDate, 'OK', 'Retard')
from Orders
where ShipCountry = 'France'

-- choose permet de choisir une valeur à partir d'un indice 
-- Le premier paramètre représente l'indice et doit être un entier
select * from Region
select RegionId, choose(RegionId, 'E', 'W', 'N', 'S') from region

