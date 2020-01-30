-- Date et heure courante
select GETDATE() --SYSDATETIME()

-- Jour du mois
select day(getdate())

-- Décomposition de la date du jour
declare @d datetime
set @d = getdate();
select day(@d) as jour, month(@d) as mois, year(@d) as année

-- N° du jour de la semaine
select DATEPART(weekday, getdate())

-- Nom du jour de la semaine (ex : friday)
select datename(dw, getdate())

-- Année de naissance des salariés
select employeeid, firstname, lastname, year(BirthDate) as AnnéeNaissance
from Employee

-- Age des salariés
select employeeid, firstname, lastname, datediff(year, BirthDate, getdate()) as age
from Employee

------ Instructions non prises en charge par SQL Server 2008 -------------

-- Construction d'une date
select DATEFROMPARTS(2012, 02, 28)

-- Dernier jour du mois de la date passée en paramètre
select EOMONTH (getdate())
select EOMONTH(DATEFROMPARTS(2012, 02, 01))

-- Formatage de la date pour la France
-- Les formats sont les mêmes qu'en .net
select format(getdate(), 'G', 'fr')
select format(getdate(), 'd MMMM yyyy', 'fr')

----------------------------------- chaines --------------------------------

-- Longeur d'une chaîne
select firstname, len(firstname)
from Employees

-- Mise en minuscules, majuscules
select lower(firstname), upper(lastname)
from Employee

-- Création d'une chaîne par réplication de N caractères 
select replicate('z', 5)

-- création d'un code à partir de la première lettre du prénom
-- et des 2 premières lettre du nom (en majuscules)
select firstname, lastname,
left(firstname, 1) + left(upper(lastname), 2) as code
from Employee

-- position d'un caractère dans une chaîne
select charindex('h', LastName)
from Employee
where EmployeeID = 5

-- renvoie les 2 caractères du nom à partir de l'indice 3
select substring(LastName, 3, 2)
 from Employee
where EmployeeID = 5

-- remplacement d'une sous-chaine par une autre dans une chaine
select EmployeeId, Lastname, replace(title, ' ', '_') 
from Employee

