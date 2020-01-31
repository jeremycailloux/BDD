----------------------- Procédures -------------------------------

-- Création d'une procédure stockée
drop procedure if exists AppliquerRabais
go
create procedure AppliquerRabais @taux real, @montantMin money
as
begin
	Update Order_Details set Discount = @taux
	where Quantity * UnitPrice >= @montantMin
end
go

-- Appel de la procédure
exec AppliquerRabais 0.20, 200

-- On peut affecter des valeurs par défaut aux paramètres
drop procedure if exists AppliquerRabais
go
create procedure AppliquerRabais
   @taux real = 0.20, @montantMin money = 100
as
begin
	Update Order_Details set Discount = @taux
	where Quantity * UnitPrice >= @montantMin
end
go

-- NB/ Une procédure peut aussi exécuter un ou plusieurs select, mais
-- ceci a peu d'intérêt, car le résultat n'est pas exploitable dans
-- une autre instruction SQL (contrairement aux fonctions)

-- Procédure avec paramètre en sortie
-- (Il peut y avoir plusieurs paramètre en sortie) 
drop procedure if exists AjouterRegion
go
create procedure AjouterRegion @nom nvarchar(50), @id int output
as
begin transaction
select @id = isnull(max(RegionId), 0) + 1 from region (updlock)
insert region (RegionId, RegionDescription) values (@id, @nom)
commit transaction
go

-- Exécution de la procédure et récupération de l'id de la nouvelle région
declare @RegId int
EXEC AjouterRegion 'NorthEast', @RegId OUTPUT
select @RegId

----------------------- Fonctions -------------------------------

-- Création d'une fonction scalaire
drop function if exists ufn_Add
go
create function ufn_Add (@a int, @b int)
returns int
as
begin
	return @a + @b
end
go

-- Appel de la fonction scalaire
select dbo.ufn_Add(5, 9)


-- Création d'une fonction table
-- NB/ Mettre un PK sur la table mémoire apporte sécurité et performance
drop function if exists ufn_ClientsDuPays
go
create function ufn_ClientsDuPays(@pays nvarchar(40))
returns @TableClients table
(
	Id nvarchar(10) primary key,
	Nom nvarchar(40) not null
)
as
begin
	insert @TableClients
	select CustomerID, CompanyName
	from Customers
	where country = @pays

	return
end
go

-- Lorsque le corps de la fonction ne comporte qu'une seule instruction,
-- on peut écrire plus simplement :
drop function if exists ufn_ClientsDuPays
go
create function ufn_ClientsDuPays(@pays nvarchar(40))
returns table
as
   return (select CustomerID, CompanyName
	from Customers
	where country = @pays)
go

-- Appel de la fonction table
select * from ufn_ClientsDuPays('France')

-- Le résultat de la fonction table s'utilise comme une table ordinaire
select c.Id, count(*) NbCommandes
from ufn_ClientsDuPays('France') c
inner join orders o on c.Id = o.CustomerID
group by c.Id

-- Une fonction table peut être utilisée comme une vue 
-- pour regrouper les informations de plusieurs tables
-- avec l'avantage de pouvoir prendre des paramètres en entrée
drop function if exists ufn_TerritoiresDuSalarie
go
create function ufn_TerritoiresDuSalarie(@IdSalarie int)
returns table as
return (select R.RegionID, R.RegionDescription,
		T.TerritoryID, T.TerritoryDescription
from EmployeeTerritories ET
	inner join Territories T on ET.TerritoryID = T.TerritoryID
	inner join Region R on T.RegionID = R.RegionID
where ET.EmployeeID = @IdSalarie)
go

-- Appel de la fonction
select RegionDescription, TerritoryDescription
from ufn_TerritoiresDuSalarie(9)


-- Création d'un type défini par l'utilisateur
drop type if exists TypeTablePersonne
go
create type TypeTablePersonne as table
(
	Id nvarchar(10) primary key,
	Nom nvarchar(40) not null
)
go

-- Récupération du résultat de la fonction dans une variable de ce type
declare @clients TypeTablePersonne
insert @clients
select Id, Nom from ufn_ClientsDuPays('France')

