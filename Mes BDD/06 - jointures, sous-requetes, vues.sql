-- Jointure simple entre produits et catégries
-- La jointure se fait entre la clé étrangère de la 1ère table et la clé primaire de la 2ème table
-- Cette requête permet de récupérer en même temps le nom de chaque produit et celui de sa catégorie.
select P.ProductID, P.Name, C.CategoryID, C.Name
from Product P
inner join Category C on (P.CategoryID = C.CategoryID)

-- Jointure d'une table sur elle-même
select e.EmployeeId 'Id employé', m.EmployeeId 'Id Manager' 
from Employee e
inner join Employee m on e.ReportsTo = m.EmployeeId
-- Les alias sont ici indispensables

-- La requête précédente ne ramène pas l'employé 2,
-- car son champ ReportsTo vaut NULL
-- Si on veut récupérer tous les employés, même ceux qui n'ont pas de manager,
-- il faut faire une jointure externe :
select e.EmployeeId 'Id employé', m.EmployeeId 'Id Manager' 
from Employee e
left outer join Employee m on e.ReportsTo = m.EmployeeId

-- Jointures avec plusieurs tables
-- Cette requête ramène toutes les associations salariés / territoires
select E.FirstName, E.LastName, T.Name
from EmployeeTerritory ET
inner join Employee E on (ET.EmployeeID = E.EmployeeID)
inner join Territory T on (ET.TerritoryID = T.TerritoryID)

-- Autre exemple avec jointures externes :
select P.ProductID, P.Name, C.CategoryID, C.Name
from Product P
left outer join Category C on (P.CategoryID = C.CategoryID)
left outer join Supplier S on (P.SupplierID = s.SupplierID)
-- NB/ Les jointures externes sont à utiliser à bon escient, car
-- elles sont plus couteuses (moins performantes) que les jointures internes

-- La même requête en faisant la première jointure dans l'autre sens :
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

-- Création d'une vue
-- Permet de faire des jointures entre un grand nombre de tables
-- afin de faciliter l'écriture d'autres requêtes
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


