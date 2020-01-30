select getDate()
select sysdatetime()
select day(getdate())
select month(getdate())
select year(getdate())
select datepart(weekday, getdate())
select datename(dw, getdate())
select datename(weekday, getdate()) --Pareil
select EmployeeId, year(birthdate) from Employee
select EmployeeId, datediff(year, birthdate, getdate()) from Employee -- Age en années
select EmployeeId, datediff(month, birthdate, getdate()) from Employee -- Age en mois
select EmployeeId, datediff(day, birthdate, getdate()) from Employee -- Age en jours
select datefromparts(2020,01,29) as DateTime
select eomonth(datefromparts(2020,02,01))
select datename(w, eomonth(getdate())) -- Dernier jour du mois mais sous forme de date
select format(getdate(), 'd MMMM yyyy', 'fr')


select lastname, len(LastName) from Employee -- affiche le nom et la longueur du nom de chaque employé
select lastname, len(LastName)  as NameLenght from Employee -- pareil
select lower(FirstName), upper(LastName) from Employee
select lower(FirstName) as FirstName, upper(LastName) as LastName from Employee
select replicate('z', 5) -- Répliquer un caractère un certain nombre de fois
select left(FirstName, 2) from Employee --Les deux premiers caractères du prenom d'un employé
select lower(left(firstname, 1)) + upper(left(lastname, 2)) from Employee --la premiere lettre du prénom en minuscule, les deux premieres du nom en maj
select LastName, substring(LastName, 3, 2) from Employee -- extrait les caractères 3 et 2 du prenom avec substring
select LastName, charindex('h', lastname) from Employee -- Renvoio la position du caractère h dans le prenom s'il y en a un
select LastName, replace(lastname, 'a', 'e') from Employee -- remplacer les a par des e dans les prenoms
select Name, len(replace(name, 'a', 'r')) from Product -- ou encore
select Name, len(replace(name, 'ai', 'r')) from Product -- ou encore
