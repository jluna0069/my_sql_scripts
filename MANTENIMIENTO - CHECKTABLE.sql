-- Checking a specific table
-- The following example checks the data page integrity of the HumanResources.Employee table in the AdventureWorks database.
USE AdventureWorks2012;
GO
DBCC CHECKTABLE ("HumanResources.Employee");
GO



--B. Performing a low-overhead check of the table
--The following example performs a low overhead check of the Employee table in the AdventureWorks database.
USE AdventureWorks2012;
GO
DBCC CHECKTABLE ("HumanResources.Employee") WITH PHYSICAL_ONLY;
GO



--Checking a specific index
--The following example checks a specific index, obtained by accessing sys.indexes.
USE AdventureWorks2012;
GO
DBCC CHECKTABLE ("Production.Product", 'AK_Product_Name');