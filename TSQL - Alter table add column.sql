select * from [dbo].[CI_CD_INTEGRANTES_UC] 

alter TABLE [dbo].[CI_CD_INTEGRANTES_UC] 
add [COM_PRIMERA] [numeric](7, 2) NULL,
	[COM_RESTANTE] [numeric](7, 2) NULL,
	[FECHA_DESDE] [datetime] NULL,
	[COM_PRIMERA_PD] [numeric](7, 2) NULL,
	[COM_RESTANTE_PD] [numeric](7, 2) NULL,
	[FECHA_DESDE_PD] [datetime] NULL,
	[EN_SOCIA] [varchar](1) NULL;
) ON [PRIMARY]

GO


