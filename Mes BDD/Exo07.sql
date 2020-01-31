-- 1. Liste des clients (id, nom d'entreprise) qui n'ont jamais commandé un produit de la catégorie Condiments
select CustomerID, CompanyName
from Customer C
where not exists (
	select 1
	from Orders O
	inner join OrderDetail OD on OD.OrderID = O.OrderID
	inner join Product P on OD.ProductID = P.ProductID
	where CategoryId = '6A921AD1-2CC8-4067-95B1-C3BC837999DA' and CustomerID = C.CustomerID
)
-- Etapes : on récupère toutes les commandes qui contiennent un produit de la catégorie demandée
-- puis on récupère les clients pour lesquels le résultat précédente est vide (avec not exists)
-- le lien entre la requête principale et la sous-requête se fait sur le CustomerId

-- Autre solution :
select CustomerID, CompanyName from Customer 
except
select C.CustomerID, CompanyName
from Customer C
inner join Orders O on O.CustomerID = C.CustomerID
inner join OrderDetail OD on OD.OrderID = O.OrderID
inner join Product P on OD.ProductID = P.ProductID
where CategoryId = '6A921AD1-2CC8-4067-95B1-C3BC837999DA'


-- 2. Liste des pays pour lesquels il n'existe aucun fournisseur de produits de la catégorie Condiments
select distinct A.Country
from Supplier S
inner join Address A on S.AddressId = A.AddressId
where not exists(
	select 1
	from  Product P
	where P.SupplierID = S.SupplierID and P.CategoryID = '6A921AD1-2CC8-4067-95B1-C3BC837999DA'
)

-- 3. Liste des commandes contenant au moins un produit de la catégorie Seafood
-- Faire cette requête de 3 façons différentes

-- Avec exists
select O.orderid, O.CustomerID
from Orders O where exists(
	select OD.ProductID
	from OrderDetail OD
	inner join Product P on OD.ProductID = P.ProductID
	where P.CategoryID = 'EB4E5F53-8711-4118-946E-F89E00615EC6' and OD.OrderID = O.OrderId
	)
order by OrderID

-- Avec except :
select orderid, CategoryId
from OrderDetail od
inner join Product P on od.ProductID = P.ProductID
except
select OD.OrderId, P.CategoryId
	from OrderDetail OD
	inner join Product P on OD.ProductID = P.ProductID
	where P.CategoryID != 'EB4E5F53-8711-4118-946E-F89E00615EC6'

-- Avec jointure interne (méthode la plus performante)
-- NB/ Le distinct est nécessaire, car une même commande peut contenir
-- plusieurs produits de la même catégorie
select distinct O.OrderID, O.CustomerID
from OrderDetail OD
inner join Product P on OD.ProductID = P.ProductID
inner join Orders O on OD.OrderID = O.OrderID
where P.CategoryID = 'EB4E5F53-8711-4118-946E-F89E00615EC6'

-- 4.Nombre de commandes et total des frais de port par année et mois
select distinct year(orderdate) Année, month(orderdate) Mois,
count(*) over(partition by year(orderdate), month(orderdate)) as 'Nb Commandes', 
sum(freight) over(partition by year(orderdate), month(orderdate)) as 'Frais de port'
from orders o
order by 1

-- 5. Liste des commandes contenant au moins 2 produits différents de même catégorie
-- en utilisant over

select distinct OrderID from (
SELECT OrderID
	   ,count(*) OVER(PARTITION BY OD.OrderId, P.CategoryId) as NbLignes
from OrderDetail OD
	inner join Product P on OD.ProductID = P.ProductID
) R
where NbLignes > 1

-- 6. lignes de la commande 10248 avec leurs montants, leurs quantités de produits
-- et les pourcentages de ces montants et quantités par rapport au total de la commande 
SELECT ProductID
		,Quantity * UnitPrice as Montant
	   ,Quantity * UnitPrice * 100 /
		SUM(Quantity * UnitPrice) OVER(PARTITION BY OrderID) AS [% montant commande]
		,Quantity as Quantité
		,Quantity * 100.0 / SUM(Quantity) OVER(PARTITION BY OrderID) AS [% qté totale]  
FROM OrderDetail
WHERE OrderID = 10248; 

-- 7. Palmarès des clients ayant passé le plus de commandes
select V.Client, V.Commandes,
	rank() over(order by V.Commandes desc) Rang
from (
	select C.CompanyName as Client,	count(*) as Commandes
	from Customer c
	inner join orders o on c.CustomerId = o.CustomerId
	group by C.CompanyName
) v
 
-- 8. Palmarès des clients ayant le plus de commandes par année
select Annee, V.CompanyName, NbCommandes,
RANK() over(partition by Annee order by NbCommandes desc) Classement
from (
select distinct Year(O.OrderDate) Annee, C.CompanyName,
		Count(*) over(partition by Year(O.OrderDate), C.CompanyName) NbCommandes
from Orders O
inner join Customer C on O.CustomerId = C.CustomerId
) V

-- 9. CA réalisé par chaque équipe représentée par son manager (une équipe = 1 manager + ses managés directs)
select ReportsTo as Manager, SUM(CA) as CA from
(
	(
		-- CA des salariés d'une même équipe, sans leur manager
		SELECT distinct E.ReportsTo, E.EmployeeID
				,FLOOR(SUM(Quantity * UnitPrice * (1-Discount)) OVER(PARTITION BY E.EmployeeID)) AS CA
		FROM OrderDetail OD
		inner join Orders O on OD.OrderID = O.OrderID 
		inner join Employee E on O.EmployeeID = E.EmployeeID
		where ReportsTo is not null
	)
	UNION
	(
		-- CA des managers
		select MAN.EmployeeID, MAN.EmployeeID
				,FLOOR(SUM(Quantity * UnitPrice * (1-Discount)))
		FROM OrderDetail OD
		inner join Orders O on OD.OrderID = O.OrderID 
		inner join Employee MAN on O.EmployeeID = MAN.EmployeeID
		where exists
		(select EmployeeID from Employee where ReportsTo = MAN.EmployeeID)
		group by MAN.EmployeeID
	)	
) R
group by ReportsTo

-- Solution plus élégante :
select emplo , SUM(ca)
from(
	select e1.ReportsTo mana, e1.ReportsTo emplo, SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) ca
	from Employee e1
	inner join Orders o on o.EmployeeID=e1.EmployeeID
	inner join OrderDetail od on od.OrderID=o.OrderID
	group by e1.ReportsTo
	union
	select e1.ReportsTo, e1.EmployeeID, SUM(od.Quantity*od.UnitPrice*(1-od.Discount))
	from Employee e1
	inner join Orders o on o.EmployeeID=e1.EmployeeID
	inner join OrderDetail od on od.OrderID=o.OrderID
	group by e1.ReportsTo,e1.EmployeeID
	) emp
group by emplo
having COUNT(ca)>1
