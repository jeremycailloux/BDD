-- Exercice 7

-- 1. Liste des clients (id, nom d'entreprise) qui n'ont jamais commandé un produit de la catégorie Condiments


select C1.CustomerId, C1.CompanyName from  Customer C1
where not exists
(select C2.CustomerId
from Orders O
inner join Customer C2 on(O.CustomerId = C2.CustomerId)
inner join OrderDetail OD on(O.OrderId = OD.OrderId)
inner join Product P on(OD.ProductId = P.ProductId)
where P.CategoryId = '6a921ad1-2cc8-4067-95b1-c3bc837999da' and C1.CustomerId = C2.CustomerId)


-- 2. Liste des pays pour lesquels il n'existe aucun fournisseur de produits de la catégorie Condiments

select distinct A1.Country from Address A1
where not exists
(select A2.Country
from Supplier SU
inner join Address A2 on(SU.AddressId = A2.AddressId)
inner join Product P on(SU.SupplierId = P.SupplierId)
inner join Category C on(P.CategoryId = C.CategoryId)
where P.CategoryId = '6a921ad1-2cc8-4067-95b1-c3bc837999da' and A1.Country = A2.Country)


-- 3. Liste des commandes contenant au moins un produit de la catégorie Seafood

select OD1.OrderId from OrderDetail OD1
where not exists(select OD2.OrderId
from Product P
inner join OrderDetail OD2 on(OD2.ProductId = P.ProductId)
where P.CategoryId != 'eb4e5f53-8711-4118-946e-f89e00615ec6' and OD1.OrderId = OD2.OrderId)

-- Faire cette requête de deux façons différentes
