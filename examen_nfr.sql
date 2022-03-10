
USE master
go

--Creamos una nueva BD con el nombre vuestras iniciales + Fecha de Hoy  db_nfr_10_marzo

drop database if exists  db_nfr_10_marzo
go

create database db_nfr_10_marzo
go


--utilizamos estas bd
use db_nfr_10_marzo
go

--usamos la tabla master

use master
go



--Generar Tabla usando como base la Tabla AdventureWorks2017/2019.Sales.SalesOrderHeader 
--con el nombre iniciales_fecha (ej. Table_cmm_16_marzo)

--Siempre comprobamos su existencia

drop table if exists Table_nfr_10_marzo
go

select * 
into Table_nfr_10_marzo
from AdventureWorks2019.[Sales].[SalesOrderHeader]
WHERE YEAR(OrderDate) = 2013
go


--(31465 rows affected)

--Completion time: 2022-03-10T18:26:10.7663300+01:00



--comprobamos los datos  y la vemos ordenada por el año 2013

select * from Table_nfr_10_marzo
go



-- Crear PARTICIÓN con campo orderdate. Demostrar Funcionamiento. 
-- Realizar las operaciones : SPLIT - TRUNCATE (por ejemplo, la Partición final)


--creamos una carpeta en c llamada data (que ya tenemso)



USE master
GO
-- CREAMOS EN C: UNA CARPETA LLAMADA Data y
DROP DATABASE IF EXISTS db_nfr_10_marzo
GO


USE db_nfr_10_marzo
GO

