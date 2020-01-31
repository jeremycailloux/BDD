-- Exercie 10

-- 1. Créer une fonction ufn_MinDate qui renvoie la valeur minimale entre 2 dates. Si l'une des dates est nulle, renvoyer l'autre.
-- Tester cette fonction dans les différents cas

-- Création d'une fonction scalaire
drop function if exists ufn_MinDate
go

create function ufn_MinDate (@date1 date, @date2 date)
returns date
as
begin
	declare @result date
	select @result = 
	case
		when @date2 is null then @date1
		when @date1 is null then @date2
		when @date1 < @date2 then @date1
		else @date2
	end

	return @result
end

-- Appel de la fonction scalaire
select dbo.ufn_MinDate('2020-01-31', '2020-04-24')
select dbo.ufn_MinDate('2020-04-24', '2020-01-31')
select dbo.ufn_MinDate('2020-01-31', null)


-- 2. Créer une fonction ufn_LastCharIndex qui renvoie la dernière position d'un caractère dans une chaîne passés en paramètre. Si le caractère n'est pas trouvé, renvoyer 0.
-- Tester sur les noms des employés

/*
drop function if exists ufn_LastCharIndex
go
create function ufn_LastCharIndex (@chaine nvarchar)
returns date
as
begin
return 
end
go
*/

-- 4. Créer une fonction en ligne ufn_OrderInfos qui rassemble les infos des lignes de commandes et les infos principales d'une commande (différentes dates, id client, id du livreur, frais de livraison)
-- Tester la fonction sur la commande 10986

drop function if exists ufn_OrderInfos
go
create function ufn_OrderInfos (@OrderId integer)

returns table
as 
	return (select O.OrderId, O.OrderDate, O.RequiredDate, O.ShippedDate, CU.CustomerId, SH.ShipperId, O.Freight, OD.ProductId, OD.UnitPrice, OD.Quantity, OD.Discount
		from Orders O
		inner join Customer CU on(O.CustomerId = CU.CustomerId)
		inner join Shipper SH on(O.ShipperId = SH.ShipperId)
		inner join OrderDetail OD on(O.OrderId = OD.OrderId)
		where O.OrderId = @OrderId)
go

select * from ufn_OrderInfos(10986)

-- 5. Créer une procédure usp_DeleteProductsAndOrdersForSupplier permettant de supprimer :
-- * tous les produits provenant d'un fournisseur
-- * toutes les lignes de commandes référençant ces produits
-- * toutes les commandes contenant ces lignes, si elles ne contiennent plus aucune ligne
-- Tester la procédure sur le fournisseur d'id 7 (à l'intérieur d'une transaction pour pouvoir annuler) en vérifiant notamment que la commande 10265 est bien supprimée

-- Création d'une procédure stockée
drop procedure if exists usp_DeleteProductsAndOrdersForSupplier 
go
create procedure usp_DeleteProductsAndOrdersForSupplier @idFournisseur int
as
begin

-- Suppression des lignes de commandes
delete OD from OrderDetail OD
inner join Product P on(OD.ProductId = P.ProductId)
where P.SupplierId = @idFournisseur

-- Suppression des lignes de commandes
	delete from Orders 
	where OrderId not in (select distinct(OrderId) from OrderDetail)

-- Suppression des produits
	delete from Product
	where SupplierId = @idFournisseur

end
go


begin tran
exec usp_DeleteProductsAndOrdersForSupplier 7
rollback tran