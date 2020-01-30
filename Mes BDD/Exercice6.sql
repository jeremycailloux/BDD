-- Exercice 6

-- 1. Liste des régions et de leurs territoires
select R.RegionId, T.TerritoryId
from Territory T
inner join Region R on (T.RegionId = R.RegionId)

-- 2. Liste des livreurs (id et nom) qui ont livré des produits au Canada
select S.ShipperId, S.CompanyName, A.Country
from Shipper S
inner join Orders O on (S.ShipperId = O.ShipperId)
inner join OrderDetail OD on (O.OrderId = OD.OrderId)
inner join Product P on(OD.ProductId = P.ProductId)
inner join Supplier SU on(P.SupplierId = SU.SupplierId)
inner join Address A on(SU.AddressId = A.AddressId)
where A.Country = 'Canada'

-- 3. Nombre total de livraisons réalisées par chaque livreur (id, nom)
select S.ShipperId, S.CompanyName, count (ShippedDate)
from Orders O
inner join Shipper S on(S.ShipperId = O.ShipperId)
group by S.ShipperId, S.CompanyName
order by S.ShipperId

-- 4. Nombre de livraisons réalisées par le livreur Speedy Express dans chaque pays où il a livré

select S.CompanyName, A.Country, count (ShippedDate)
from Shipper S
inner join Orders O on(S.ShipperId = O.ShipperId)
inner join Address A on(O.AddressId = A.AddressId)
where S.CompanyName = 'Speedy Express'
group by S.CompanyName, A.Country
order by A.Country

-- 5. Montant des ventes réalisées pour chaque produit (Pour les produits sans vente associée, le montant des ventes vaut 0)

-- Création d'une nouvelle catégorie et d'un produit dont le montant des ventes associées vaut 0
declare @CategoryId as uniqueidentifier -- Category n'est pas auto-incrémenté, leur Id sont générés par Guid donc @....
set @CategoryId = newid()

insert Category (CategoryId, Name) 
values (@CategoryId, 'NewCat')

insert Product(CategoryId, SupplierId, Name, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
values (@CategoryId, 1, 'NewProduct', 1.50, 1000, 0, 1000, 0)

-- Réponse à la question
select distinct P.ProductId, P.Name, 
isNULL(sum(OD.UnitPrice*OD.Quantity), 0)
from OrderDetail OD
right outer join Product P on(OD.ProductId = P.ProductId)
group by P.ProductId, P.Name
order by P.ProductID

-- 6. Liste des commandes livrées en 2017 (id, date de livraison) avec leurs totaux, triées par date de livraison

select O.OrderId, O.ShippedDate,
sum(OD.UnitPrice*OD.Quantity)
from OrderDetail OD
inner join Orders O on(OD.OrderId = O.OrderId)
where year(O.ShippedDate) = 2017
group by O.OrderId, O.ShippedDate
order by O.OrderId, O.ShippedDate desc

-- 7. Chiffre d'affaire réalisé par chaque salarié

Select e.EmployeeId, e.FirstName, e.LastName, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) as ca from Employee e
	inner join Orders o
	on e.EmployeeId = o.EmployeeId
	inner join OrderDetail od
	on o.OrderId = od.OrderId
		group by e.EmployeeId, e.FirstName, e.LastName

-- 8. Montant des ventes de chaque salarié pour chacun des pays

Select e.EmployeeId, e.FirstName, e.LastName, a.Country, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) as ca from Employee e
	inner join Orders o
	on e.EmployeeId = o.EmployeeId
	inner join OrderDetail od
	on o.OrderId = od.OrderId
	inner join Address a
	on a.AddressId = o.AddressId
		group by e.EmployeeId, e.FirstName, e.LastName, a.Country