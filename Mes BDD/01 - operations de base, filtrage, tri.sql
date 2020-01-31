-- Insertion de données dans une table
insert Customer (CustomerID, CompanyName, ContactName, ContactTitle) values (
'ESSAI', 'Mon entreprise', NULL, NULL)

-- Mise à jour
Update Customer set
ContactName = 'Tournesol',
ContactTitle = 'Prof.'
where CustomerID = 'ESSAI'

-- Suppression
delete from Customer where CustomerID = 'ESSAI'


-- Requête simple pour récupérer toutes les lignes de la table
-- Dans SSMS le résultat est affiché, mais si la requête est exécutée dans une appli,
-- on peut récupérer les lignes dans une collection d'objets ou dans un Dataset (objet spécialisé)
-- pour manipuler ensuite les données dans l'appli
select EmployeeID, FirstName, LastName
from Employee

-- récupération des valeurs de tous les champs
select *
from Employee

--------------------------------------------------------
-- Filtrage
select *
from Employee
where TitleOfCourtesy = 'Ms.'

-- Filtrage sur plusieurs valeurs
select *
from Employee
where TitleOfCourtesy in ('Ms.', 'Mrs.')

-- Filtrage sur plusieurs critères différents
select EmployeeID, TitleOfCourtesy, FirstName, LastName
from Employee
where EmployeeId >5 and TitleOfCourtesy = 'Ms.'

select EmployeeID, TitleOfCourtesy, FirstName, LastName
from Employee
where EmployeeId >5 or TitleOfCourtesy = 'Ms.'

-- Filtrage sur la valeur NULL
select EmployeeID, FirstName, LastName
from Employee
where ReportsTo is null

--------------------------------------------------------------
-- Opérateurs de comparaison (>=, !=, between...)
select EmployeeID, FirstName, LastName, HireDate
from Employee
where HireDate >= '2012-01-01'

select EmployeeID, FirstName, LastName, HireDate
from Employee
where HireDate >= '2012-01-01' and TitleOfCourtesy != 'Mr.'

select EmployeeID, FirstName, LastName, HireDate
from Employee
where HireDate between '2012-04-01' and '2013-04-01'

--------------------------------------------
-- Opérateur like

-- salariés dont le nom commence par K
select EmployeeID, FirstName, LastName
from Employee
where LastName like ('K%')
-- % remplace une chaîne de caractères de n'importe quelle longueur

-- salariés dont le nom contient un A
select EmployeeID, FirstName, LastName
from Employee
where LastName like ('%A%')

-- salariés dont le nom contient un A en 2de position
select EmployeeID, FirstName, LastName
from Employee
where LastName like ('_A%')
-- % remplace un caractère

-- salariés dont le nom se termine par une voyelle
select EmployeeID, FirstName, LastName
from Employee
where LastName like ('%[aeiouy]')

-- salariés dont le nom ne commence pas par D
select EmployeeID, FirstName, LastName
from Employee
where LastName like ('[^D]%')
-- ou bien :
select EmployeeID, FirstName, LastName
from Employee
where LastName not like ('[D]%')

--------------------------------------------
-- Tri
select EmployeeID, FirstName, LastName
from Employee
order by LastName

select EmployeeID, FirstName, LastName
from Employee
order by LastName desc

select EmployeeID, FirstName, LastName, TitleOfCourtesy, BirthDate
from Employee
order by TitleOfCourtesy, BirthDate

select EmployeeID, FirstName, LastName, TitleOfCourtesy, BirthDate
from Employee
order by 4, 5 

-- les 3 salariés les plus jeunes
select top(3) EmployeeID, LastName, BirthDate
from Employee
order by BirthDate desc