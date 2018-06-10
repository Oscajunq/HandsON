
LISTAR
	SBE.tcfg_tipo_documento (id_tipo_documento)
	SBE.tcad_upload_documento (id_upload_documento)
	SBE.tcad_arquivo_documento_usuario (id_usuario where id_situacao_registro "em aprovação")
	SBE.tcad_usuario (id_usuario)
	sbe.tcad_solicitacao_cartao (id_usuario where id_situacao_registro "em aprovação")
	sbe.tcad_produto_usuario (id_solicitacao_cartao)
	SBE.tcad_produto (id_produto)

VALIDAR
	SBE.tcad_arquivo_documento_usuario.id_motivo_situacao
	
	
	
atualizar_sit_documento


a.qa_tamanho_mbyte,       a.tx_extensoes_validas,
               a.qa_altura_pixel,        a.qa_largura_pixel,
               a.id_parametro_documento
			   

     p_id_tipo_documento         TCFG_PARAMETRO_DOCUMENTO.TX_EXTENSOES_VALIDAS   TYPE%    
	,p_tx_extensoes_validas      TCFG_PARAMETRO_DOCUMENTO.TX_EXTENSOES_VALIDAS   TYPE% 
    ,p_qa_altura_pixel           TCFG_PARAMETRO_DOCUMENTO.QA_ALTURA_PIXEL        TYPE%        
    ,p_qa_tamanho_mbyte          TCFG_PARAMETRO_DOCUMENTO.QA_TAMANHO_MBYTE       TYPE%       
    ,p_qa_largura_pixel          TCFG_PARAMETRO_DOCUMENTO.QA_LARGURA_PIXEL       TYPE%

	
	
 p_id_produto              TCFG_DOCUMENTO_OBRIGATORIO.ID_PRODUTO          TYPE% 
,p_id_tipo_documento       TCFG_DOCUMENTO_OBRIGATORIO.ID_TIPO_DOCUMENTO   TYPE% 
,p_fg_obrigatorio          TCFG_DOCUMENTO_OBRIGATORIO.FG_OBRIGATORIO      TYPE% 
,p_tp_periodo_validade     TCFG_DOCUMENTO_OBRIGATORIO.TP_PERIODO_VALIDADE TYPE% 
,p_nr_periodo_validade     TCFG_DOCUMENTO_OBRIGATORIO.NR_PERIODO_VALIDADE TYPE% 

p_dt_criacao              , 
p_nm_usuario_criacao      , 
p_dt_alteracao            , 
p_nm_usuario_alteracao    , 
p_id_motivo_situacao      , 
p_fg_excluido

alterar_parametro_documento