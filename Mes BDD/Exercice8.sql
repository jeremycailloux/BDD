-- Exercice 8

-- 1. Créer des variables pour stocker vos prénom, nom, date de naissance et âge puis afficher à l'écran la phrase ci-dessous en utilisant ces variables :
-- 'Je m'appelle Luc Arnes, je suis né le 03 déc. 2000 et j'ai 18 ans'

declare @prenom nvarchar(40)
declare @nom nvarchar(40)
declare @datenais date
declare @age int -- = datediff(year, @datenaiss, getDate())

set @prenom = 'Jeremy'
set @nom = 'Cailloux'
set @datenais = '1982-04-24'
set @age = '37'

select @nom as Nom, @prenom as Prenom, @datenais as 'Date De Naissance', @age as Age
print 'Je m''appelle ' + @prenom + ' ' + @nom + ', ' + 'je suis né le: ' + format(@datenais, 'dd MMM yyyy') + ' et j''ai ' + cast(@age as nvarchar)

-- 2. Créer une variable de type table avec clé primaire, permettant de récupérer les id et date des commandes, ainsi que les id des clients
-- Remplir cette table avec une requête
-- Puis faire une requête permettant de récupérer les noms des clients qui ont passé ces commandes 

DECLARE @Order TABLE
(
	OrderId int primary key,
	Orderdate date not null,
	CustomerId varchar(20)
)

insert @Order(OrderId, OrderDate, CustomerId)
select OrderId, OrderDate, CustomerId from Orders


select O.OrderId, CU.ContactName
from Orders O
inner join Customer CU on(O.CustomerId = CU.CUstomerId)
inner join @Order OTAB on(O.OrderId = OTAB.OrderId)


-- 3. S'il existe des clients dont le pays est UK et la région n'est pas renseignée, afficher à l'écran un message d'alerte avec le nombre de clients concernés, sinon afficher le message 'Régions OK'

/*
if (exists (select CustomerId from Orders O
inner joint Customer CU on(O.CustomerId = CU.CustomerId)
inner joint Address A on(CU.AddressId = A.AddressId)
where CU.Country  = 'UK'))
*/
declare @nbclients int
set @nbclients=(select count(CustomerId) from Customer CU
inner join Address A on(A.AddressId = CU.AddressId)
where A.Country = 'UK' and A.Region is null)

if (@nbclients>0)
print convert(nvarchar, @nbclients) + ' clients n''ont pas de Région renseignée'
else print 'Regions OK'


-- 4. Faire une requête renvoyant le nombre de clients d'Amérique du nord, d'Amérique du sud et des autres continents

select count(CustomerId), RQ.Zone
from
(
select CustomerId, 
case
when A.Country = 'Canada' or A.Country = 'USA' then 'Amerique du Nord'
else 'Reste du monde'
end as Zone
from Customer CU
inner join Address A on(A.AddressId = CU.AddressId) 
) RQ
group by Zone