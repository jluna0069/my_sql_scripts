/*ULTIMO DIA DEL MES ANTERIOR A LA FECHA DE SISTEMA*/
SELECT LAST_DAY(add_months(CURRENT_DATE,-1)) FROM dual;

/*ULTIMO DIA DEL MES ANTERIOR DE UNA FECHA FIJA*/
SELECT LAST_DAY(add_months(TO_DATE('01/01/2012', 'DD/MM/YYYY'),-1)) FROM dual;

/*CONVERTIR LA FECHA ACTUAL DEL SISTEMA A JULIANA*/
SELECT TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'J') from DUAL;

/*CONVERTIR A JULIANA EL ULTIMO DEIA DEL MES ANTERIOR*/
SELECT TO_CHAR(LAST_DAY(add_months(TO_DATE('01/01/2012', 'DD/MM/YYYY'),-1)), 'J') from DUAL;


/*EXTRAER MES Y AÑO*/
SELECT TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'MM') FROM dual;
SELECT TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YYYY') FROM dual;
SELECT TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YY') FROM dual;

/*CANTIDAD DE DIAS DE PRINCIPIO DE AÑO AL ULTIMO DIA DEL MES ANTERIOR A LA FECHA DEL ACTUAL DEL SISTEMA*/
SELECT ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/2012', 'DD/MM/YYYY')) FROM dual;


/*PASAJE A CHAR*/

SELECT TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/2012', 'DD/MM/YYYY'))) FROM dual;

/*CONCATENAR CADENAS ||*/

SELECT '1' || TO_CHAR(TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YY')) || TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/2012', 'DD/MM/YYYY'))) FROM dual;


/*CANTIDAD DE CARACTERES*/

SELECT length('12') FROM dual;


/*REPLICAR CHAR*/

SELECT rpad('0', 2) FROM dual;


/*CASE SACAR SI HAY QUE AGREGAR CEROS O NO*/

SELECT CASE WHEN length(TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/2012', 'DD/MM/YYYY')))) = 1 THEN  '00' 
WHEN length(TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/2012', 'DD/MM/YYYY')))) = 2 THEN '0' END FROM dual;


/*CONVERTIR A FECHA DE JDE  
La fecha seria 112060

1=Fijo
12= Año
060= diferencia en días desde el 1/1/12 al 29/2/2012
*/


SELECT '1' || TO_CHAR(TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YY')) ||
CASE WHEN length(TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/2012', 'DD/MM/YYYY')))) = 1 THEN  '00' 
WHEN length(TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/2012', 'DD/MM/YYYY')))) = 2 THEN '0' END ||
TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/2012', 'DD/MM/YYYY')))
FROM dual;

/*concatenar el ultimo año*/

SELECT '01/01/' || TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YYYY') FROM dual;


/*variables esto tiene algun quilombo*/

declare

V_fechaHasta CHAR(6);
V_fechaDesde CHAR(6);

begin

SELECT '1' || TO_CHAR(TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YY')) ||
CASE WHEN length(TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/2012', 'DD/MM/YYYY')))) = 1 THEN  '00' 
WHEN length(TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/2012', 'DD/MM/YYYY')))) = 2 THEN '0' END ||
TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/2012', 'DD/MM/YYYY')))
into  V_fechaHasta
FROM dual;

SELECT '1' || TO_CHAR(TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YY')) ||
CASE WHEN length(TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-2)) - TO_DATE('01/01/2012', 'DD/MM/YYYY')))) = 1 THEN  '00' 
WHEN length(TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-2)) - TO_DATE('01/01/2012', 'DD/MM/YYYY')))) = 2 THEN '0' END ||
TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-2)) - TO_DATE('01/01/2012', 'DD/MM/YYYY')))
into  V_fechaDesde
FROM dual;

/*dbms_output.put_line('Name: '||TO_NUMBER(V_fechaDesde,999999)||' '||TO_NUMBER(V_fechaHasta,999999));*/

