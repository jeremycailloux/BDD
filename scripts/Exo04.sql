-- 1. Nombre d'entreprises clientes et fournisseuses groupées par première lettre du nom
/* Exemple : 
A	Client		4
A	Fournisseur	1
B	Client		7
B	Fournisseur	1
...
*/
select left(CompanyName, 1), 'Client' as Type, count(*) Nb from Customer group by left(CompanyName, 1) 
union
select left(CompanyName, 1), 'Fournisseur', count(*) from Supplier group by left(CompanyName, 1) 
order by 1


-- 2. Liste des prénoms communs entres clients et fournisseurs
-- NB/ le prénom est contenu dans le champ ContactName
select SUBSTRING(contactname, 1, CHARINDEX(' ', contactname)) from Customers
intersect
select SUBSTRING(contactname, 1, CHARINDEX(' ', contactname)) from Suppliers

-- 3. Titre des contacts de clients qui sont différents de ceux des fournisseurs
select ContactTitle from Customer
except
select ContactTitle from Supplier
