-- Création d'un type table défini par l'utilisateur
drop type if exists TypeTableClient
go
create type TypeTableClient as table
(
	Id varchar(20) primary key,
	Nom nvarchar(100) not null
)
go

-- Création d'une table mémoire de ce type
declare @Cli as TypeTableClient

-- Insertion en masse dans cette table
insert into @Cli
select Customerid, CompanyName
from Customer C
inner join Address A on C.CustomerId = A.AddressId
where Country = 'France'

-- Mise à jour en masse
-- Correction des prix des lignes de commandes qui font référence
-- à des produits obsolètes
update od
set UnitPrice = p.UnitPrice
from OrderDetail od
inner join Product p on p.ProductID = od.ProductID 
where Discontinued = 1

-- Suppression en masse
-- Suppression des lignes de commandes portant sur des produits
-- qui ne sont plus approvisionnés
delete od
from OrderDetail od
inner join Product p on od.ProductID = p.ProductID
where p.Discontinued = 1

-- Rassemblement des opérations dans une requête merge

-- Création d'une table mémoire contenant les données à insérer ou mettre à jour
declare @SaisieTerritoire table (
TerId nvarchar(20) PRIMARY KEY,
Name nvarchar(50),
RegionId int
)

insert @SaisieTerritoire (TerId, Name, RegionId) values
('98052', 'Beauvais', 1),
('98104', 'Amiens', 1),
('99001', 'Nouveau territoire 1', 1),
('99002', 'Nouveau territoire 2', 1),
('99003', 'Nouveau territoire 3', 1)

-- On veut mettre à jour les 2 premiers territoires et créer les 3 autres
select * from Territory order by TerritoryID

-- Merge pour faire de la mise à jour si les données existent déjà dans la table
-- et de l'insertion sinon
-- NB/ La suppression est en commentaire, car dans le cas présent elle n'est pas
-- possible, car les territoires sont référencés par TerritoryEmployee
MERGE Territory AS Cible
USING (SELECT TerId, Name, RegionId FROM @SaisieTerritoire) AS Source
ON (Cible.TerritoryId = Source.TerId)
WHEN MATCHED THEN
    UPDATE SET Cible.Name = Source.Name, Cible.RegionId = Source.RegionId
WHEN NOT MATCHED BY TARGET THEN
    INSERT (TerritoryId, Name, RegionId)
    VALUES (Source.TerId, Source.Name, Source.RegionId)
--WHEN NOT MATCHED BY SOURCE THEN
--	delete 	
OUTPUT $action, Inserted.*;

-- CTE (common table expression)
with ClientFrance as (
select CustomerID, CompanyName, City, Country
from Customer C
inner join Address A on C.AddressId = A.AddressId
)
select CompanyName from ClientFrance where City = 'Paris'
