use piscys_rw
go

SELECT 
TOP 2000
tmp.id as id,
tmp.cuit as cuit,
gd.varCalleDesnormalizada+' '+gd.varNumero as calle,
gd.varLocDesnormalizada as localidad,
gp.varDescripcion as Descripcion1,
ge.varDescripcion as Descripcion2,
gt.intPrefijoPais+'-'+gt.intPrefijoCiudad+'-'+gt.intNumero as Numero,
ccc.chrCIIU as CIIU,
gc.varNombre as Nombre,
sc.intCantTrabajadores as Cantidad,
DATEDIFF(month, sc.datFechaInicioVigencia, getdate()) as Fecha,
(SELECT  TOP 1 intidvisita FROM PVN_Visitas WHERE intidempresa=ccc.intidcliente) as IDVisita
INTO ##temporal_ada
FROM ##tmp_empresas tmp
INNER  JOIN COM_Clientes cc  ON cc.chrCUITCUILCDI=tmp.cuit
INNER JOIN  COM_DomiciliosCliente cdc ON cdc.intIdCliente=cc.intIdCliente
INNER JOIN GEN_Domicilios gd ON gd.intIdDomicilio=cdc.intIdDomicilio
INNER JOIN GEN_Provincias gp ON gp.intIdProvincia=gd.intIdProvDesnormalizada
INNER JOIN COM_EmailsCliente cec ON cec.intIdCliente=cc.intIdCliente
INNER JOIN GEN_Emails ge ON ge.intIdEmail=cec.intIdEmail
INNER JOIN COM_TelefonosCliente ctc ON ctc.intIdCliente=cc.intIdCliente
INNER JOIN GEN_Telefonos gt ON gt.intIdTelefono=ctc.intIdTelefono
INNER JOIN COM_CIIUsCliente ccc ON ccc.intIdCliente=cc.intIdCliente AND ccc.chrTipo='N'
INNER JOIN GEN_CIIUs gc ON gc.chrCIIU=ccc.chrCIIU
INNER JOIN SYA_Contratos sc ON sc.intIdCliente=cc.intIdCliente
WHERE sc.intIdEstado=2

SELECT t.id, t.cuit, t.calle, t.localidad, t.fecha,t.IDVisita,t.rowid FROM 
(SELECT id,cuit,calle,localidad,fecha,IDVisita,rowid=ROW_NUMBER() OVER (PARTITION BY cuit order by id)
 FROM ##temporal_ada	) t where rowid < 2


--drop table ##temporal_ada