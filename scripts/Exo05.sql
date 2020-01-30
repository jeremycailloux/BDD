-- 1. Liste des mois des commandes, au format YYYY.MM, sans doublons
-- Avec SQL Server 2008
select distinct left(convert(nvarchar, OrderDate, 102), 7) from Orders
-- Avec SQL Server 2012
select format(OrderDate, 'yyyy.MM') from Orders

-- 2. Pour chaque produit, afficher le nom et le prix sans chiffre après la virgule
-- Avec SQL Server 2008
select Name, convert (int, unitprice) as Prix from Product
-- Avec SQL Server 2012
select Name, format(unitprice, '.') as Prix from Product
 
-- 3. Créer une nouvelle catégorie, un nouveau produit de cette catégorie pour le fournisseur 1
-- et une nouvelle ligne de commande avec ce produit pour la commande 10248
-- Création d'une catégorie
declare @idCat as uniqueidentifier
set @idCat = newid() -- génère un Guid
insert Category(CategoryId, Name)
values (@idCat, 'Friandises')

-- Création d'un produit de cette catégorie
insert Product (CategoryId, Name, SupplierId, UnitPrice, UnitsInStock)
values (@idCat, 'Confiture', 1, 3.90, 100)

-- Création d'une ligne de commande pour ce produit
insert OrderDetail (OrderId, ProductId, UnitPrice)
values (10248, IDENT_CURRENT('Product'), 3.90)

-- 4. Créer une table Shipping pour l'historique des livraisons des livreurs.
-- Elle doit comporter une clé étrangère vers la table Shipper et des champs 
-- pour la date et heure de livraison et le nombre d'objets livrés
-- Sa clé primaire doit être un entier dont la valeur est générée automatiquement par une séquence 
-- Insérer deux lignes dans cette table et vérifier son contenu

-- Création de la séquence
create sequence Seq2 start with 1 increment by 1
go

-- Création de la table
create table Shipping
(
	Id int primary key DEFAULT (NEXT VALUE FOR Seq2), 
	ShipperId int not null,
	ShipDate DateTime not null,
	ItemsCount int not null default 0,
	CONSTRAINT Shipping_Shipper_FK FOREIGN KEY(ShipperId)
		REFERENCES Shipper(ShipperId)
)
go

-- Insertion de deux lignes
insert Shipping (ShipperId, ShipDate, ItemsCount) values
(3, '2018-04-29', 2),
(1, '2018-04-30', 3)

select * from Shipping
 
-- 5. Nombre d'adresses par région pour le Royaume Uni (UK)
-- Afficher le nom de la région et le nombre d'adresses,
-- en remplaçant le nom de la région par 'Aucune' pour les adresses sans région
select isnull(region, 'Aucune') Region, count(*) NbAdresses
from Address
where Country = 'UK'
group by Region

