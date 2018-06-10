SELECT 
     -- HEADER
     '10400000         2604984170001580000000000000000000002873806386700000000SAO PAULO TRANSPORTE S A      C ECON FEDERAL                          20610201601181200197404000000                    RETORNO-PRODUCAO                  000            ' ||
     CHR(10) ||
     '10400011T0100030 20604984170001580000000000000000000002873806386700000000SAO PAULO TRANSPORTE S A                                                                                      00001974061020160000000000                          00   '
FROM DUAL     
--
UNION ALL
--
SELECT     
     -- LAYOUT SEGMENTO T
     '104'   || -- BANCO
     '0001'  || -- LOTE DE SERVICO
     '3'     || -- TIPO DE REGISTRO 
     LPAD(ROWNUM,5,'0') || -- SEQUENCIAL DA LINHA 
     'T'                || -- CODIGO DO SEGMENTO DO REG DETALHE
     ' '                || -- BRANCOS
     '06'               || -- CODIGO DE MOVIMENTO DO RETORNO
     '00000'            || -- INDETF AGENCIA CAIXA - CODIGO
     '0'                || -- INDETF AGENCIA CAIXA - DV
     LPAD(TO_CHAR(TC.NR_CEDENTE),6,0) || -- INDETF AGENCIA CAIXA - COD.CEDENTE
     '000'              || -- USO EXCLUSIVO CAIXA
     '000'              || -- NUMERO DO BANCO DE SACADOS
     '0000'             || -- USO EXCLUSIVO CAIXA
     --'24'               || -- MODALIDADE NOSSO NUMERO 
     --SUBSTR(TO_CHAR(B.NR_NOSSO),4,15)  || -- IDENTIFICACAO DO TITULO NO BANCO
     B.NR_NOSSO || -- IDENTIFICACAO DO TITULO NO BANCO 
     '0'                      || -- USO EXCLUSIVO CAIXA
     '1'                      || -- CODIGO DA CARTEIRA 
     LPAD(B.ID_BOLETO,11,'0') || -- NUMERO DO DOCUMENTO DE COBRANCA
     '    '                   || -- USO EXCLUISO CAIXA 
     TO_CHAR(B.DT_VENCIMENTO,'DDMMYYYY') || -- DATA DO VENCIMENTO 
     LPAD(TO_NUMBER(TO_CHAR(VL_TITULO,'9999999999999V99')),15,'0') || -- VALOR DO TITULO
     '237'                                                         || -- BANCO COBRADOR/RECEBEDOR
     '02875'                                                       || -- AGENCIA COBRADORA/RECEBEDORA
     '0'                                                           || -- DIGITO VERIFICADOR DA AGENCIA COBRADORA
     LPAD(B.ID_BOLETO,25,'0')                                      || -- IDENTIFICACAO DO TITULO NA EMPRESA
     '09'                                                          || -- CODIGO DA MOEDA
     '1'                                                           || -- SACADO - TIPO DE INSCRICAO = 1-CPF
     LPAD(D.NR_DOCUMENTO,15,'0')                                   || -- SACADO - NUMERO DE INSCRICAO
     RPAD(SUBSTR(UPPER(U.NM_USUARIO),1,40),40,' ')                        || -- SACADO - NOME 
     '          '                                                  || -- USO EXCLUSIVO FEBRABRAN - CNAB
     '000000000000125'                                             || -- VALOR DA TARIFA/CUSTAS
     '040102    '                                                  || -- MOTIVO DA OCORRENCIA 
     '                 '                                           ||   -- CNAB
     CHR(10) ||
     -- LAYOUT SEGMENTO U
     '104'   || -- BANCO
     '0001'  || -- LOTE DE SERVICO
     '3'     || -- TIPO DE REGISTRO 
     LPAD(ROWNUM,5,'0') || -- SEQUENCIAL DA LINHA 
     'U'                || -- CODIGO DO SEGMENTO DO REG DETALHE
     ' '                || -- BRANCOS
     '0600000000000000000000000000000000000000000000000000000000000' || -- CODIGO DE MOVIMENTO DO RETORNO,ACRESCIMO,VLR DESCONTO,VLR ABAT, VLR IOF
     LPAD(TO_NUMBER(TO_CHAR(VL_TITULO,'9999999999999V99')),15,'0')   || -- VALOR DO PAGO
     LPAD(TO_NUMBER(TO_CHAR(VL_TITULO,'9999999999999V99')),15,'0')   || -- VALOR DO LIQUIDO     
     '0000000000000000000000000000000'                              || -- VALOR DA OUTRAS DESPESA E CREDITOS
     TO_CHAR(B.DT_VENCIMENTO,'DDMMYYYY') || -- DATA DA OCORRENCIA
     TO_CHAR(B.DT_VENCIMENTO,'DDMMYYYY') || -- DATA DO CREDITO          
     '00000000000000000000000000000000000000000000000000000000000000000000000000000000       '  -- DEMAIS CAMPOS 
--    
FROM TPRO_BOLETO B INNER JOIN TCAD_USUARIO U           ON    B.ID_USUARIO_SACADO = U.ID_USUARIO
                   INNER JOIN TCAD_DOCUMENTO_USUARIO D ON    D.ID_USUARIO= U.ID_USUARIO
                                                         AND D.ID_TIPO_DOCUMENTO = 2
                   INNER JOIN TCAD_PEDIDO_CREDITO PC   ON    PC.ID_BOLETO = B.ID_BOLETO
                                                         AND PC.NR_NOSSO = B.NR_NOSSO
                   INNER JOIN TCAD_CEDENTE TC          ON TC.ID_CEDENTE= B.ID_CEDENTE
WHERE D.NR_DOCUMENTO = '52586027027'
--
UNION ALL
SELECT
     -- LAYOUT TRAILLER LOTE
     --
     '10400015         ' ||
     LPAD((((SELECT COUNT(*) FROM TPRO_BOLETO)*2)+2),6,'0') ||
     '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000                                                                                                                             '  ||
     CHR(10) ||
     -- LAYOUT TRAILLER FINAL     
     '10499999         000001' ||
     LPAD((((SELECT COUNT(*) FROM TPRO_BOLETO)*2)+4),6,'0') || 
     '                                                                                                                                                                                                                   '
FROM DUAL; 
