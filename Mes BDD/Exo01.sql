-- 1. Liste des produits avec leur quantité par unité
select Name, QuantityPerUnit
from Product

-- 2. Liste des produits (id et nom) abandonnés (discontinued = 1)
select ProductID, Name
 from Product where Discontinued = 1

-- 3. Liste des produits (noms et prix) triés par prix décroissant
 SELECT Name, UnitPrice   
FROM Product   
ORDER BY UnitPrice DESC;

-- 4. Liste des produits (id, nom et prix) qui coutent moins de $20
-- et qui sont encore vendus, triés du plus cher au moins cher
SELECT ProductID, Name, UnitPrice  
FROM Product  
WHERE (UnitPrice<20 AND Discontinued=0)  
ORDER BY UnitPrice DESC; 

-- 5. Liste des produits (nom et prix) encore vendus, compris entre $15 et $25
SELECT Name, UnitPrice  
FROM Product  
WHERE Discontinued=0 and UnitPrice between 15 and 25

-- 6. Liste des 10 produits les plus chers (id, nom et prix)
select top(10) ProductID, Name, unitprice
from Product
order by UnitPrice desc

-- 7. liste des produits actifs (nom, nombres en stock et en cours de commande)
-- dont le nombre en stock est < nombre en cours de commande
SELECT Name, UnitsOnOrder , UnitsInStock  
FROM Product  
WHERE Discontinued=0 AND UnitsInStock < UnitsOnOrder; 

-- 8. Liste des produits (id, nom) dont le nom contient au moins un espace
select ProductId, Name
from Product
where name like '% %'

-- 9. Liste des produits (id, nom) dont le nom contient un seul espace
select ProductId, Name
from Product
where name like '% %' and name not like '% % %'

-- 10. Liste des produits (id, nom) dont le nom contient une apostrophe
select ProductId, Name
from Product
where name like '%''%'

-- 11. Liste des produits (id, nom) dont le nom commence et finit par une voyelle
select ProductId, Name
from Product
where name like '[aeiouy]%[aeiouy]'