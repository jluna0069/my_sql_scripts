/*conrol*/
restore filelistonly from disk = '\\d095nwsqdes01\e$\Backup_full\EAI_Params.bak'

/*restore*/
restore database EAI_Params from disk = '\\d095nwsqdes01\e$\Backup_full\EAI_Params.bak'
with replace , stats = 1, 
move 'EAI_Params_Data' to 'R:\MSSQL.2\MSSQL\DATA\EAI_Params_Data.MDF' ,
move 'EAI_Params_Log' to 'R:\MSSQL.2\MSSQL\DATA\EAI_Params_Log.LDF'
go