-- Union
-- Réunit les éléments des deux ensembles
select distinct ContactTitle from Supplier where ContactTitle like '%Manager%'
union
select distinct ContactTitle from Customer where ContactTitle like '%Manager%'
-- union élimine les doublons, tandis qu'union all les garde

-- Intersection
-- Sélectionne les éléments communs aux deux ensembles
select distinct ContactTitle from Supplier where ContactTitle like '%Manager%'
intersect
select distinct ContactTitle from Customer where ContactTitle like '%Manager%'

-- Différence
-- Sélectionne les éléments du premier ensemble qui ne figurent pas dans le second
select distinct ContactTitle from Supplier where ContactTitle like '%Manager%'
except
select distinct ContactTitle from Customer where ContactTitle like '%Manager%'
