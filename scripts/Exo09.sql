-- 1. Supprimer les lignes de commandes qui portent sur des produits
-- livrés par le fournisseur 'Ma maison'
-- (A faire dans une transaction pour pouvoir annuler la suppression)
begin tran
select COUNT(*) from OrderDetail

delete OD
from OrderDetail OD
inner join Product P on P.ProductID = OD.ProductID
inner join Supplier S on S.SupplierId = P.SupplierID 
where S.CompanyName = 'Ma maison'

select COUNT(*) from OrderDetail
rollback

--2. Appliquer un taux de réduction de 20% sur les lignes de commandes
-- des commandes livrées par le livreur 3
begin tran
update od
set Discount = 0.20
from OrderDetail od
inner join orders o on od.OrderId = o.OrderId
where o.ShipperId = 3
rollback

-- 3. Créer une table mémoire Produits avec les champs (id, nom, prix unitaire, qté en stock)
-- Insérer 5 produits dans cette table, dont 2 qui ont des Id déjà présents dans la table Product, et 3 nouveaux
-- Faire une requête qui met à jour la table Product à partir de la table Produits, en :
-- * mettant à jour le nom, le prix unitaire et la qté en stock si l'Id du produit existe déjà
-- * ajoutant les produits qui n'existent pas déjà
select * from Product order by ProductID

declare @SaisieProduit table (
ProdId int,
Nom nvarchar(40),
PU money,
Stock smallint,
CONSTRAINT SaisieProduit_PK PRIMARY KEY(ProdId)
);

insert @SaisieProduit (ProdId, Nom, PU, Stock) values
(76, 'Boisson gazeuse', 5.49, 20),
(77, 'Paquet de gateaux', 10.00, 40),
(81, 'Nouveau Produit 1', 4.60, 100),
(82, 'Nouveau Produit 2', 19.90, 100),
(83, 'Nouveau Produit 3', 35.50, 100)

begin tran
MERGE Product AS Cible
USING (SELECT ProdId, Nom, PU, Stock FROM @SaisieProduit) AS Source
ON (Cible.ProductId = Source.ProdId)
WHEN MATCHED THEN
    UPDATE SET
    Cible.ProductName = Source.Nom,
    Cible.UnitPrice = Source.PU,
    Cible.UnitsInStock = Source.Stock
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductName, UnitPrice, UnitsInStock) -- Le productId est en auto-incrément
    VALUES (Source.Nom, Source.PU, Source.Stock)
OUTPUT $action, Inserted.*; 
rollback tran

drop table @SaisieProduit