use PracticaPE
---------------------------------------------------------- P R A C T I C A   2 ---------------------------------------------------------------

--INTEGRANTES EQUIPO 2--
--OCAMPO CABRERA ASAEL
--ROBERT ROA KARLA GUADALUPE
--SANCHEZ VILLAGRANA OSMAR ROBERTO
----------------------------------------------------------------------------------------------------------------------------------------------

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
 Consulta A
 
 Listar el producto más vendido de cada una de las categorías registradas en la base de datos. 

 Responsable: Robert Roa Karla Guadalupe

******************************************************************************************************************/
WITH ProductoVentas as (
		select pc.ProductCategoryID, pc.Name as Categoria, p.ProductID, p.Name as Producto,
		sum(od.OrderQty) as TotalVendido
		from order_detail od
		inner join products p on od.ProductID = p.ProductID
		inner join product_subcat psc on p.ProductSubcategoryID = psc.ProductSubcategoryID
		inner join product_cat pc on psc.ProductCategoryID = pc.ProductCategoryID
		group by pc.ProductCategoryID, pc.Name, p.ProductID, p.Name),
MaxVentasPorCategoria as (select ProductCategoryID, max(TotalVendido) as MaxVendido 
							from ProductoVentas
							group by ProductCategoryID)
select pv.Categoria, pv.Producto, pv.TotalVendido
from ProductoVentas pv
inner join MaxVentasPorCategoria mvpc 
on pv.ProductCategoryID = mvpc.ProductCategoryID 
and pv.TotalVendido = mvpc.MaxVendido
order by pv.Categoria;
	

/***************************************************************************************************************
 Consulta B
 
 Listar el nombre de los clientes con más ordenes por cada uno de los territorios registrados en la base de datos.

 Responsable: Sánchez Villagrana Osmar Rroberto

******************************************************************************************************************/


with OrdenesPorCliente as (select soh.TerritoryID, soh.CustomerID, count(soh.SalesOrderID) as NumeroOrdenes
      from order_header soh
		group by soh.TerritoryID, soh.CustomerID), MaximoPorTerritorio as
		        (select TerritoryID, max(NumeroOrdenes) as MaxOrdenes
			            from OrdenesPorCliente
      group by TerritoryID)

select t.Name as Territorio, p.FirstName + ' ' + p.LastName as Cliente, opc.NumeroOrdenes
      from OrdenesPorCliente opc
           join MaximoPorTerritorio mpt on opc.TerritoryID = mpt.TerritoryID and opc.NumeroOrdenes = mpt.MaxOrdenes
                join customer c on opc.CustomerID = c.CustomerID
                     join person p on c.PersonID = p.BusinessEntityID
                          join territory t on opc.TerritoryID = t.TerritoryID
order by Territorio;

/***************************************************************************************************************
 Consulta C
 
 Listar los datos generales de las ordenes que tengan al menos los mismos productos de la orden con salesorderid =  43676.

 Responsable: Asael Ocampo Cabrera

******************************************************************************************************************/

create nonclustered index IDX_OrderDetail_SalesOrderID
on order_detail(SalesOrderID);

select distinct Salesorderid
from Order_Detail as OD	
where not exists (select *
					from (select productid
					from Order_Detail 
					where salesorderid=43676) as P
					where not exists (select *
										from Order_Detail  as OD2
										where OD.salesorderid = OD2.salesorderid
										and (OD2.productid = P.productid)));
