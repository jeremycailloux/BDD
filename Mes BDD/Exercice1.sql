--Exercice 1: Opérations de base, filtrage, tri

--Liste des produits avec leur quantité par unité
select QuantityPerUnit  from Product 
--Liste des produits (id et nom) abandonnés (discontinued = 1)
select ProductId, Name from Product where discontinued = 1
--Liste des produits (noms et prix) triés par prix décroissant
select UnitPrice, Name from Product order by UnitPrice desc
--Liste des produits (id, nom et prix) qui coutent moins de $20 et qui sont encore vendus, triés du plus cher au moins cher
select ProductId, Name, UnitPrice from Product where UnitPrice < 20 and discontinued != 1 order by UnitPrice desc
--Liste des produits (nom et prix) encore vendus, compris entre $15 et $25
select Name, UnitPrice from Product where discontinued != 1 and UnitPrice between 15 and 25
--Liste des 10 produits les plus chers (id, nom et prix)
select top(10) UnitPrice, ProductId, Name from Product
--Liste des produits actifs (nom, nombres en stock et en cours de commande) dont le nombre en stock est < nombre en cours de commande
select Name, UnitsInStock, UnitsOnOrder from Product where discontinued != 1
--Liste des produits (id, nom) dont le nom contient au moins un espace
select ProductId, Name from Product where Name not like ('% % %') and Name like ('% %')
--Liste des produits (id, nom) dont le nom contient un seul espace
select ProductId, Name from Product where Name like ('')
--Liste des produits (id, nom) dont le nom contient une apostrophe
select ProductId, Name from Product where Name like ('%''%')
--Liste des produits (id, nom) dont le nom commence et finit par une voyelle
select ProductId, Name from Product where Name like ('%[AEIOUY] [AEIOUY]%')
