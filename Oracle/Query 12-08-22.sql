SELECT DISTINCT  * FROM USRFINDATA.STG_VPIDSCAF@BSIBPDW0@UFINRIE
WHERE FEC_CIERRE = '31/07/2022' AND FEC_VENCTO > '31/07/22' AND FEC_VENCTO < '15/08/22'  

AND COD_CONTRATO = '1101170100092270'

 AND COD_CONTRATO = '1101170100092270'

SELECT * FROM USRFINDATA.STG_VPIDSCAF@BSIBPDW0@UFINRIE
WHERE FEC_CIERRE >= '30/06/2022' AND COD_CONTRATO='001109679800041843'



SELECT COD_PRODUCTO FROM USRFINDATA.STG_VPIDSCAF@BSIBPDW0@UFINRIE
GROUP BY COD_PRODUCTO


-----------------------------------------------------------

SELECT FEC_PROCESO,DES_OFICINA,DES_TERRITORIO,DES_BANCA,COD_GESTOR,COD_CLIENTE,COD_CONTRATO
,(C.NOMBRE1||C.NOMBRE2||C.NOMBRE3)  as DES_CLIENTE,
DES_EPIGRAFE,SUM(IMP_SALMECTR),SUM(IMP_SALPUCTR)
FROM USRFINDATA.STG_SALDOIDA7V@BSIBPDW0@UFINRIE A
JOIN USRFINDATA.STG_EPIGRAFEG@BSIBPDW0@UFINRIE EG ON A.COD_EPIWEB >= EG.LIMITE_INF AND A.COD_EPIWEB < EG.LIMITE_SUP AND EG.CLASE = 'BBA' AND 
  EG.ORDEN IN ('50')
JOIN (SELECT * FROM USRFINDATA.ODS_OFICINA@BSIBPDW0@UFINRIE
                where FECPRO IN (select max(FECPRO) from USRFINDATA.ODS_OFICINA@BSIBPDW0@UFINRIE) )
             B ON A.COD_OFICINA=B.COD_OFICINA  AND B.COD_BANCA IN ('2685','2661')
LEFT JOIN (           
           SELECT * FROM USRFINDATA.stg_pe01@BSIBPDW0@UFINRIE WHERE fecpro=(SELECT MAX(fecpro) FROM USRFINDATA.stg_pe01@BSIBPDW0@UFINRIE ) 
           ) C ON A.COD_CLIENTE=C.CENTRAL


WHERE FEC_PROCESO IN (SELECT FEC_ULTMES FROM USRFINDATA.ODS_CALENDARIO@BSIBPDW0@UFINRIE 
WHERE FEC_ULTMES >= '01/06/2022' AND FEC_ULTMES < SYSDATE GROUP BY FEC_ULTMES)
 
GROUP BY  COD_GESTOR,COD_CLIENTE,COD_CONTRATO,DES_EPIGRAFE,FEC_PROCESO,DES_OFICINA,DES_TERRITORIO,DES_BANCA,(C.NOMBRE1||C.NOMBRE2||C.NOMBRE3)

--
SELECT * FROM USRFINDATA.STG_SALDOIDA7V@BSIBPDW0@UFINRIE

SELECT * FROM USRFINDATA.ODS_CALENDARIO@BSIBPDW0@UFINRIE 


------------------------------------------------------------------

SELECT *
FROM USRFINDATA.STG_SALDOIDA7V@BSIBPDW0@UFINRIE A
JOIN USRFINDATA.STG_EPIGRAFEG@BSIBPDW0@UFINRIE EG ON A.COD_EPIWEB >= EG.LIMITE_INF AND A.COD_EPIWEB < EG.LIMITE_SUP AND EG.CLASE = 'BBA' AND 
  EG.ORDEN IN ('50')
JOIN (select * from USRFINDATA.ODS_OFICINA@BSIBPDW0@UFINRIE
                where  FECPRO in (select max(fecPRO) from USRFINDATA.ODS_OFICINA@BSIBPDW0@UFINRIE) )
             B ON A.COD_OFICINA=B.COD_OFICINA  AND B.COD_BANCA IN ('2685','2661')
