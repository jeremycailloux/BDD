----------------------- Variables -------------------------------

-- Déclaration de variables :
-- le nom commence toujours par @
declare @nom nvarchar(40)
declare @datenais datetime

-- On peut déclarer plusieurs variables sur la même ligne
-- mais il faut spécifier le type de chacune d'elles
declare @prenom nvarchar(40), @ville nvarchar(40)

-- L'initialisation se fait avec set ou select (plus souple)
set @datenais = '2000-12-25'
select @datenais = '2000-12-25'

-- On peut initialiser directement un variable à partir du résultat d'une requête
select @prenom = FirstName, @nom = LastName,  @datenais = BirthDate
from Employee
where EmployeeID = 7
-- NB/ si la requête renvoie plusieurs lignes, c'est le résultat de la dernière ligne qui est stocké

-- Affichage avec select (dans les résultats) ou print (dans les messages)
select @datenais
print  @datenais

-- On peut aussi déclarer des variables de type table pour stocker de petites quantités de données
DECLARE @ProduitsObsoletes TABLE
(
	Id int primary key,
	Nom nvarchar(40) not null
)

insert @ProduitsObsoletes(Id, Nom)
select ProductID, Name from Product where Discontinued = 1

Go


----------------------- Instructions conditionnelles -------------------------------

-- IF...ELSE
declare @IdEmploye int = 1
declare @IdManager int

select @IdManager = ReportsTo
from Employee where EmployeeId = @IdEmploye

if @IdManager is null
	print 'le salarié ' + cast(@IdEmploye as varchar(10)) + ' est le PDG'
else
	print 'le salarié ' + cast(@IdEmploye as varchar(10)) + 
	' est managé par le ' + cast(@IdManager as varchar(10))

-- S'il y a plusieurs instructions, il faut utiliser des blocs entourés de BEGIN et END
if @IdManager is null
	begin
		print 'le salarié ' + cast(@IdEmploye as varchar(10))
		print 'est le PDG'
	end
else
	begin
		print 'le salarié ' + cast(@IdEmploye as varchar(10)) 
		print 'est managé par le ' + cast(@IdManager as varchar(10))
	end

-- Utilisation d'une requête comme condition
if (exists (select orderId from Orders where CustomerID = 'OCEAN'))
	print 'Le client OCEAN a déjà passé commande'
else
	print 'Le client OCEAN n''a jamais passé de commande'

if (select count(*) from Orders where CustomerID = 'OCEAN') > 3
	print 'Le client OCEAN a passé plus de 3 commandes'
else
	print 'Le client OCEAN a passé moins de 4 commandes'

GO

select * from Customer

-- CASE WHEN
-- La partie else n'est pas obligatoire
-- Ne pas oublier 'end' à la fin
select name, unitprice,
	case
		when UnitPrice < 10 then 'T1'
		when UnitPrice < 50 then 'T2'
		else 'T3'
	end as Tranche
from Product
order by UnitPrice

-- Regroupement sur une colonne avec case when
-- Comme on ne peut pas faire un group by sur un alias,
-- il faut faire une sous-requête :
select Tranche, count(*) NbProduits from
(
	select ProductId, Name,
		case
			when UnitPrice < 10 then 'T1'
			when UnitPrice < 50 then 'T2'
			else 'T3'
		end as Tranche
	from Product
) R
group by Tranche

-- Quand le résultat de la condition est une valeur simple,
-- on peut simplifier la syntaxe de la façon suivante :
select employeeid,
	case RegionID
		when 1 then 'Est'
		when 2 then 'Ouest'
		when 3 then 'Nord'
		when 4 then 'Sud'
	end 
from EmployeeTerritory ET
inner join Territory T on ET.TerritoryID = T.TerritoryID

select homepage from Supplier
select * from Territory

-- Utilisation dans un update
-- Ex : On applique une réduction aux lignes de commandes qui n'en ont pas
-- selon leur tranche de prix
Update OrderDetail set Discount = (
	case
	when Quantity * UnitPrice > 50 and Discount = 0 then 0.05
	when Quantity * UnitPrice > 100 and Discount = 0 then 0.1
	end
)
GO

---------------------- Boucle WHILE -------------------------------

declare @i int
set @i = 1

while @i <= (select max(RegionID) from Region)
begin
	select Name from Region where RegionID = @i
	set @i=@i+1 
end
-- NB/ Le code ci-dessus n'a aucun intérêt fonctionnel. Il ne sert
-- qu'à présenter la syntaxe
GO

