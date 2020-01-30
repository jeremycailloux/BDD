-- 1. �ge moyen des salari�s � l'embauche 
select avg(datediff(year, BirthDate, hiredate))
from Employee

-- 2. Liste des commandes livr�es en retard (id commande, id client, nb jours de retard)
select orderid, customerid, DATEDIFF(day, RequiredDate, ShippedDate)
 from orders
where RequiredDate < ShippedDate
order by 3

-- 3. Liste des commandes pass�es pendant le week-end (id et jour de la semaine)
select orderid, datepart(weekday, orderdate)
from orders
where datepart(weekday, orderdate) in (6, 7)

-- 4. Nombres de commandes par mois de l'ann�e (c-�-d 12 lignes attendues)
select month(orderdate) as mois, count(OrderID) as NbCommandes
from orders
group by month(orderdate)
order by 1

-- 5. Mois et ann�e durant lequel il y a eu le plus de commandes
-- (mois, ann�e et nombre total de commandes)
select top(1) month(orderdate) as mois, year(orderdate) as ann�e, count(OrderID) as NbCommandes
from orders
group by month(orderdate), year(orderdate)
order by NbCommandes desc

-- 6. D�lai de livraison moyen des commandes de l'ann�e 2017
select avg(DATEDIFF(day, OrderDate, ShippedDate))
from orders
where year(orderdate) = 2017

-- 7. Nombre de commandes par employ� et par ann�e
select EmployeeId, year(orderdate), count(OrderID) as NbCommandes
from orders
group by EmployeeId, year(orderdate)
order by 1, 2

-- 8. D�lai de livraison moyen par livreur, du plus grand au plus petit (id livreur, d�lai de livraison)
select ShipperId, avg(DATEDIFF(day, OrderDate, ShippedDate))
from orders
group by ShipperId
order by 2 desc

-- 9. Clients qui ont fait plus de 5 commandes au cours de l'ann�e 2017 (id du client et nb commandes)
select CustomerID, COUNT(OrderID) NbCommandes
from Orders
where year(OrderDate) = 2017
group by year(OrderDate), CustomerID
having COUNT(OrderID) > 5


------------------------------ cha�nes -----------------------------------

-- 10. Nombre d'employ�s regroup�s par la premi�re lettre de leur nom
select LEFT(LastName, 1), COUNT(*)
from Employee
group by LEFT(LastName, 1)

-- 11. Compter le nombre d'espaces dans le nom de chaque produit
select Name, (LEN(Name) - LEN(replace(Name, ' ', ''))) as nb_espaces
from Product


