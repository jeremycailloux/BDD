-- Date et heure courante
select GETDATE() --SYSDATETIME()

-- Jour du mois
select day(getdate())

-- D�composition de la date du jour
declare @d datetime
set @d = getdate();
select day(@d) as jour, month(@d) as mois, year(@d) as ann�e

-- N� du jour de la semaine
select DATEPART(weekday, getdate())

-- Nom du jour de la semaine (ex : friday)
select datename(dw, getdate())

-- Ann�e de naissance des salari�s
select employeeid, firstname, lastname, year(BirthDate) as Ann�eNaissance
from Employee

-- Age des salari�s
select employeeid, firstname, lastname, datediff(year, BirthDate, getdate()) as age
from Employee

------ Instructions non prises en charge par SQL Server 2008 -------------

-- Construction d'une date
select DATEFROMPARTS(2012, 02, 28)

-- Dernier jour du mois de la date pass�e en param�tre
select EOMONTH (getdate())
select EOMONTH(DATEFROMPARTS(2012, 02, 01))

-- Formatage de la date pour la France
-- Les formats sont les m�mes qu'en .net
select format(getdate(), 'G', 'fr')
select format(getdate(), 'd MMMM yyyy', 'fr')

----------------------------------- chaines --------------------------------

-- Longeur d'une cha�ne
select firstname, len(firstname)
from Employees

-- Mise en minuscules, majuscules
select lower(firstname), upper(lastname)
from Employee

-- Cr�ation d'une cha�ne par r�plication de N caract�res 
select replicate('z', 5)

-- cr�ation d'un code � partir de la premi�re lettre du pr�nom
-- et des 2 premi�res lettre du nom (en majuscules)
select firstname, lastname,
left(firstname, 1) + left(upper(lastname), 2) as code
from Employee

-- position d'un caract�re dans une cha�ne
select charindex('h', LastName)
from Employee
where EmployeeID = 5

-- renvoie les 2 caract�res du nom � partir de l'indice 3
select substring(LastName, 3, 2)
 from Employee
where EmployeeID = 5

-- remplacement d'une sous-chaine par une autre dans une chaine
select EmployeeId, Lastname, replace(title, ' ', '_') 
from Employee

