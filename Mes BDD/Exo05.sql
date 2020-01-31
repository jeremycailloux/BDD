-- 1. Liste des mois des commandes, au format YYYY.MM, sans doublons
-- Avec SQL Server 2008
select distinct left(convert(nvarchar, OrderDate, 102), 7) from Orders
-- Avec SQL Server 2012
select format(OrderDate, 'yyyy.MM') from Orders

-- 2. Pour chaque produit, afficher le nom et le prix sans chiffre apr�s la virgule
-- Avec SQL Server 2008
select Name, convert (int, unitprice) as Prix from Product
-- Avec SQL Server 2012
select Name, format(unitprice, '.') as Prix from Product
 
-- 3. Cr�er une nouvelle cat�gorie, un nouveau produit de cette cat�gorie pour le fournisseur 1
-- et une nouvelle ligne de commande avec ce produit pour la commande 10248
-- Cr�ation d'une cat�gorie
declare @idCat as uniqueidentifier
set @idCat = newid() -- g�n�re un Guid
insert Category(CategoryId, Name)
values (@idCat, 'Friandises')

-- Cr�ation d'un produit de cette cat�gorie
insert Product (CategoryId, Name, SupplierId, UnitPrice, UnitsInStock)
values (@idCat, 'Confiture', 1, 3.90, 100)

-- Cr�ation d'une ligne de commande pour ce produit
insert OrderDetail (OrderId, ProductId, UnitPrice)
values (10248, IDENT_CURRENT('Product'), 3.90)

-- 4. Cr�er une table Shipping pour l'historique des livraisons des livreurs.
-- Elle doit comporter une cl� �trang�re vers la table Shipper et des champs 
-- pour la date et heure de livraison et le nombre d'objets livr�s
-- Sa cl� primaire doit �tre un entier dont la valeur est g�n�r�e automatiquement par une s�quence 
-- Ins�rer deux lignes dans cette table et v�rifier son contenu

-- Cr�ation de la s�quence
create�sequence�Seq2�start�with�1�increment�by�1
go

-- Cr�ation de la table
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
 
-- 5. Nombre d'adresses par r�gion pour le Royaume Uni (UK)
-- Afficher le nom de la r�gion et le nombre d'adresses,
-- en rempla�ant le nom de la r�gion par 'Aucune' pour les adresses sans r�gion
select isnull(region, 'Aucune') Region, count(*) NbAdresses
from Address
where Country = 'UK'
group by Region

