-- nombre de lignes de commandes comportant le produit 5
select count(*)
from OrderDetail
where ProductID = 5

-- nombre total d'exemplaires commandés pour le produit 5 
select sum(Quantity)
from OrderDetail
where ProductID = 5

-- chiffre d'affaires généré par le produit 5 
select sum(Quantity * UnitPrice)
from OrderDetail
where ProductID = 5

-- idem arondi à l'entier inférieur (floor) ou supérieur (ceiling)
select floor(sum(Quantity * UnitPrice))
from OrderDetail
where ProductID = 5

-- valeur moyenne de la quantité commandée pour le produit 5
select avg(Quantity)
from OrderDetail
where ProductID = 5

-- Prix de la ligne de commande la plus chère
select max(Quantity * UnitPrice)
from OrderDetail

-- Nombre de produits différents commandés
select count(distinct ProductId)
from OrderDetail

-- Frais de livraison moyens des commandes
select avg(freight)
from Orders

-- commandes dont les frais de livraison sont supérieurs à la moyenne
select orderid, CustomerID, freight
from Orders
where Freight > (select avg(freight) from Orders)
order by 3

-------------------------------------------------------
-- Regroupements (group by, top et having)

-- nombre de commandes par produit
select productid, count(*) nb
from OrderDetail
group by productid

-- nombre total d'exemplaires commandés par produit
select ProductID, sum(Quantity) NbCommandés
from OrderDetail
group by ProductID
order by 2 desc

-- top 10 des produits ayant généré le plus de chiffre d'affaires
select top(10) ProductID, sum(Quantity * UnitPrice)
from OrderDetail
group by ProductID
order by 2 desc

-- nombre de commandes par employé
select EmployeeId, count(*) as NbCommandes
from Orders
group by EmployeeId
order by 1

-- Employés ayant généré au moins 100 commandesselect EmployeeId, count(*)
select EmployeeId, count(*)
from Orders
group by EmployeeId
having count(*) >= 100
order by 2 desc
 