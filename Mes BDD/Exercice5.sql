-- Exercice 5

-- 1. Liste des mois des commandes, sous forme de chaîne au format YYYY.MM, sans doublons

select distinct format(OrderDate, 'yyyy.MM') as OrdersMonth from Orders
-- Sans la méthode format, on utilise convert et trouver le bon num de format ensuite avec left on affiche que année et mois

-- 2. Pour chaque produit, afficher le nom et le prix sans chiffre après la virgule

select Name, TRY_CAST(UnitPrice as int) from Product -- onfait le try si on risque de tomber sur un  NULL, ce n'est pas le cas ici, on peut faire juste cast
--on peut aussi le faire avec format

-- 3. Créer une nouvelle catégorie, un nouveau produit de cette catégorie pour le fournisseur 1 et une nouvelle ligne de commande avec ce produit pour la commande 10248

declare @CategoryId as uniqueidentifier -- Category n'est pas auto-incrémenté, leur Id sont générés par Guid donc @....
set @CategoryId = newid()

--nouvelle catégorie
insert Category (CategoryId, Name) 
values (@CategoryId, 'Drinks')

--nouveau produit de cette catégorie pour le fournisseur 1
insert Product(CategoryId, SupplierId, Name, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
values (@CategoryId, 1, 'Sprite', 1.50, 1000, 0, 1000, 0)

--nouvelle ligne de commande avec ce produit pour la commande 10248
insert OrderDetail(OrderId, ProductId, UnitPrice, Quantity, Discount)
values (10248, IDENT_CURRENT('Product'), 1.50, 1, 0)

select * from Category
select * from Product
select * from OrderDetail

-- 4. Créer une table Shipping pour l'historique des livraisons des livreurs.
-- Elle doit comporter une clé étrangère vers la table Shipper et des champs pour la date et heure de livraison et le nombre d'objets livrés
-- Sa clé primaire doit être un entier dont la valeur est générée automatiquement par une séquence Insérer deux lignes dans cette table et vérifier son contenu
 
create sequence ShippingSeq start with 1 increment by 1

CREATE TABLE Shipping 
(
   ShippingId int PRIMARY KEY CLUSTERED DEFAULT (NEXT VALUE FOR ShippingSeq), -- creation table avec sequence
   DeliveryDate Date NOT NULL, -- NOT NULL signifie obligatoire
   DeliveryHour DateTime NOT NULL,
   QuantityOfProducts INTEGER,
   NewShipperId Int NOT NULL
)

ALTER TABLE Shipping ADD CONSTRAINT Shipping_Shipper_FK
FOREIGN KEY(NewShipperId) REFERENCES Shipper(ShipperId)

select * from Shipping

insert Shipping(DeliveryDate, DeliveryHour, QuantityOfProducts, NewShipperId) -- si on met pas clustered default lors de la creation de seq on a pas besoin de définir le newshipperId avec @newshipperId dans la liste des attribus
values (getDate(), DatePart(HOUR, getDate()), 10, 1)

select * from Shipping

-- 5. Nombre d'adresses par région pour le Royaume Uni (UK). Afficher le nom de la région et le nombre d'adresses, en remplaçant le nom de la région par 'Aucune' pour les adresses sans région

select isnull(Region, 'Aucune'), count(AddressId) as NbAddress
from Address 
where Country = 'UK'
group by Region

-- 6. Pour chaque adresse, afficher une chaîne "pays - région" ou bien le pays seul s'il n'y a pas de région

select iif(Region is NULL, Country, Country + '-' + Region) from Address -- opérateur ternaire

backup database Essai to disk = N'C:\Users\Adminl\Desktop\Jeremy\BDD\backups\Northwind2.bak' with format 
