/*conrol*/
restore filelistonly from DISK = N'\\spmacf01\B$\Backup_Full\CH_ICF_PROVEEDORES_001.Bak'  
restore filelistonly from DISK = N'\\spmacf01\R$\Backup_Full\CH_ICF_PROVEEDORES_002.Bak'  

/*restore*/
restore database CH_ICF_PROVEEDORES
from 
DISK = N'\\spmacf01\B$\Backup_Full\CH_ICF_PROVEEDORES_001.Bak',  
DISK = N'\\spmacf01\R$\Backup_Full\CH_ICF_PROVEEDORES_002.Bak'
WITH  replace ,STATS = 1,
move 'CH_ICF_PROVEEDORES_Data_001' to 'h:\MSSQL10.SQLICFCL\MSSQL\DATA\CH_ICF_PROVEEDORES_Data_001.MDF' ,
move 'CH_ICF_PROVEEDORES_Data_002' to 'h:\MSSQL10.SQLICFCL\MSSQL\DATA\CH_ICF_PROVEEDORES_Data_002.NDF' ,
move 'CH_ICF_PROVEEDORES_Log' to 'i:\MSSQL10.SQLICFCL\MSSQL\DATA\CH_ICF_PROVEEDORES_Log.LDF'
go