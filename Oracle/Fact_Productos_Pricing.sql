SELECT *
FROM (
		SELECT 
        FINFO,
        case 
        when CODEPW IN('0159501' ,'0159502') then 'CARTERA' 
        when CODEPW IN ('0159601' , '0159602') then 'LEASING' 
        when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE >394 then 'PCOM_LARGO'
        when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE <=394 then 'PCOM_CORTO'
        when (CODEPW >= '0161710' AND CODEPW <= '0161730') then 'COMEX'
        WHEN (CODEPW in ( '0162000','0161900','0163000')) THEN 'TKT'
        WHEN (CODEPW in ( '0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265')) THEN 'CARTA FIANZA'
        WHEN (CODEPW in ( '0164000')) THEN 'RESTO EMPRESAS'
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
    CODEPW IN('0159501' ,'0159502','0159601' , '0159602','0162000','0161900','0163000','0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265','0164000') OR 
    (CODEPW >= '0160010' AND CODEPW <= '0160040') OR 
    (CODEPW >= '0161710' AND CODEPW <= '0161730') 
     ) AND 
    CODCPT_R IN ('201','216','228','291','294','295','296','271','272','273','274','275')
    group by
      FINFO,
      case 
      when CODEPW IN('0159501' ,'0159502') then 'CARTERA' 
      when CODEPW IN ('0159601' , '0159602') then 'LEASING' 
      when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE >394 then 'PCOM_LARGO'
      when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE <=394 then 'PCOM_CORTO'
      when (CODEPW >= '0161710' AND CODEPW <= '0161730') then 'COMEX'
      WHEN (CODEPW in ( '0162000','0161900','0163000')) THEN 'TKT'
      WHEN (CODEPW in ( '0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265')) THEN 'CARTA FIANZA'
      WHEN (CODEPW in ( '0164000')) THEN 'RESTO EMPRESAS'
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
      when CODEPW IN('0159501' ,'0159502') then 'CARTERA' 
      when CODEPW IN ('0159601' , '0159602') then 'LEASING' 
      when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE >394 then 'PCOM_LARGO'
      when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE <=394 then 'PCOM_CORTO'
      when (CODEPW >= '0161710' AND CODEPW <= '0161730') then 'COMEX'
      WHEN (CODEPW in ( '0162000','0161900','0163000')) THEN 'TKT'
      WHEN (CODEPW in ( '0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265')) THEN 'CARTA FIANZA'
      WHEN (CODEPW in ( '0164000')) THEN 'RESTO EMPRESAS'
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
      CODEPW IN('0159501' ,'0159502','0159601' , '0159602','0162000','0161900','0163000','0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265','0164000') OR 
      (CODEPW >= '0160010' AND CODEPW <= '0160040') OR 
      (CODEPW >= '0161710' AND CODEPW <= '0161730') 
       ) AND 
      CODCPT_R IN ('201','216','228','291','294','295','296','271','272','273','274','275')
    group by
    FINFO,
      case 
      when CODEPW IN('0159501' ,'0159502') then 'CARTERA' 
      when CODEPW IN ('0159601' , '0159602') then 'LEASING' 
      when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE >394 then 'PCOM_LARGO'
      when (CODEPW >= '0160010' AND CODEPW <= '0160040') and PLAOPE <=394 then 'PCOM_CORTO'
      when (CODEPW >= '0161710' AND CODEPW <= '0161730') then 'COMEX'
      WHEN (CODEPW in ( '0162000','0161900','0163000')) THEN 'TKT'
      WHEN (CODEPW in ( '0292220','0292225','0292230','0292235','0292240','0292250','0292255','0292260','0292265')) THEN 'CARTA FIANZA'
      WHEN (CODEPW in ( '0164000')) THEN 'RESTO EMPRESAS'
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
