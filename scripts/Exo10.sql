-- 1. Créer une fonction ufn_MinDate qui renvoie la valeur minimale entre 2 dates
-- Si l'une des dates est nulle, renvoyer l'autre
-- Tester cette fonction dans les différents cas

drop function if exists ufn_MinDate
GO

Create FUNCTION ufn_MinDate
(	
	@d1 DateTime,
    @d2 DateTime
)
RETURNS DateTime
AS
BEGIN
	RETURN
	(Case 
	   when @d1 is null THEN @d2
	   when @d2 is null THEN @d1
	   when @d1 < @d2 THEN @d1
	   ELSE @d2
	 END)
END
GO

select dbo.ufn_MinDate ('2018-05-01', '2017-06-08')

-- 2. créer une fonction ufn_LastCharIndex qui renvoie la dernière position 
-- d'un caractère dans une chaîne passés en paramètre
-- Si le caractère n'est pas trouvé, renvoyer 0
drop function if exists ufn_LastCharIndex
GO
CREATE FUNCTION ufn_LastCharIndex(@pattern char, @source nvarchar(max))   
RETURNS int 
AS  
BEGIN
	declare @first int
	set @first = CHARINDEX(@pattern, REVERSE(@source))
	return iif(@first > 0, len(@source) - @first  + 1, 0) 
END 
GO

select dbo.ufn_LastCharIndex('l', LastName), LastName
 from Employee

-- 3. Créer une procédure usp_ProductInfos qui regroupe les informations principales d'un produit
-- avec sa catégorie, et le nom et le pays de son fournisseur
-- Tester la procédure sur le produit 58

--drop procedure usp_ProductInfos
--go
create procedure usp_ProductInfos @IdProduit integer
as
begin
	select p.Name,p.UnitPrice, p.UnitsInStock, p.UnitsOnOrder,
		s.CompanyName Supplier, a.Country SupplierCountry, c.Name
	from Product p
	inner join Supplier s on p.SupplierID = s.SupplierID
	inner join Address a on s.AddressId = a.AddressId
	inner join Category c on p.CategoryID = c.CategoryID
	where p.ProductID = @IdProduit
end
go

-- 4. Créer une fonction en ligne ufn_OrderInfos qui rassemble les infos des lignes de commandes
-- et les infos principales d'une commande (différentes dates, id client, id du livreur, frais de livraison)
-- Tester la fonction sur la commande 10986

--drop function ufn_OrderInfos
--go

create function ufn_OrderInfos(@IdCmde integer)
returns table
as
	return select c.CustomerID, od.UnitPrice, od.Quantity, od.Discount,
	o.OrderDate, o.RequiredDate, o.ShippedDate,
	s.ShipperID, s.CompanyName ShipperName, o.Freight
	from OrderDetail od
	inner join orders o on od.OrderID = o.OrderID
	inner join Customer c on o.CustomerID = c.CustomerID
	inner join Shipper s on o.ShipperId = s.ShipperID
	where o.OrderID = @IdCmde
go

-- 5. Créer une procédure usp_DeleteProductAndOrdersForSupplier permettant de supprimer :
-- * tous les produits provenant d'un fournisseur
-- * toutes les lignes de commandes référençant ces produits
-- * toutes les commandes qui ne contiennent plus aucune ligne

-- Tester la procédure sur le fournisseur d'id 7 (à l'intérieur d'une transaction pour pouvoir annuler)
-- en vérifiant notamment que la commande 10265 est bien supprimée

--drop procedure usp_DeleteProductAndOrdersForSupplier
go
create procedure usp_DeleteProductAndOrdersForSupplier @SuppId int
as
begin
	-- Suppression des lignes de commandes
	delete od
	from OrderDetail od
	inner join Product p on od.ProductID = p.ProductID
	where p.SupplierID = @SuppId

	-- Suppression des commandes sans lignes
	-- NB/ On ne peut pas faire de suppression de masse avec jointure
	-- vers les lignes de commandes et fournisseurs
	-- car les lignes de commandes ont été supprimées
	delete o
	from orders o
	where not exists (select OrderId from OrderDetail where OrderID = o.OrderID)

	-- Suppression des produits
	delete from Product where SupplierID = @SuppId
end

-- Test
begin tran
exec usp_DeleteProductAndOrdersForSupplier 7
rollback

-- 6. Créer une procédure stockée de type table renvoyant les id des
-- commandes qui ne comportent que des produits issus d'un même fournisseur
go
create procedure usp_CommandesProduitsMemeFournisseur
as
begin
	select od.OrderID
	from OrderDetail od
	inner join Product p on od.ProductID = p.ProductID
	group by od.OrderID
	having count(distinct p.SupplierId) = 1
end
go	

-- Pour le fun : commandes pour lesquels il y a au moins 2 produits du même fournisseur
-- select od.OrderID, count(*) nbLignes, count(distinct p.SupplierId) nbFournisseurs
-- from OrderDetail od
-- inner join Product p on od.ProductID = p.ProductID
-- group by OrderID
-- having count(*) > 1 and count(distinct p.SupplierId) = 1

-- 7. récupérer les id et noms des clients qui ont passé les commandes
-- dont les id sont renvoyés par la procédure créée précédemment

-- On ne peut pas faire de requête directement sur le résultat d'une procédure stockée
-- Il faut récupérer le résultat dans une table au moyen de la syntaxe suivante :
declare @TableId table (
	Id int primary key)

insert @TableId exec usp_CommandesProduitsMemeFournisseur

-- On peut ensuite faire ce qu'on veut avec cette table
select c.CustomerID, c.CompanyName
from @TableId t
inner join Orders o on o.OrderID = t.Id
inner join Customer c on c.CustomerID = o.CustomerID

-- S'il n'y a pas d'insert/update/delete dans la procédure, il vaut mieux créer
-- une fonction à la place, car son résultat sera directement manipulable
-- dans une requête : select * from ufn_CommandesProduitsMemeFournisseur


-- 8. Faire une fonction qui retourne le même résultat que la procédure précédente
go
create function ufn_CommandesProduitsMemeFournisseur ()
returns @TableId table
(
	Id int primary key
)
as
begin
	insert @TableId
	select od.OrderID
	from OrderDetail od
	inner join Product p on od.ProductID = p.ProductID
	group by od.OrderID
	having count(distinct p.SupplierId) = 1
	
	return
end
go

-- L'exploitation du résultat de la fonction est plus simple que celui de la procédure
select * from ufn_CommandesProduitsMemeFournisseur()

-- 9. faire une fonction qui prend en paramètre une liste de personnes décrites
-- par leur id, nom et date de naissance, et qui renvoie une liste de chaînes de la forme
-- "412 - Toto, 25 ans"
-- Tester la fonction
create type TypeTablePersonne as table 
(
	Id int primary key,
	Nom nvarchar(40),
	DateNais date
)
go

drop function if exists ufn_ListePersonne
go
create function ufn_ListePersonne(@Liste TypeTablePersonne readonly)
returns @Table table (Info nvarchar(40))
as
begin
	insert @Table select (cast(Id as nvarchar(10)) + ' - ' + Nom + ', ' + cast(DATEDIFF(year, DateNais, getdate()) as nvarchar(10))+ ' ans')
				  from @Liste
	return
end
go


declare @ListePersonne TypeTablePersonne
insert @ListePersonne
select EmployeeID, LastName, BirthDate
from Employee

select * from dbo.ufn_ListePersonne(@ListePersonne)


