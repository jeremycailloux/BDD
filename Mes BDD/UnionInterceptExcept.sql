-- Union
--Réunit les éléments des deux ensembles
select distinct ContactTitle from Supplier where ContactTitle like '%Manager%'
union all -- Inclu les doublons
select distinct ContactTitle from Customer where ContactTitle like '%Manager%'

select distinct ContactTitle from Supplier where ContactTitle like '%Manager%'
union -- Elimine les doublons
select distinct ContactTitle from Customer where ContactTitle like '%Manager%'


-- Intersect
select distinct ContactTitle from Supplier where ContactTitle like '%Manager%'
intersect
select distinct ContactTitle from Customer where ContactTitle like '%Manager%'


-- Except
select distinct ContactTitle from Supplier where ContactTitle like '%Manager%'
except
select distinct ContactTitle from Customer where ContactTitle like '%Manager%'