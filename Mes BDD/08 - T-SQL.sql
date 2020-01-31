----------------------- Variables -------------------------------

-- D�claration de variables :
-- le nom commence toujours par @
declare @nom nvarchar(40)
declare @datenais datetime

-- On peut d�clarer plusieurs variables sur la m�me ligne
-- mais il faut sp�cifier le type de chacune d'elles
declare @prenom nvarchar(40), @ville nvarchar(40)

-- L'initialisation se fait avec set ou select (plus souple)
set @datenais = '2000-12-25'
select @datenais = '2000-12-25'

-- On peut initialiser directement un variable � partir du r�sultat d'une requ�te
select @prenom = FirstName, @nom = LastName,  @datenais = BirthDate
from Employee
where EmployeeID = 7
-- NB/ si la requ�te renvoie plusieurs lignes, c'est le r�sultat de la derni�re ligne qui est stock�

-- Affichage avec select (dans les r�sultats) ou print (dans les messages)
select @datenais
print  @datenais

-- On peut aussi d�clarer des variables de type table pour stocker de petites quantit�s de donn�es
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
	print 'le salari� ' + cast(@IdEmploye as varchar(10)) + ' est le PDG'
else
	print 'le salari� ' + cast(@IdEmploye as varchar(10)) + 
	' est manag� par le ' + cast(@IdManager as varchar(10))

-- S'il y a plusieurs instructions, il faut utiliser des blocs entour�s de BEGIN et END
if @IdManager is null
	begin
		print 'le salari� ' + cast(@IdEmploye as varchar(10))
		print 'est le PDG'
	end
else
	begin
		print 'le salari� ' + cast(@IdEmploye as varchar(10)) 
		print 'est manag� par le ' + cast(@IdManager as varchar(10))
	end

-- Utilisation d'une requ�te comme condition
if (exists (select orderId from Orders where CustomerID = 'OCEAN'))
	print 'Le client OCEAN a d�j� pass� commande'
else
	print 'Le client OCEAN n''a jamais pass� de commande'

if (select count(*) from Orders where CustomerID = 'OCEAN') > 3
	print 'Le client OCEAN a pass� plus de 3 commandes'
else
	print 'Le client OCEAN a pass� moins de 4 commandes'

GO

select * from Customer

-- CASE WHEN
-- La partie else n'est pas obligatoire
-- Ne pas oublier 'end' � la fin
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
-- il faut faire une sous-requ�te :
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

-- Quand le r�sultat de la condition est une valeur simple,
-- on peut simplifier la syntaxe de la fa�on suivante :
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
-- Ex : On applique une r�duction aux lignes de commandes qui n'en ont pas
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
-- NB/ Le code ci-dessus n'a aucun int�r�t fonctionnel. Il ne sert
-- qu'� pr�senter la syntaxe
GO

