-- 1. Liste des régions et de leurs territoires
select R.RegionID, R.Name, T.Name
from Region R
inner join Territory T on R.RegionID = T.RegionID

-- 2. Liste des livreurs (id et nom) qui ont livré des produits au Canada
select distinct S.ShipperID, S.CompanyName
from Shipper S
inner join Orders O on S.ShipperID = o.ShipperId
inner join Address A on O.AddressId = A.AddressId
where A.Country = 'Canada'

-- 3. Nombre total de livraisons réalisées par chaque livreur (id, nom)
select O.ShipperId, CompanyName, count(OrderID)
from orders O
inner join Shipper S on S.ShipperID = O.ShipperId
group by O.ShipperId, CompanyName

-- 4. Nombre de livraisons réalisées par le livreur Speedy Express
-- dans chaque pays où il a livré
select A.Country, count(orderid) NbLivraisons
from Orders O
inner join Shipper S on S.ShipperID = o.ShipperId
inner join Address A on O.AddressId = A.AddressId
where S.CompanyName = 'Speedy Express'
group by A.Country

-- 5. Montant des ventes réalisées pour chaque produit
-- (Pour les produits sans vente associée, le montant des ventes vaut 0)
select  P.ProductID, P.Name, isnull(sum (OD.unitPrice * OD.Quantity * (1 - Discount)), 0)
from Product P
left outer join OrderDetail OD on P.ProductID = OD.ProductID
group by P.ProductID, P.Name

-- 6. Liste des commandes livrées en 2017 (id, date de livraison) avec leurs totaux,
-- triées par date de livraison
select O.OrderId, O.ShippedDate, sum(UnitPrice * Quantity * (1 - Discount))
 from orders O
inner join OrderDetail OD on (O.OrderID = OD.OrderID)
where year(O.ShippedDate) = 2017
group by O.OrderId, O.ShippedDate
order by O.ShippedDate

-- 7. Chiffre d'affaire réalisé par chaque salarié
select E.EmployeeID, E.FirstName, E.LastName, sum(UnitPrice * Quantity * (1-Discount))
from Employee E
inner join Orders O on E.EmployeeID = O.EmployeeID
inner join OrderDetail OD on O.OrderID = OD.OrderID
group by E.EmployeeID, E.FirstName, E.LastName
order by 1 

-- 8. Montant des ventes de chaque salarié dans chacun des pays
select E.EmployeeID, E.FirstName, E.LastName, A.Country,
	 floor(sum(UnitPrice * Quantity * (1-Discount)))
from Employee E
inner join Orders O on E.EmployeeID = O.EmployeeID
inner join OrderDetail OD on O.OrderID = OD.OrderID
inner join Address A on O.AddressId = A.AddressId
group by E.EmployeeID, E.FirstName, E.LastName, A.Country
order by 1 

-- 9. Chiffre d'affaire réalisé pour chaque client français (même si = 0, et arrondi à l'entier <)
select C.CustomerID, C.CompanyName,
	isnull(FLOOR(sum(UnitPrice * Quantity * (1 - Discount))), 0) CA
 from Customer C
left outer join orders O on (O.CustomerID = C.CustomerID)
left outer join OrderDetail OD on (O.OrderID = OD.OrderID)
inner join Address A on C.AddressId = A.AddressId
where Country = 'France'
group by C.CustomerID, C.CompanyName
order by 2

-- 10. chiffre d'affaire par catégorie de produit et par trimestre sur l'année 2017
select C.Name, 
    DATEPART(quarter, O.ShippedDate) as Trimestre,
    sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) as Ventes
from Category C
inner join Product P on C.CategoryID = P.CategoryID
inner join OrderDetail OD on P.ProductID = OD.ProductID
inner join Orders O on O.OrderID = OD.OrderID
where year(O.ShippedDate) = 2017
group by C.Name, DATEPART(quarter, O.ShippedDate)
order by C.Name, Trimestre

-- 11. Liste des employés qui ont au moins 2 supérieurs hiérarchiques
-- solution la plus simple et la plus performante :
select e.EmployeeID, e.FirstName, e.LastName
from employee e
inner join Employee m on e.ReportsTo = m.EmployeeId
where m.ReportsTo is not null

-- autre solution avec une sous-requête
select EmployeeID, FirstName, LastName
from Employee e
where
(select ReportsTo from Employee where EmployeeID = e.ReportsTo) is not null

-- 12. Liste des commandes qui contiennent le produit le plus vendu, c'est à dire
-- dont la quantité totale vendue est la plus grande 
select o.OrderID, o.OrderDate
from Orders o
inner join OrderDetail od on od.OrderID = o.OrderID
where od.ProductId = 
(
	select top(1) ProductID
	from OrderDetail
	group by ProductID
	order by SUM(Quantity) desc
)

