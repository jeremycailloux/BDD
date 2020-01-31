-- 1. Cr�er des variables pour stocker vos pr�nom, nom, date de naissance et age
-- puis afficher � l'�cran la phrase ci-dessous en utilisant ces variables :
-- 'Je m'appelle Luc Arnes, je suis n� le 03 d�c. 2000 et j'ai 17 ans'

-- D�claration des variables
declare @nom nvarchar(40) = 'toto'
declare @prenom nvarchar(40) = 'Toto'
declare @datenais date = '2000-10-25'
declare @age int = datediff(year, @datenais, getdate())

-- Affichage dans une phrase
print 'Je m''appelle ' + @prenom + ' ' + @nom + ', je suis n� le ' + 
convert(nvarchar, @datenais, 106) + ' et j''ai ' + cast(@age as nvarchar) + ' ans'

-- 2. Cr�er une variable de type table avec cl� primaire, permettant de r�cup�rer
-- les id et date des commandes, ainsi que les id des clients
-- Remplir cette table avec une requ�te
-- Puis faire une requ�te permettant de r�cup�rer les noms des clients qui ont pass� ces commandes 

declare @Commandes table
(
	Id int primary key,
	IdClient varchar(5),
	DateCmde date not null
)

insert @Commandes(Id, IdClient, DateCmde)
select OrderID, CustomerID, OrderDate
from Orders

select CustomerID, c.CompanyName
from @Commandes cd
inner join Customer C on cd.IdClient = C.CustomerID

-- 3. S'il existe des clients dont le code postal n'est pas renseign�,
-- afficher � l'�cran un message d'alerte avec le nombre de clients concern�s
-- sinon, afficher le message 'Code postaux OK'
declare @nbCli int
select @nbCli = count(*)
FROM Customer C
INNER JOIN Address A on C.AddressId = A.AddressId 
WHERE PostalCode IS NULL

IF @nbCli > 0
	print cast(@nbCli as nvarchar) + ' clients n''ont pas de code postal'
else
	print 'Codes postaux OK'

-- 4. Faire une requ�te renvoyant le nombre de clients d'Am�rique du nord, d'Am�rique du sud
-- et des autres continents
select Continent, count(*) NbClients from 
(
	select CustomerID,
		case
			when country in ('Argentina', 'Brazil', 'Venezuela') then 'Am�rique Sud'
			when country in ('USA', 'Canada', 'Mexico') then 'Am�rique Nord'
			else 'Autre'
		end as Continent
	from Customer C
	INNER JOIN Address A on C.AddressId = A.AddressId 
) R
group by Continent
order by 1

-- 5. Noter la quantit� en stock et le prix des produits d'id 72, 73 et 74
-- Augmenter les prix de tous les produits, selon leur tranche de quantit� en stock :
--   * Moins de 10 : + 20%
--   * de 10 � 99 : + 10%
--   * 100 ou plus : + 3%
-- V�rifier que les prix des produits not�s pr�c�demment sont correctement mis � jour
select * from Product where ProductID in (72, 73, 74)
begin tran
update Product set UnitPrice = (
case
	when unitsinstock < 10 then UnitPrice * 1.2
	when unitsinstock between 10 and 99 then UnitPrice * 1.1
	else UnitPrice * 1.03
end
)
select * from Product where ProductID in (72, 73, 74)
rollback

-- 6. Classer les salari�s selon 4 tranches de chiffre d'affaire r�alis�
-- Affecter les salari�s de chaque tranche � une r�gion diff�rente
-- NB/ Dans chaque r�gion, ils seront tous affect�s � un territoire choisi arbitrairement

-- Cr�ation d'une table pour stocker les salari�s, leur CA et leur tranche
declare @CASalaries table
(
	Id int primary key,
	Prenom nvarchar(20) not null,
	Nom nvarchar(20) not null,
	CA money not null,
	Tranche tinyint not null
)

-- Remplissage de la table � partir d'une requ�te
insert @CASalaries (Id, Prenom, Nom, CA, Tranche)
select EmployeeID, FirstName, LastName, CA,
	case
		when CA < 100000 then 1
		when CA < 150000 then 2
		when CA < 200000 then 3
		else 4
	end as Tranche
from
(
	select E.EmployeeID, E.FirstName, E.LastName,
		sum(UnitPrice * Quantity * (1-Discount)) CA
	from Employee E
	inner join Orders O on E.EmployeeID = O.EmployeeID
	inner join OrderDetail OD on O.OrderID = OD.OrderID
	group by E.EmployeeID, E.FirstName, E.LastName
)R
order by CA

-- V�rification du contenu de la table
--select * from @CASalaries

-- select * from Territories order by regionId
-- Exemples d'id de territoire pour chacune des r�gions : 11747, 80202, 44122, 29202

-- Suppression des enregistrements de EmployeeTerritories
-- puis r�affectation du territoire de chaque salari� en utilisant un insert de masse
-- � partir de la variable table @CASalaries
begin tran
delete from EmployeeTerritory
insert EmployeeTerritory (EmployeeID, TerritoryID)
select Id,
(
	case Tranche
		when 1 then '11747'
		when 2 then '80202'
		when 3 then '44122'
		when 4 then '29202'
	end
)
from @CASalaries

-- V�rification
select cas.*, t.RegionID
from @CASalaries cas
inner join EmployeeTerritory et on et.EmployeeID = cas.Id
inner join Territory t on et.TerritoryID = t.TerritoryID
order by Tranche

rollback




