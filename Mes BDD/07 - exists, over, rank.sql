------------------ EXISTS -----------------------------
-- Salari�s qui sont managers
select * from Employee E
where exists
(select EmployeeID from Employee where ReportsTo = E.EmployeeID)

-- Salari�s qui ne sont pas managers
select * from Employee E
where not exists
(select EmployeeID from Employee where ReportsTo = E.EmployeeID)

-- Autre m�thode :
select EmployeeID from Employee
intersect 
select ReportsTo from Employee

-- La requ�te suivante ram�ne les titres de fournisseurs contenant Manager
-- et qui n'ont pas d'�quivalent parmi les titres des clients
select distinct ContactTitle from Supplier where ContactTitle like '%Manager%'
except
select distinct ContactTitle from Customer where ContactTitle like '%Manager%'

-- On peut aussi l'�crire de la fa�on suivante :
select distinct ContactTitle from Supplier S
where ContactTitle like '%Manager%'
and not exists (select ContactTitle from Customer C where ContactTitle = S.ContactTitle)

------------------ OVER PARTITION BY -----------------------------
-- Permet entre autres de faire des calculs d'agr�gat sur chaque ligne

-- Un calcul d'agr�gat avec group by produit une ligne de r�sultat par groupe
-- Ex : Nombre de produits par cat�gorie --> 8 lignes (autant que de cat�gories)
select C.CategoryId, C.Name, count(*) NBProduits
from Product P
inner join Category C on P.CategoryId = C.CategoryId
group by C.CategoryId, C.Name

-- over(partition by) permet �galement de calculer un agr�gat,
-- mais affiche son r�sultat sur chaque ligne du d�tail
-- Ex : Nombre de produits par cat�gorie --> 77 lignes (autant que de produits)
select C.CategoryId, C.Name,
		count(*) over(partition by C.CategoryId) NBProduits
from Product P
inner join Category C on P.CategoryId = C.CategoryId

-- on peut supprimer les doublons avec distinct :
select distinct C.CategoryId, C.Name,
		count(*) over(partition by C.CategoryId) NBProduits
from Product P
inner join Category C on P.CategoryId = C.CategoryId

-- L'avantage de over est qu'on peut facilement calculer plusieurs agr�gats � la fois sans sous-requ�tes
-- Ex : Pour chaque cat�gorie, on veut afficher le nombre de produits
-- et le nombre d'unit�s de produits en cours de commande

-- Avec group by :
select C.CategoryId, C.Name,
	(select count(*) from Product where CategoryId = C.CategoryId) 'Produits', 
	sum(UnitsOnOrder) 'Unit�s command�es'
from Product P
inner join Category C on P.CategoryId = C.CategoryId
group by C.CategoryId, C.Name

-- Avec Over(Partition By) :
select distinct C.CategoryId, C.Name,
		count(*) over(partition by C.CategoryId) 'Produits',
		sum(UnitsOnOrder) over(partition by C.CategoryId) 'Unit�s command�es'
from Product P
inner join Category C on P.CategoryId = C.CategoryId

-- On peut partitionner les lignes selon plusieurs crit�res.
-- Ex : Nombre de produits par cat�gorie et par fournisseur
select distinct C.Name as Cat�gorie, S.CompanyName as Fournisseur,
		count(*) over(partition by P.CategoryId, P.supplierId) as Produits
from Product P
inner join Category C on P.CategoryId = C.CategoryId
inner join Supplier S on P.SupplierId = S.SupplierId

-- over(partition by) ne peut pas �tre utilis� que dans les clauses
-- select et order by

------------------ ROW_NUMBER et RANK ----------------------------
-- Ces fonctions num�rotent les lignes d'un r�sultat de fa�on globale ou � l'int�rieur des partitions
-- Elles doivent �tre utilis�es avec over(order by)

-- Exemple de classement global
-- Classement des cat�gories par rapport au nombre de produits qu'elles contiennent
select v.Cat�gorie, v.Produits,
	ROW_NUMBER() over(order by V.Produits desc) Rang
from (
	select c.Name as Cat�gorie, count(*) as Produits
	from Category c
	inner join Product p on c.CategoryId = p.CategoryId
	group by C.Name
) v

-- Avec Rank, il peut y avoir des lignes de rangs identiques
-- L'intervalle entre les valeurs correspond au nombre de lignes ayant le m�me rang
select v.Cat�gorie, v.Produits,
	RANK() over(order by V.Produits desc) Rang
from (
	select c.Name as Cat�gorie, count(*) as Produits
	from Category c
	inner join Product p on c.CategoryId = p.CategoryId
	group by C.Name
) v

-- Exemple de classement dans les partitions
-- Ex : Palmar�s des produits les plus command�s dans chaque cat�gorie
select C.Name as Cat�gorie, P.Name as Produit, UnitsOnOrder as 'Unit�s command�es',
		RANK() over(partition by C.CategoryId order by C.Name, P.UnitsOnOrder desc) Classement
from Product P
inner join Category C on P.CategoryId = C.CategoryId