LEFT JOIN (           
           SELECT * FROM USRFINDATA.stg_pe01@BSIBPDW0@UFINRIE WHERE fecpro=(SELECT MAX(fecpro) FROM USRFINDATA.stg_pe01@BSIBPDW0@UFINRIE ) 
           ) C ON A.COD_CLIENTE=C.CENTRAL

WHERE FEC_PROCESO = '11/08/2022' AND COD_CONTRATO = '001103779800220902'

--IN (SELECT FEC_ULTMES FROM USRFINDATA.ODS_CALENDARIO@BSIBPDW0@UFINRIE 
--WHERE FEC_ULTMES > '01/01/2022' AND FEC_ULTMES < SYSDATE GROUP BY FEC_ULTMES)
 
GROUP BY  COD_GESTOR,COD_CLIENTE,DES_EPIGRAFE,FEC_PROCESO,DES_OFICINA,DES_TERRITORIO,DES_BANCA,(C.NOMBRE1||C.NOMBRE2||C.NOMBRE3)

----------------------------------------------------------------------------


SELECT *
FROM (
    SELECT 
        FINFO,
        case 
        --when CODEPW IN('0159501' ,'0159502') then 'CARTERA' 
        --when CODEPW IN ('0159601' , '0159602') then 'LEASING' 
        --when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE >394 then 'PCOM_LARGO'
        --when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE <=394 then 'PCOM_CORTO'
        --when (CODEPW >= '0161710' AND CODEPW <= '0161730') then 'COMEX'
        --WHEN (CODEPW in ( '0162000','0161900','0163000')) THEN 'TKT'
        WHEN (CODEPW in ( '0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265')) THEN 'CARTA FIANZA'
        --WHEN (CODEPW in ( '0164000')) THEN 'RESTO EMPRESAS'
        END AS PRODUCTO_FACTURACION,
        CASE
        WHEN COD_SUPRAREA  = '1676' THEN 'CIB'
        WHEN COD_SUPRAREA  = '1685' THEN 'BE'
        WHEN COD_SUPRAREA  = '1664' THEN 'BANCA_COMERCIAL'
        else 'OTROS'
        end BANCA,
        case
        when CODSEG='10100' THEN 'CORPORATIVO GESTION GLOBAL'
        when CODSEG='10200' THEN 'CORPORATIVO GESTION LOCAL'
        when CODSEG='30100' THEN 'EMPRESA GRANDE'
        when CODSEG='30200' THEN 'EMPRESA MEDIANA'
        when CODSEG='30300' THEN 'EMPRESA PEQUE�A'
        ELSE 'OTROS'
        END AS SEGMENTO,
        CODDIV AS DIVISA,
        FECAPE AS FECHA_ALTA,
        CASE WHEN CODEPW IN ('0160013') THEN 1 ELSE 0 END AS FLAG_REACTIVA,
        CASE WHEN CODEPW IN ('0160012') THEN 1 ELSE 0 END AS FLAG_FONDO_CRECER,
        DES_TERRITORIO,
        CONCAT('A',NUMCNT), 
        DES_OFICINA,
        CODCLI,
        COUNT(1) AS TOTAL,
        sum(case WHEN NUMOPE=1 then 1 else 0 end) as ALTAS,
        sum(cast(impsol as float)) as MONTO,
        CASE 
          WHEN sum(cast(impsol as float))=0 THEN 0 
          else sum(cast(impsol as float)*cast(CASE WHEN (CODEPW in ( '0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265')) THEN COMFIA ELSE TASOPE END as float)/100)/sum(cast(impsol as float)) end as TEA,
        CASE WHEN sum(cast(impsol as float))=0 THEN 0 else sum(cast(impsol as float)*cast(CASE WHEN (CODEPW in ( '0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265')) THEN COMFIA ELSE SPRNOR END as float)/100)/sum(cast(impsol as float)) end as SPREAD

    FROM USRFINDATA.STG_FACTUNICAM@BSIBPDW0@UFINRIE f
    left join ( SELECT   * FROM USRFINDATA.ODS_OFICINA@BSIBPDW0@UFINRIE  ) O
    ON F.CODOFI= O.COD_OFICINA and F.FINFO=O.PERIODO
    WHERE f.FINFO>='201901'
    AND COD_SUPRAREA  = '1685'
    AND (
    CODEPW IN('0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265','0164000') OR 
    (CODEPW >= '0160010' AND CODEPW <= '0160040') OR 
    (CODEPW >= '0161710' AND CODEPW <= '0161730') 
     ) AND 
    CODCPT_R IN ('201','216','228','291','294','295','296','271','272','273','274','275')
    group by
      FINFO,
      case 
      --when CODEPW IN('0159501' ,'0159502') then 'CARTERA' 
      --when CODEPW IN ('0159601' , '0159602') then 'LEASING' 
      --when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE >394 then 'PCOM_LARGO'
      --when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE <=394 then 'PCOM_CORTO'
      --when (CODEPW >= '0161710' AND CODEPW <= '0161730') then 'COMEX'
      --WHEN (CODEPW in ( '0162000','0161900','0163000')) THEN 'TKT'
      WHEN (CODEPW in ( '0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265')) THEN 'CARTA FIANZA'
      --WHEN (CODEPW in ( '0164000')) THEN 'RESTO EMPRESAS'
      END,
      CASE
      WHEN COD_SUPRAREA  = '1676' THEN 'CIB'
      WHEN COD_SUPRAREA  = '1685' THEN 'BE'
      WHEN COD_SUPRAREA  = '1664' THEN 'BANCA_COMERCIAL'
      else 'OTROS'
      end,
      case
      when CODSEG='10100' THEN 'CORPORATIVO GESTION GLOBAL'
      when CODSEG='10200' THEN 'CORPORATIVO GESTION LOCAL'
      when CODSEG='30100' THEN 'EMPRESA GRANDE'
      when CODSEG='30200' THEN 'EMPRESA MEDIANA'
      when CODSEG='30300' THEN 'EMPRESA PEQUE�A'
      ELSE 'OTROS'
      END,
      CODDIV,
      FECAPE,
      CASE WHEN CODEPW IN ('0160013') THEN 1 ELSE 0 END,
      CASE WHEN CODEPW IN ('0160012') THEN 1 ELSE 0 END,
      DES_TERRITORIO,
      CONCAT('A',NUMCNT),
      DES_OFICINA,
      CODCLI
    UNION ALL
    SELECT 
      FINFO,
      case 
      --when CODEPW IN('0159501' ,'0159502') then 'CARTERA' 
      --when CODEPW IN ('0159601' , '0159602') then 'LEASING' 
      --when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE >394 then 'PCOM_LARGO'
      --when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE <=394 then 'PCOM_CORTO'
      --when (CODEPW >= '0161710' AND CODEPW <= '0161730') then 'COMEX'
      --WHEN (CODEPW in ( '0162000','0161900','0163000')) THEN 'TKT'
      WHEN (CODEPW in ( '0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265')) THEN 'CARTA FIANZA'
      --WHEN (CODEPW in ( '0164000')) THEN 'RESTO EMPRESAS'
      END AS PRODUCTO_FACTURACION,
      CASE
      WHEN COD_SUPRAREA  = '1676' THEN 'CIB'
      WHEN COD_SUPRAREA  = '1685' THEN 'BE'
      WHEN COD_SUPRAREA  = '1664' THEN 'BANCA_COMERCIAL'
      else 'OTROS'
      end BANCA,
      case
      when CODSEG='10100' THEN 'CORPORATIVO GESTION GLOBAL'
      when CODSEG='10200' THEN 'CORPORATIVO GESTION LOCAL'
      when CODSEG='30100' THEN 'EMPRESA GRANDE'
      when CODSEG='30200' THEN 'EMPRESA MEDIANA'
      when CODSEG='30300' THEN 'EMPRESA PEQUE�A'
      ELSE 'OTROS'
      END AS SEGMENTO,
      CODDIV AS DIVISA,
      FECAPE AS FECHA_ALTA,
      CASE WHEN CODEPW IN ('0160013') THEN 1 ELSE 0 END AS FLAG_REACTIVA,
      CASE WHEN CODEPW IN ('0160012') THEN 1 ELSE 0 END AS FLAG_FONDO_CRECER,
      DES_TERRITORIO,
      CONCAT('A',NUMCNT),
      DES_OFICINA,
      CODCLI,
      COUNT(1) AS TOTAL,
      sum(case WHEN NUMOPE=1 then 1 else 0 end) as ALTAS,
      sum(cast(impsol as float)) as MONTO,
      CASE 
        WHEN sum(cast(impsol as float))=0 THEN 0 
        else sum(cast(impsol as float)*cast(CASE WHEN (CODEPW in ( '0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265')) THEN COMFIA ELSE TASOPE END as float)/100)/sum(cast(impsol as float)) end as TEA,
      CASE WHEN sum(cast(impsol as float))=0 THEN 0 else sum(cast(impsol as float)*cast(CASE WHEN (CODEPW in ( '0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265')) THEN COMFIA ELSE SPRNOR END as float)/100)/sum(cast(impsol as float)) end as SPREAD

    FROM USRFINDATA.STG_FACTUNICAD@BSIBPDW0@UFINRIE f
    left join ( SELECT   * FROM USRFINDATA.ODS_OFICINA@BSIBPDW0@UFINRIE  ) O
    ON F.CODOFI= O.COD_OFICINA and F.FINFO=O.PERIODO
    WHERE f.FINFO>='202208'
      AND COD_SUPRAREA  = '1685'
      AND (
      CODEPW IN('0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265','0164000') OR 
      (CODEPW >= '0160010' AND CODEPW <= '0160040') OR 
      (CODEPW >= '0161710' AND CODEPW <= '0161730') 
       ) AND 
      CODCPT_R IN ('201','216','228','291','294','295','296','271','272','273','274','275')
    group by
    FINFO,
      case 
      --when CODEPW IN('0159501' ,'0159502') then 'CARTERA' 
      --when CODEPW IN ('0159601' , '0159602') then 'LEASING' 
      --when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE >394 then 'PCOM_LARGO'
      --when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE <=394 then 'PCOM_CORTO'
      --when (CODEPW >= '0161710' AND CODEPW <= '0161730') then 'COMEX'
      --WHEN (CODEPW in ( '0162000','0161900','0163000')) THEN 'TKT'
      WHEN (CODEPW in ( '0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265')) THEN 'CARTA FIANZA'
      --WHEN (CODEPW in ( '0164000')) THEN 'RESTO EMPRESAS'
      END,
      CASE
      WHEN COD_SUPRAREA  = '1676' THEN 'CIB'
      WHEN COD_SUPRAREA  = '1685' THEN 'BE'
      WHEN COD_SUPRAREA  = '1664' THEN 'BANCA_COMERCIAL'
      else 'OTROS'
      end,
      case
      when CODSEG='10100' THEN 'CORPORATIVO GESTION GLOBAL'
      when CODSEG='10200' THEN 'CORPORATIVO GESTION LOCAL'
      when CODSEG='30100' THEN 'EMPRESA GRANDE'
      when CODSEG='30200' THEN 'EMPRESA MEDIANA'
      when CODSEG='30300' THEN 'EMPRESA PEQUE�A'
      ELSE 'OTROS'
      END,
      CODDIV,
      FECAPE,
      CASE WHEN CODEPW IN ('0160013') THEN 1 ELSE 0 END,
      CASE WHEN CODEPW IN ('0160012') THEN 1 ELSE 0 END,
      DES_TERRITORIO,
      CONCAT('A',NUMCNT),
    DES_OFICINA,
    CODCLI

) X
ORDER BY 
FINFO,
PRODUCTO_FACTURACION,
BANCA,
SEGMENTO,
DIVISA,
FECHA_ALTA,
FLAG_REACTIVA,
FLAG_FONDO_CRECER


---------------------------------------------------------------------


SELECT DISTINCT  * FROM USRFINDATA.STG_VPIDSCRI@BSIBPDW0@UFINRIE
WHERE FEC_CIERRE = '11/08/2022' AND FEC_VENCTO > '31/07/22' AND FEC_VENCTO < '15/08/22'  AND COD_CONTRATO='001103779800220902'


