-- Jointure simple entre produits et cat�gries
-- La jointure se fait entre la cl� �trang�re de la 1�re table et la cl� primaire de la 2�me table
-- Cette requ�te permet de r�cup�rer en m�me temps le nom de chaque produit et celui de sa cat�gorie.
select P.ProductID, P.Name, C.CategoryID, C.Name
from Product P
inner join Category C on (P.CategoryID = C.CategoryID)

-- Jointure d'une table sur elle-m�me
select e.EmployeeId 'Id employ�', m.EmployeeId 'Id Manager' 
from Employee e
inner join Employee m on e.ReportsTo = m.EmployeeId
-- Les alias sont ici indispensables

-- La requ�te pr�c�dente ne ram�ne pas l'employ� 2,
-- car son champ ReportsTo vaut NULL
-- Si on veut r�cup�rer tous les employ�s, m�me ceux qui n'ont pas de manager,
-- il faut faire une jointure externe :
select e.EmployeeId 'Id employ�', m.EmployeeId 'Id Manager' 
from Employee e
left outer join Employee m on e.ReportsTo = m.EmployeeId

-- Jointures avec plusieurs tables
-- Cette requ�te ram�ne toutes les associations salari�s / territoires
select E.FirstName, E.LastName, T.Name
from EmployeeTerritory ET
inner join Employee E on (ET.EmployeeID = E.EmployeeID)
inner join Territory T on (ET.TerritoryID = T.TerritoryID)

-- Autre exemple avec jointures externes :
select P.ProductID, P.Name, C.CategoryID, C.Name
from Product P
left outer join Category C on (P.CategoryID = C.CategoryID)
left outer join Supplier S on (P.SupplierID = s.SupplierID)
-- NB/ Les jointures externes sont � utiliser � bon escient, car
-- elles sont plus couteuses (moins performantes) que les jointures internes

-- La m�me requ�te en faisant la premi�re jointure dans l'autre sens :
select P.ProductID, P.Name, C.CategoryID, C.Name
from Category C
right outer join Product P on (P.CategoryID = C.CategoryID)
left outer join Supplier S on (P.SupplierID = s.SupplierID)

-- sous-requetes
select R.Pays, R.NbVentes
from (
select a.Country Pays, count(*) NbVentes
from Orders o
inner join Address a on (o.AddressId = a.AddressId)
group by a.Country
) R
go

-- Cr�ation d'une vue
-- Permet de faire des jointures entre un grand nombre de tables
-- afin de faciliter l'�criture d'autres requ�tes
create view vwSalariesTerritoires as (
select R.RegionID, R.Name RegionName,
		T.TerritoryID, T.Name TerritoryName,
		E.EmployeeID, E.TitleOfCourtesy, E.FirstName, E.LastName, E.ReportsTo
from EmployeeTerritory ET
	inner join Territory T on ET.TerritoryID = T.TerritoryID
	inner join Region R on T.RegionID = R.RegionID
	right outer join Employee E on ET.EmployeeID = E.EmployeeID)
go

-- Exemples d'utilisations de cette vue
select distinct RegionName, LastName, FirstName 
from vwSalariesTerritoires

select RegionName, count(*) as OrdersCount
from vwSalariesTerritoires st
inner join Orders o on st.EmployeeID = o.EmployeeID
group by RegionName


