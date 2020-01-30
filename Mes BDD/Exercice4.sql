-- 1. Nombre d'entreprises clientes et fournisseuses groupées par première lettre du nom

select left(CompanyName, 1), 'client' name, count(CompanyName) as SupplierCompany
from Supplier
group by left(CompanyName, 1)
union all
select left(CompanyName, 1), 'fournisseur' name, count(CompanyName) as CustomerCompany
from Customer
group by left(CompanyName, 1)
order by left(CompanyName, 1)

-- 2. Liste des prénoms communs entres clients et fournisseurs

select substring(contactname,1,charindex(' ',contactname))
from supplier
intersect
select substring(contactname,1,charindex(' ',contactname))
from customer

-- 3. Titre des contacts (ContactTitle) de clients qui sont différents de ceux des fournisseurs

select ContactTitlefrom Customer
except
select ContactTiltle
from Supplier



