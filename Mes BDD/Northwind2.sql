/*
restore database Northwind2 from disk = N'C:\Users\Adminl\Desktop\Jeremy\BDD\backups\Northwind2.bak'
with
move 'Northwind2' to N'C:\Users\Adminl\Desktop\Jeremy\BDD\backups\Northwind2.mdf',
move 'Northwind2_log' to N'C:\Users\Adminl\Desktop\Jeremy\BDD\backups\Northwind2.ldf'
*/

insert Customer (CustomerId, CompanyName, ContactName, ContactTitle, AddressId)
values ('ESSAI', 'Mon entreprise', NULL, NULL, '5d151bcb-ca1d-45b9-b80f-c45a7bc62334')

update Customer set ContactName = 'Tournesol', ContactTitle = 'Professeur' where CustomerId = 'ESSAI'
delete from Customer where CustomerId = 'ESSAI'
select CustomerId, CompanyName from Customer
select * from Customer
select * from Customer where ContactTitle = 'owner'
select * from Customer where ContactTitle in ('owner', 'sales manager')
select * from Customer where ContactTitle = 'owner' or ContactTitle = 'Sales Manager'
select * from Employee
select * from Employee where EmployeeId > 5 and TitleOfCourtesy = 'Ms.'
select * from Employee where HireDate > '2012-01-01'
select * from Employee where HireDate >= '2012-01-01' and TitleOfCourtesy = 'Ms.'
select * from Employee where HireDate >= '2012-01-01' and HireDate <= '2013-01-01'
select * from Employee where HireDate between '2012-01-01' and '2013-01-01'
select * from Employee where LastName like ('K%')
select * from Employee where LastName like ('%K%')
select * from Employee where LastName like ('_A_L%')
select * from Employee where LastName like ('%[AEIOUY]')
select * from Employee where LastName like ('%[^AEIOUY]')
select * from Employee where LastName like ('%[^RG]')
select * from Employee where ReportsTo is null
select * from Employee where ReportsTo is not null
select * from Employee order by LastName
select * from Employee order by LastName desc
select * from Employee order by TitleOfCourtesy, BirthDate
select EmployeeId, LastName, FirstName, TitleOfCourtesy, BirthDate from Employee order by 4,5
select top(3) * from Employee order by BirthDate desc