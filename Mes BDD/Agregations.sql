select count(*) from OrderDetail where ProductId = 5 --Nombre de commandes pour le produit 5
select sum(quantity) from Orderdetail where ProductId = 5 --Somme des commandes pour le produits 5
select sum(quantity*UnitPrice) from Orderdetail where ProductId = 5
select sum(quantity*UnitPrice) from Orderdetail where ProductId = 5
select floor(sum(quantity*UnitPrice)) from Orderdetail where ProductId = 5 -- Arrondi inf
select ceiling(sum(quantity*UnitPrice)) from Orderdetail where ProductId = 5 --Arrondi sup
select avg(quantity) from OrderDetail where ProductId = 5 --Moy de la quantité commandé
select max(quantity*UnitPrice) from OrderDetail --Produit qui a fait le plus gros chiffre d'affaire ou ligne de commande la plus élevée/chère
select count(distinct(ProductId)) from OrderDetail --Le nombre de produits distincts commandés
select avg(freight) from Orders --Frais de livraison moyens des commandes

select *
from Orders 
where Freight > (select avg(freight) from Orders) --Commande dont les frais de livraison sont supérieur à la moyenne des frais de livraison (sous requête)

--Nombre de commandes par produit (regroupement)
select ProductId, count(*) as nbCommandes
from OrderDetail
group by ProductId
order by ProductId -- productId est un alias

select ProductId, sum(Quantity) as nbExemplaires
from OrderDetail
group by ProductId
order by ProductId

--Nbre de commandes par employé
select EmployeeId, count(*) as nbCommandes --Ici on a une fonction d'agrégation
from Orders
group by EmployeeId

--Chiffre d'affaire de tous les produits classé par CA descendant
select top(10) ProductId, sum(quantity*UnitPrice) as CA 
from OrderDetail
group by ProductId
order by CA desc

--Liste des employés qui ont généré au moins 100 commandes
select EmployeeId, count(*) as NbCommandes
from Orders
group by EmployeeId
Having count(*) >= 100
order by NbCommandes desc --Classé par nombre de commande descendant
