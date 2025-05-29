use PracticaPE

-- 2. COPIAR TABLAS DE BASE DE DATOS ADVENTUREWORKS2022 A LA NUEVA BASE DE DATOS
-- Copiar Tabla SalesOrderHeader
select* into order_header
from AdventureWorks2022.Sales.SalesOrderHeader

select *
from order_header

-- Copiar Tabla SalesOrderDetail
select* into order_detail
from AdventureWorks2022.Sales.SalesOrderDetail

select* 
from order_detail

-- Copiar Tabla Customer
select* into customer
from AdventureWorks2022.Sales.Customer

select* 
from customer

-- Copiar Tabla SalesTerritory
select* into territory
from AdventureWorks2022.Sales.SalesTerritory

select* 
from territory

-- Copiar Tabla Product
select* into products
from AdventureWorks2022.Production.Product

select* 
from products

-- Copiar Tabla ProductCategory
select* into product_cat
from AdventureWorks2022.Production.ProductCategory

select* 
from product_cat

-- Copiar Tabla ProductSubcategory
select* into product_subcat
from AdventureWorks2022.Production.ProductSubcategory

select* 
from product_subcat

-- Copiar Tabla Person
select BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, EmailPromotion
into person
from AdventureWorks2022.Person.Person;

select* 
from person


/***************************************************************************************************************
 Consulta B
 
 Listar el nombre de los clientes con más ordenes por cada uno de los territorios registrados en la base de datos.

 Responsable: Sánchez Villagrana Osmar Rroberto

******************************************************************************************************************/


WITH OrdenesPorCliente as 
    (select soh.TerritoryID, soh.CustomerID, count(soh.SalesOrderID) as NumeroOrdenes
    from dbo.SalesOrderHeader soh
    GROUP BY soh.TerritoryID, soh.CustomerID), MaximoPorTerritorio as 
                           (select TerritoryID, max(NumeroOrdenes) as MaxOrdenes
                            from OrdenesPorCliente
                             group by TerritoryID)

select t.Name as Territorio, p.FirstName + ' ' + p.LastName as Cliente, opc.NumeroOrdenes
    from OrdenesPorCliente opc
    join MaximoPorTerritorio mpt on opc.TerritoryID = mpt.TerritoryID and opc.NumeroOrdenes = mpt.MaxOrdenes
         join dbo.Customer c on opc.CustomerID = c.CustomerID
              join dbo.Person p on c.PersonID = p.BusinessEntityID
                   join dbo.SalesTerritory t on opc.TerritoryID = t.TerritoryID
order by Territorio;