CREATE DATABASE [db_nfr_10_marzo]
ON PRIMARY ( NAME = 'Examen_NFR',
FILENAME = 'C:\Data\Examen_NFR_Fijo.mdf' ,
SIZE = 15360KB , MAXSIZE = UNLIMITED, FILEGROWTH = 0)
LOG ON ( NAME = 'Examen_NFR_log',
FILENAME = 'C:\Data\Examen_NFR_log.ldf' ,
SIZE = 10176KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
--creamos los filegroup

use db_nfr_10_marzo
go

select * from sys.filegroups
go


-------


alter database [db_nfr_10_marzo] add filegroup archivo_examen
go
alter database [db_nfr_10_marzo] add filegroup curso_2012
go
alter database [db_nfr_10_marzo] add filegroup curso_2013
go
alter database [db_nfr_10_marzo] add filegroup curso_2014
go


select * from sys.filegroups
go


alter database [db_nfr_10_marzo]
add file (
	name = 'archivo',
	filename = 'C:\data\archivo_examen.ndf',
	size = 100mb, 
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup archivo_examen
go

alter database [db_nfr_10_marzo]
add file (
	name = 'curso_2012',
	filename = 'C:\data\curso_2012.ndf',
	size = 100mb, 
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup curso_2012
go

alter database [db_nfr_10_marzo]
add file (
	name = 'curso_2013',
	filename = 'C:\data\curso_2013.ndf',
	size = 100mb, 
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup curso_2013
go

alter database [db_nfr_10_marzo]
add file (
	name = 'curso_2014',
	filename = 'C:\data\curso_2014.ndf',
	size = 100mb, 
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup curso_2014
go

--Commands completed successfully.

--Completion time: 2022-03-10T19:21:14.3801296+01:00

select * from sys.filegroups
go


use master 
go


--hacemos la particion, comprobamos que no exista

drop partition function fn_partition_nfr_10_marzo
go

use db_nfr_10_marzo
go

create partition function fn_partition_nfr_10_marzo (datetime)
as range right 
for values ('2012-1-1','2013-1-1','2014-1-1')
go


select * from sys.filegroups
go
---hacemos un partition scheme


CREATE PARTITION scheme scheme_nfr_10_marzo
AS PARTITION fn_partition_nfr_10_marzo
TO (archivo_examen, curso_2012, curso_2013, curso_2014)
GO


--Commands completed successfully.

--Completion time: 2022-03-10T19:12:18.4260512+01:00

select * from sys.database_files
GO
SELECT * from [db_nfr_10_marzo]
GO


DROP TABLE IF EXISTS Table1_nfr_10_marzo
GO
CREATE TABLE Table1_nfr_10_marzo
( id_alta int identity (1,1),
nombre varchar(20),
apellido varchar (20),
fecha_alta datetime,
fecha_baja datetime )
ON scheme scheme_nfr_10_marzo -- Esquema de la particion
(fecha_alta) -- Columna que aplica la funcion
GO
--Commands completed successfully.




select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'Table_nfr_10_marzo ' 
GO


--partition_number
--1


SELECT 
    partition_number,
    row_count
FROM sys.dm_db_partition_stats
WHERE object_id = OBJECT_ID('Table_nfr_10_marzo');
GO

--partition_number	row_count
--1	14182

--SPLIT

alter partition function fn_partition_nfr_10_marzo
split range (2012-01-01)
go



--funcion de la particion 

select name, create_date, value from sys.partition_functions f
inner join sys.partition_range_values rv
on f.function_id=rv.function_id
where f.name = 'fn_partition_nfr_10_marzo'
go


--name	create_date	value
--fn_partition_nfr_10_marzo	2022-03-10 19:30:29.583	2012-01-01 00:00:00.000
--fn_partition_nfr_10_marzo	2022-03-10 19:30:29.583	2013-01-01 00:00:00.000
--fn_partition_nfr_10_marzo	2022-03-10 19:30:29.583	2014-01-01 00:00:00.000











----PROCEDIMIENTO ALMACENADO



--Añadimos campos NOMBRE USUARIO y PASSWORD  a la Tabla iniciales_fecha (ej. Table_cmm_16_marzo)

use master
go


--ALTER TABLE tabla ADD namecolumna tipodato (numero);

select * 
	into [Table2_nfr_10_marzo]
	from AdventureWorks2019.Sales.SalesOrderHeader
go

select * from [dbo].[Table2_nfr_10_marzo]
go

alter table [dbo].[table_nfr_10_marzo]
add nombre varchar(50)
go

alter table [dbo].[table2_nfr_10_marzo]
add contrasena varchar (20)
go


select * from [dbo].[table2_nfr_10_marzo]
go


update [dbo].[table2_nfr_10_marzo]
set nombre = 'nuria', contrasena ='Abcd1234.'
where SalesOrderID=43659
go

update [dbo].[table2_nfr_10_marzo]
set username = 'noa', password ='Abcd1234.'
where SalesOrderID=43660
go









use master
go


---tabla temporal del sistema
USE [db_nfr_10_marzo]
GO
--creamos una tabla de reserva coche
--creamos una tabla de reserva coche


drop table if exists Table3_nfr_10_marzo



create table Table3_nfr_10_marzo(
DeptID int Primary Key Clustered,
DeptName varchar(50), 
DepCreado varchar(50) , 
NumEmpleados integer,
SysStartTime datetime2 generated always as row start not null,
SysEndTime datetime2 generated always as row end not null,
period for System_time (SysStartTime,SysEndTime)
)
with (System_Versioning = ON (History_Table = dbo.Table3_nfr_10_marzo_historico)
)
go
--Commands completed successfully.

--Completion time: 2022-03-10T20:12:53.8519192+01:00


--tabla vacia

select * from Table3_nfr_10_marzo
go


select * from dbo.Table3_nfr_10_marzo_historico
GO

--insertamos valores

insert into Table3_nfr_10_marzo (DeptID,DeptName,NumEmpleados)
values
('1','compras','3'),
('2','ventas','4'),
('3','rrhh','1')
GO---modifico num empleados rrhhupdate Table3_nfr_10_marzo set
NumEmpleados = 2
Where DeptID ='3'
select * from Table3_nfr_10_marzo
GO--vuelvo a consultar tablas
select * from Table3_nfr_10_marzo
go


select * from dbo.Table3_nfr_10_marzo_historico
GO



--for system_time all vemos todas las operaciones realizas en la tablaselect *
from Table3_nfr_10_marzo
for system_time all
go

--con between vemos los cambios que ha sufrido la tabla entre dos fechas determinadas,

select *
from Table3_nfr_10_marzo
for system_time between '2022-03-10 19:17:55.1379705' and '2022-03-10 19:20:17.0927432'
go


--CONTROL DE VERSIONES


