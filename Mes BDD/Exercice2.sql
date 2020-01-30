--Exercice 2: Agrégation, regroupement

--Nombre de produits abandonnés
select count(*) as NbOfDiscountinued
from Product
where discontinued = 1

--Liste des produits (nom et prix) dont le prix est > la moyenne
select Name, UnitPrice 
from Product
where UnitPrice > (select avg(UnitPrice) from Product)
order by UnitPrice desc

--Produits qui ont fait l'objet de plus de 50 commandes (id produit et nb commandes)
select ProductId, count(OrderId) as NbCommandes
from OrderDetail
group by ProductId
having count(OrderId) > 50
order by ProductId, NbCommandes

--Montant total de chaque commande, en tenant compte du % de réduction
select OrderId, floor(sum((UnitPrice - UnitPrice*Discount)*Quantity)) as MontantCommande
from OrderDetail
group by OrderId
order by MontantCommande desc

--Liste des clients distincts ayant passé des commandes
select distinct(CustomerId), count (OrderId) as NbCommandes
from Orders
group by CustomerId
order by NbCommandes desc

--Les trois employés ayant généré le plus de commandes (id employé, nb commandes)
select EmployeeId, count (OrderId) as NbCommandes
from Orders
group by EmployeeId
order by NbCommandes desc

--Nombre de pays différents parmi les adresses
select count (distinct(Country)) as NbCountry
from Address

--Pays représentés parmi les adresses par un nombre de villes compris entre 50 et 99 (nom pays, nb villes)
select Country, count (City) as NbCity
from Address
group by Country
having count(City) between 50 and 99
order by NbCity desc

--Pays des adresses pour lesquelles la région est renseignée (noms des pays sans doublons)
select distinct(Country)
from Address
where Region is not null

--Idem précédent, en affichant les noms des pays et leurs nombres de régions distinctes
select Country, count (Region) as NbRegion
from Address
group by Country
having count(Region) > 0
order by NbRegion desc

select Country, count(distinct Region)
from Address
where Region is not null
group by Country






