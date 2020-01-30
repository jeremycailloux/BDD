
--1
select avg(datediff(year, Birthdate, HireDate)) as HireAge from Employee

--2
select OrderId, CustomerId, datediff(day, ShippedDate, RequiredDate) as DelayDays 
from Orders
where RequiredDate < ShippedDate

--3
select OrderId, datename(weekday, OrderDate) as DayOfOrder 
from Orders  
where datename(weekday, OrderDate) in ('saturday', 'sunday')

select OrderId, datename(weekday, OrderDate) as DayOfOrder 
from Orders  
where datepart(weekday, OrderDate) in ('1', '7')

--4
select month(Orderdate), Count(OrderId) as Month from Orders
group by month(Orderdate)
order by month(Orderdate)

--5
select Count(OrderId), month(Orderdate) as Month from Orders
group by month(Orderdate)
order by Count(OrderId) desc

--6
select avg(datediff(day, OrderDate, ShippedDate)) as AverageDelayDays 
from Orders
where year(orderDate) = 2017

--7
select EmployeeId, count(OrderId), year(OrderDate) as NbOrders
from Orders
group by year(OrderDate), EmployeeId
order by EmployeeId 

--8
select ShipperId, avg(datediff(day, OrderDate, ShippedDate)) as ShipperAvgDelay 
from Orders
group by ShipperId
order by ShipperAvgDelay

--9
select CustomerId, count(orderId) as NbOrders
from Orders
where year(OrderDate) = 2017
group by CustomerId
order by CustomerId

--10
select left(LastName, 1) as PremierLettre, count(*) from NbEmployee
group by left(LastName, 1)

--11
select ProductId, len(Name)-len(replace(name, '', '')) as NombreEspace
from Product



