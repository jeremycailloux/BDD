-- 1. Nombre de produits obsolètes
select count(*)
from Product
where Discontinued = 1

-- 2. Liste des produits (nom et prix) dont le prix est > la moyenne
SELECT DISTINCT Name, UnitPrice  
FROM Product
WHERE UnitPrice > (SELECT avg(UnitPrice) FROM Product)  
ORDER BY UnitPrice; 

-- 3. Produits qui ont fait l'objet de plus de 50 commandes (id produit et nb commandes)
select ProductID, COUNT(OrderID)
from OrderDetail
group by ProductID
having COUNT(OrderID) > 50

-- 4. Montant total de chaque commande, en tenant compte du % de réduction
select OrderID, 
    sum(UnitPrice * Quantity * (1 - Discount)) as Subtotal
from OrderDetail
group by OrderID
order by OrderID;

-- 5. Liste des clients distincts ayant passé des commandes
select distinct(CustomerId)
from Orders
order by 1

-- 6. Les trois employés ayant généré le plus de commandes (id employé, nb commandes)
select top 3 EmployeeId, count(*)
from Orders
group by EmployeeId
order by count(*) desc

-- 7. Nombre de pays différents parmi les adresses 
select count(distinct country)
from Address

-- 8. Pays représentés parmis les adresses par un nombre de villes compris entre 50 et 99 (nom pays, nb villes)
select country, count(city)
from Address
group by country
having count(city) between 50 and 99

-- 9. Pays des adresses pour lesquelles la région est renseignée (nom des pays sans doublons)
select distinct(Country)
from Address
where Region is not null

--10. Nombre de régions de chaque pays pour lequel il y a au moins une adresse 
-- dont la région est renseignée (noms pays, nb régions)
select Country, count(distinct(region))
from Address
where Region is not null
group by Country
order by 1
