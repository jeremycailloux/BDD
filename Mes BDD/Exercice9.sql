-- Exercice 9

-- 1. Supprimer les lignes de commandes qui portent sur des produits livrés par le fournisseur 'Ma maison' (à faire dans une transaction pour pouvoir annuler la suppression)

begin tran

delete OD 
from OrderDetail OD
inner join Product P on(OD.ProductId = P.ProductId)
inner join Supplier SU on(P.SupplierId = SU.SupplierId)
where SU.CompanyName = 'Ma maison'

rollback tran

-- Committ tran pour éxécuter la transaction

-- 2. Appliquer un taux de réduction de 20% sur les lignes des commandes livrées par le livreur 3

begin tran

update OD
set Discount = 0.2
from OrderDetail OD
inner join Orders O on(OD.OrderId = O.OrderId)
-- inner join Shipper SH on(O.ShipperId = SH.ShipperId)
where O.ShipperId = 3

rollback tran