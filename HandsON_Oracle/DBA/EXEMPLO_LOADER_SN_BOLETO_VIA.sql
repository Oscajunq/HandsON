OPTIONS (SILENT=ALL, DIRECT=TRUE)
UNRECOVERABLE
LOAD DATA
        APPEND INTO TABLE SN_BOLETO_VIA
        FIELDS TERMINATED BY '¨' 
        OPTIONALLY ENCLOSED BY '"'  
        TRAILING NULLCOLS        ( 
                ID_BOLETO DECIMAL EXTERNAL, 
                NUM_CONTRATO DECIMAL EXTERNAL, 
                CID_CONTRATO char, 
                ID_BOLETO_ORIGEM DECIMAL EXTERNAL, 
                ID_SITUACAO_BOLETO DECIMAL EXTERNAL, 
                ID_LOCAL_PGTO DECIMAL EXTERNAL, 
                ID_TIPO_PGTO DECIMAL EXTERNAL, 
                ID_TIPO_BOLETO DECIMAL EXTERNAL, 
                ID_CRITERIO DECIMAL EXTERNAL, 
                ID_TIPO_COBRANCA DECIMAL EXTERNAL, 
                ID_CC DECIMAL EXTERNAL, 
                ID_CC_CONVENIO_BOLETO DECIMAL EXTERNAL, 
                ID_CC_CONVENIO_DCC DECIMAL EXTERNAL, 
                ID_CARTAO_CREDITO DECIMAL EXTERNAL, 
                ID_CARTAO_CREDITO_PARCEIRO DECIMAL EXTERNAL, 
                DT_DOCUMENTO date "DD/MM/YYYY", 
                DT_VENCIMENTO date "DD/MM/YYYY", 
                DT_PAGAMENTO date "DD/MM/YYYY", 
                DT_CANCELAMENTO date "DD/MM/YYYY", 
                DT_BAIXA date "DD/MM/YYYY", 
                DT_PRIMEIRA_EMISSAO date "DD/MM/YYYY", 
                CC_NOSSO_NUMERO char, 
                CC_NUM_DOCUMENTO char, 
                CC_NUM_CONTROLE char, 
                CC_CODIGO_BARRA char, 
                CC_LINHA_DIGITAVEL char, 
                CC_USR_CANCELAMENTO char, 
                VL_DOCUMENTO DECIMAL EXTERNAL, 
                VL_PAGAMENTO DECIMAL EXTERNAL, 
                NR_TRANSACAO_CARTAO DECIMAL EXTERNAL, 
                FC_BOLETO_CONSOLIDADO char, 
                FC_PGTO_ESPECIAL char, 
                ST_CNAB char, 
                ST_CONTESTADO char, 
                ST_IMPRESSO char,
                ID_BANCO DECIMAL EXTERNAL,
                DPA_ID       "PROD_JD.SQSN_BOLETO_01.NEXTVAL",                         
                TP_REGISTRO  CHAR,                         
                SISTEMA      CHAR,                         
                REGIAO       CHAR) 

