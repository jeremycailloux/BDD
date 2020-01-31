-- nombre de lignes de commandes comportant le produit 5
select count(*)
from OrderDetail
where ProductID = 5

-- nombre total d'exemplaires command�s pour le produit 5 
select sum(Quantity)
from OrderDetail
where ProductID = 5

-- chiffre d'affaires g�n�r� par le produit 5 
select sum(Quantity * UnitPrice)
from OrderDetail
where ProductID = 5

-- idem arondi � l'entier inf�rieur (floor) ou sup�rieur (ceiling)
select floor(sum(Quantity * UnitPrice))
from OrderDetail
where ProductID = 5

-- valeur moyenne de la quantit� command�e pour le produit 5
select avg(Quantity)
from OrderDetail
where ProductID = 5

-- Prix de la ligne de commande la plus ch�re
select max(Quantity * UnitPrice)
from OrderDetail

-- Nombre de produits diff�rents command�s
select count(distinct ProductId)
from OrderDetail

-- Frais de livraison moyens des commandes
select avg(freight)
from Orders

-- commandes dont les frais de livraison sont sup�rieurs � la moyenne
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

-- nombre total d'exemplaires command�s par produit
select ProductID, sum(Quantity) NbCommand�s
from OrderDetail
group by ProductID
order by 2 desc

-- top 10 des produits ayant g�n�r� le plus de chiffre d'affaires
select top(10) ProductID, sum(Quantity * UnitPrice)
from OrderDetail
group by ProductID
order by 2 desc

-- nombre de commandes par employ�
select EmployeeId, count(*) as NbCommandes
from Orders
group by EmployeeId
order by 1

-- Employ�s ayant g�n�r� au moins 100 commandesselect EmployeeId, count(*)
select EmployeeId, count(*)
from Orders
group by EmployeeId
having count(*) >= 100
order by 2 desc
 