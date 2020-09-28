sp_helpdb dw

sp_spaceused @updateusage = N'true'

dbcc shrinkfile(1,EMPTYFILE)

dbcc opentran