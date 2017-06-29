 declare @dbs table(name sysname,size float, space float, status bit)
 Declare @sql varchar(1000)
 set @sql = 'DBCC SQLPERF(''Logspace'')'
 insert into @dbs
 exec(@sql)
 select * from @dbs where name like 'LodgingInventoryMaster%' 