-- 13. Commandes comportant au moins un produit fourni par un fournisseur français
select distinct o.OrderID, o.OrderDate
from OrderDetail od
inner join Product p on p.ProductID = od.ProductID
inner join Supplier s on s.SupplierID = p.SupplierID
inner join Orders o on od.OrderID = o.OrderID
inner join Address A on S.AddressId = A.AddressId
where A.Country = 'France'

-- 14. Id des commandes qui contiennent plusieurs lignes de produits de même catégorie
-- (Faire la requête de 2 façons différentes, dont l'une qui utilise OVER)
select distinct OrderID
from OrderDetail OD
inner join Product P on OD.ProductID = P.ProductID
group by OrderID, P.CategoryID
having count(*) > 1
order by 1


-- 15. Nombre de salariés couvrant chaque région
select RegionID, count(*) NbSalariés
from EmployeeTerritory ET
inner join Territory T on ET.TerritoryID = T.TerritoryID
group by RegionID

-- 16. Il serait bon de vérifier que la requête précédente fonctionne
-- si un salarié couvre des territoires de régions différentes.
-- Pour cela, faire les étapes suivantes :

-- a. Afficher le nombre de territoires couverts par personne pour chaque région
-- (trié selon les personnes)
select E.LastName, T.RegionID, count(*) NbTerritoires
from EmployeeTerritory ET
	inner join Territory T on ET.TerritoryID = T.TerritoryID
	inner join Employee E on ET.EmployeeID = E.EmployeeID
group by E.LastName, T.RegionID
order by 1

-- b. Faire en sorte que le salarié d'id 1 couvre aussi le territoire 48084
-- puis exécuter de nouveau la requête précédente pour vérifier le résultat
insert EmployeeTerritory(EmployeeID, TerritoryID) values (1, 48084)

-- c. Exécuter de nouveau la requête initiale pour vérifier le résultat

-- 17. Créer une vue qui représente un catalogue des produits avec leurs catégories
-- et les noms et pays de leurs fournisseurs
--drop view vwProduits
Go
create view vwProduits as (
select P.ProductID, P.Name ProductName, P.SupplierID, P.CategoryID, P.QuantityPerUnit,
P.UnitPrice, P.UnitsInStock, P.UnitsOnOrder, P.ReorderLevel, P.Discontinued,
C.Name, S.CompanyName as SupplierName, A.Country
from Product P
inner join Category C on P.CategoryID = C.CategoryID
inner join Supplier S on P.SupplierID = S.SupplierID
inner join Address A on S.AddressId = A.AddressId
)
GO

-- 18. Créer une vue qui rassemble les infos des lignes de commandes
-- et les infos principales des commandes (différentes dates, id client, id du livreur, frais de livraison)
--drop view vwCommandes
create view vwCommandes as (
select O.OrderID, OD.ProductID, O.CustomerID, O.ShipperId, O.OrderDate, O.RequiredDate, O.ShippedDate, O.Freight
from Orders O
inner join OrderDetail OD on (OD.OrderID = O.OrderID)
inner join Customer C on (O.CustomerID = C.CustomerID)
)
GO

-- 19. Utiliser ces 2 vues pour afficher les détails de la commande 10531 du client dont l'id est OCEAN
select VC.OrderDate, VC.RequiredDate, VC.ShippedDate, VC.Freight,
		VP.Name, VP.Name, VP.QuantityPerUnit, VP.UnitPrice, VP.UnitsInStock, Vp.UnitsOnOrder,
		VP.SupplierName, VC.ShipperId
from vwCommandes VC
inner join vwProduits VP on (VC.ProductID = VP.ProductID)
where CustomerID = 'OCEAN' and OrderID = 10531

-- 20. Liste des mois qui n'ont aucune commande pour le produit 'Tofu'
select distinct year(OrderDate) année, month(OrderDate) mois
from Orders
except
select year(OrderDate), month(OrderDate)
from Orders O
inner join OrderDetail OD on (O.OrderID = OD.OrderID)
inner join Product P on OD.ProductId = P.ProductId
where p.Name = 'Tofu'

-- Autre solution :
select distinct format(OrderDate, 'yyyy.MM')
from Orders
where format(OrderDate, 'yyyy.MM') not in
	-- sous requête qui ramène les mois des commandes avec Tofu
	(select  format(OrderDate, 'yyyy.MM')
	from Orders O
		inner join OrderDetail OD on (O.OrderID = OD.OrderID)
		inner join Product P on OD.ProductId = P.ProductId
	where p.Name = 'Tofu')
   
-- NB/ avec SQL Server 2008, on peut remplacer format par 
-- left(convert(nvarchar, OrderDate, 102), 7)
