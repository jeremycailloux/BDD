------------------ EXISTS -----------------------------
-- Salariés qui sont managers
select * from Employee E
where exists
(select EmployeeID from Employee where ReportsTo = E.EmployeeID)

-- Salariés qui ne sont pas managers
select * from Employee E
where not exists
(select EmployeeID from Employee where ReportsTo = E.EmployeeID)

-- Autre méthode :
select EmployeeID from Employee
intersect 
select ReportsTo from Employee

-- La requête suivante ramène les titres de fournisseurs contenant Manager
-- et qui n'ont pas d'équivalent parmi les titres des clients
select distinct ContactTitle from Supplier where ContactTitle like '%Manager%'
except
select distinct ContactTitle from Customer where ContactTitle like '%Manager%'

-- On peut aussi l'écrire de la façon suivante :
select distinct ContactTitle from Supplier S
where ContactTitle like '%Manager%'
and not exists (select ContactTitle from Customer C where ContactTitle = S.ContactTitle)

------------------ OVER PARTITION BY -----------------------------
-- Permet entre autres de faire des calculs d'agrégat sur chaque ligne

-- Un calcul d'agrégat avec group by produit une ligne de résultat par groupe
-- Ex : Nombre de produits par catégorie --> 8 lignes (autant que de catégories)
select C.CategoryId, C.Name, count(*) NBProduits
from Product P
inner join Category C on P.CategoryId = C.CategoryId
group by C.CategoryId, C.Name

-- over(partition by) permet également de calculer un agrégat,
-- mais affiche son résultat sur chaque ligne du détail
-- Ex : Nombre de produits par catégorie --> 77 lignes (autant que de produits)
select C.CategoryId, C.Name,
		count(*) over(partition by C.CategoryId) NBProduits
from Product P
inner join Category C on P.CategoryId = C.CategoryId

-- on peut supprimer les doublons avec distinct :
select distinct C.CategoryId, C.Name,
		count(*) over(partition by C.CategoryId) NBProduits
from Product P
inner join Category C on P.CategoryId = C.CategoryId

-- L'avantage de over est qu'on peut facilement calculer plusieurs agrégats à la fois sans sous-requêtes
-- Ex : Pour chaque catégorie, on veut afficher le nombre de produits
-- et le nombre d'unités de produits en cours de commande

-- Avec group by :
select C.CategoryId, C.Name,
	(select count(*) from Product where CategoryId = C.CategoryId) 'Produits', 
	sum(UnitsOnOrder) 'Unités commandées'
from Product P
inner join Category C on P.CategoryId = C.CategoryId
group by C.CategoryId, C.Name

-- Avec Over(Partition By) :
select distinct C.CategoryId, C.Name,
		count(*) over(partition by C.CategoryId) 'Produits',
		sum(UnitsOnOrder) over(partition by C.CategoryId) 'Unités commandées'
from Product P
inner join Category C on P.CategoryId = C.CategoryId

-- On peut partitionner les lignes selon plusieurs critères.
-- Ex : Nombre de produits par catégorie et par fournisseur
select distinct C.Name as Catégorie, S.CompanyName as Fournisseur,
		count(*) over(partition by P.CategoryId, P.supplierId) as Produits
from Product P
inner join Category C on P.CategoryId = C.CategoryId
inner join Supplier S on P.SupplierId = S.SupplierId

-- over(partition by) ne peut pas être utilisé que dans les clauses
-- select et order by

------------------ ROW_NUMBER et RANK ----------------------------
-- Ces fonctions numérotent les lignes d'un résultat de façon globale ou à l'intérieur des partitions
-- Elles doivent être utilisées avec over(order by)

-- Exemple de classement global
-- Classement des catégories par rapport au nombre de produits qu'elles contiennent
select v.Catégorie, v.Produits,
	ROW_NUMBER() over(order by V.Produits desc) Rang
from (
	select c.Name as Catégorie, count(*) as Produits
	from Category c
	inner join Product p on c.CategoryId = p.CategoryId
	group by C.Name
) v

-- Avec Rank, il peut y avoir des lignes de rangs identiques
-- L'intervalle entre les valeurs correspond au nombre de lignes ayant le même rang
select v.Catégorie, v.Produits,
	RANK() over(order by V.Produits desc) Rang
from (
	select c.Name as Catégorie, count(*) as Produits
	from Category c
	inner join Product p on c.CategoryId = p.CategoryId
	group by C.Name
) v

-- Exemple de classement dans les partitions
-- Ex : Palmarès des produits les plus commandés dans chaque catégorie
select C.Name as Catégorie, P.Name as Produit, UnitsOnOrder as 'Unités commandées',
		RANK() over(partition by C.CategoryId order by C.Name, P.UnitsOnOrder desc) Classement
from Product P
inner join Category C on P.CategoryId = C.CategoryId

