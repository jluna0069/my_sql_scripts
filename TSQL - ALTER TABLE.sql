USE [gesproSegui]
GO
/****** Object:  Table [dbo].[informe_seg_cab]    Script Date: 05/30/2011 11:07:22 ******/
ALTER TABLE [dbo].[informe_seg_cab]
ADD	[editar_fechas_etapas] [bit] NOT NULL CONSTRAINT [DF_informe_seg_cab_editar_fechas_etapas]  DEFAULT (0)
GO
