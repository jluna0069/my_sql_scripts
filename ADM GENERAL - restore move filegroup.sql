/*conrol*/

restore filelistonly from DISK='F:\Backup_full\CTC_FULL_1.BKP'
restore filelistonly from DISK='J:\Backup_full\CTC_FULL_2.BKP'
restore filelistonly from DISK='K:\Backup_full\CTC_FULL_3.BKP'

alter database  set restricted_user with rollback immediate
GO

--Restore
RESTORE DATABASE prueba FILEGROUP = 'PRIMARY'
FROM 
DISK= 'F:\Backup_full\CTC_FULL_1.BKP',
DISK= 'J:\Backup_full\CTC_FULL_2.BKP',
DISK= 'K:\Backup_full\CTC_FULL_3.BKP'
with partial , stats = 1, 
move 'CTC_Data' to 'J:\CTC_Data.MDF',
move 'CTC_Data_002' to 'J:\CTC_Data_002.NDF',
move 'CTC_Data_003' to 'J:\CTC_Data_003.NDF',
move 'CTC_Data_004' to 'J:\CTC_Data_004.NDF',
move 'CTC_Log' to 'K:\CTC_Log.LDF'
GO