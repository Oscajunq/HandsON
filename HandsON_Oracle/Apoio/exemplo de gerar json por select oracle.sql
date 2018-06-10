SELECT JSON_ARRAYAGG(
        json_object
        (
             'ID_PEDIDO_CREDITO'                IS ID_PEDIDO_CREDITO                                                               
            ,'ID_MOEDA'                         IS ID_MOEDA               
            ,'VL_TOTAL_CREDITO'                 IS VL_TOTAL_CREDITO                       
            ,'VL_TOTAL_DESCONTO'                IS VL_TOTAL_DESCONTO                       
            ,'VL_SERVICO_ADMINISTRATIVO'        IS VL_SERVICO_ADMINISTRATIVO                               
            ,'ID_USUARIO'                       IS ID_USUARIO               
            ,'ID_PERFIL_UTILIZACAO'             IS ID_PERFIL_UTILIZACAO                           
            ,'ID_SITUACAO_PEDIDO_CREDITO'       IS ID_SITUACAO_PEDIDO_CREDITO                   
            ,'DT_SITUACAO_PEDIDO_CREDITO'       IS DT_SITUACAO_PEDIDO_CREDITO                   
            ,'ID_SITUACAO_PAGTO_CREDITO'        IS ID_SITUACAO_PAGTO_CREDITO                   
            ,'DT_SITUACAO_PAGTO_CREDITO'        IS DT_SITUACAO_PAGTO_CREDITO                   
            ,'ID_MEIO_PAGAMENTO'                IS ID_MEIO_PAGAMENTO              
            ,'ID_BOLETO'                        IS ID_BOLETO      
            ,'NR_NOSSO'                         IS NR_NOSSO      
            ,'DT_VENCIMENTO'                    IS DT_VENCIMENTO          
            ,'VL_PAGO'                          IS VL_PAGO  
            ,'NR_RECIBO'                        IS NR_RECIBO      
            ,'CD_AUTENTICACAO_RECIBO'           IS CD_AUTENTICACAO_RECIBO               
            ,'DT_RECIBO'                        IS DT_RECIBO      
            ,'DT_CRIACAO'                       IS DT_CRIACAO      
            ,'NM_USUARIO_CRIACAO'               IS NM_USUARIO_CRIACAO              
            ,'DT_ALTERACAO'                     IS DT_ALTERACAO          
            ,'NM_USUARIO_ALTERACAO'             IS NM_USUARIO_ALTERACAO               
            ,'ID_MOTIVO_SITUACAO'               IS ID_MOTIVO_SITUACAO              
            ,'FG_EXCLUIDO'                      IS FG_EXCLUIDO      
            ,'ID_ORIGEM_SOLIC_GERAR_CREDIT'     IS ID_ORIGEM_SOLIC_GERAR_CREDIT                       
--            ,'VL_TAXA_RECARGA'                  IS VL_TAXA_RECARGA          
--            ,'VL_IMPOSTO'                       IS VL_IMPOSTO      
--            ,'ID_ADQUIRENTE'                    IS ID_ADQUIRENTE          
--            ,'ID_LOTE_PAGAMENTO_PEDIDO_CREDI'   IS ID_LOTE_PAGAMENTO_PEDIDO_CREDI                       
        ) 
        ORDER BY ID_PEDIDO_CREDITO RETURNING CLOB) retorno
  from TCAD_PEDIDO_CREDITO;