SELECT T0.ABAN8, T0.ABTAX, T0.ABALPH, T1.SDKCOO, T1.SDDOCO, T1.SDDCTO, T1.SDLNID, T1.SDMCU, T1.SDCO, T1.SDAN8, T1.SDDGL, T1.SDITM, T1.SDLITM, T1.SDAITM, T1.SDDSC1, T1.SDDSC2, T1.SDEMCU, T1.SDUORG, T1.SDUPRC, T1.SDAEXP, T1.SDDCT, T1.SDCRCD, T1.SDBCRC, '' Nuevo, 0 VDASEG,0 VDPROD,0 VDORGA,'' VDNOMB
FROM PRODDTA.F0101 T0,PRODDTA.F4211 T1
WHERE  (  ( T1.SDDGL >= TO_NUMBER(:V_fechaDesde,999999)  AND T1.SDDGL <= TO_NUMBER(:V_fechaHasta,999999)
AND T1.SDDCT IN  ( 'NC','ND','RI' ) 
AND T1.SDLITM <> 'REBATE'
AND T0.ABTAX NOT IN  ( '30624259269','30686273330','34500045339'))) 
AND  ( T0.ABAN8=T1.SDAN8 );

end;


/*final en los case se puede hacer la suma de un como esta o poner >= para no sumar un digito a la fecha.*/

SELECT T0.ABAN8,
  T0.ABTAX,
  T0.ABALPH,
  T1.SDMCU,
  T1.SDAN8,
  T1.SDDGL,
  T1.SDITM,
  T1.SDLITM,
  T1.SDAITM,
  T1.SDDSC1,
  T1.SDDSC2,
  T1.SDUORG,
  T1.SDUPRC,
  T1.SDAEXP,
  ' ' Nuevo, 
  0 VDASEG,
  0 VDPROD,
  0 VDORGA,
  ' ' VDNOMB
FROM PRODDTA.F0101 T0,
  PRODDTA.F4211 T1
WHERE ( ( T1.SDDGL >
  (SELECT '1'
    || TO_CHAR(TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YY'))
    ||
    CASE
      WHEN LENGTH(TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-2)) - TO_DATE('01/01/' || TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YYYY'), 'DD/MM/YYYY')))) = 1
      THEN '00'
      WHEN LENGTH(TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-2)) - TO_DATE('01/01/' || TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YYYY'), 'DD/MM/YYYY')))) = 2
      THEN '0'
    END
    || TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-2)) - TO_DATE('01/01/' || TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YYYY'), 'DD/MM/YYYY')))
  FROM dual
  )
AND T1.SDDGL <=
  (SELECT '1'
    || TO_CHAR(TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YY'))
    ||
    CASE
      WHEN LENGTH(TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/' || TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YYYY'), 'DD/MM/YYYY')))) = 1
      THEN '00'
      WHEN LENGTH(TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/' || TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YYYY'), 'DD/MM/YYYY')))) = 2
      THEN '0'
    END
    || TO_CHAR(ROUND(LAST_DAY(add_months(CURRENT_DATE,-1)) - TO_DATE('01/01/' || TO_CHAR(LAST_DAY(add_months(CURRENT_DATE,-1)), 'YYYY'), 'DD/MM/YYYY')))
  FROM dual
  )
AND T1.SDDCT     IN ( 'NC','ND','RI' )
AND T1.SDLITM    <> 'REBATE'
AND T0.ABTAX NOT IN ( '30624259269','30686273330','34500045339')))
AND ( T0.ABAN8    =T1.SDAN8 );




/*conversion de jualian en SQL Server acen510*/

select substring(ltrim(rtrim(chrNroCUIT)),1,11) as chrNroCUIT, 
intNroCliente,
DateAdd (d, datFechaPrimerConsumo - ((datFechaPrimerConsumo / 1000) * 1000), convert(datetime, str((datFechaPrimerConsumo / 1000) + 1900 ) + '0101')) - 1 as datFechaPrimerConsumo,
DateAdd (d, datFechaUltimoConsumo - ((datFechaUltimoConsumo / 1000) * 1000), convert(datetime, str((datFechaUltimoConsumo / 1000) + 1900 ) + '0101')) - 1 as datFechaUltimoConsumo,
monImporteFacturado 
from [TMP_AS_ConsumoAS]