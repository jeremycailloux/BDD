-- Insertion de donn�es dans une table
insert Customer (CustomerID, CompanyName, ContactName, ContactTitle) values (
'ESSAI', 'Mon entreprise', NULL, NULL)

-- Mise � jour
Update Customer set
ContactName = 'Tournesol',
ContactTitle = 'Prof.'
where CustomerID = 'ESSAI'

-- Suppression
delete from Customer where CustomerID = 'ESSAI'


-- Requ�te simple pour r�cup�rer toutes les lignes de la table
-- Dans SSMS le r�sultat est affich�, mais si la requ�te est ex�cut�e dans une appli,
-- on peut r�cup�rer les lignes dans une collection d'objets ou dans un Dataset (objet sp�cialis�)
-- pour manipuler ensuite les donn�es dans l'appli
select EmployeeID, FirstName, LastName
from Employee

-- r�cup�ration des valeurs de tous les champs
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

-- Filtrage sur plusieurs crit�res diff�rents
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
-- Op�rateurs de comparaison (>=, !=, between...)
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
-- Op�rateur like

-- salari�s dont le nom commence par K
select EmployeeID, FirstName, LastName
from Employee
where LastName like ('K%')
-- % remplace une cha�ne de caract�res de n'importe quelle longueur

-- salari�s dont le nom contient un A
select EmployeeID, FirstName, LastName
from Employee
where LastName like ('%A%')

-- salari�s dont le nom contient un A en 2de position
select EmployeeID, FirstName, LastName
from Employee
where LastName like ('_A%')
-- % remplace un caract�re

-- salari�s dont le nom se termine par une voyelle
select EmployeeID, FirstName, LastName
from Employee
where LastName like ('%[aeiouy]')

-- salari�s dont le nom ne commence pas par D
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

-- les 3 salari�s les plus jeunes
select top(3) EmployeeID, LastName, BirthDate
from Employee
order by BirthDate desc