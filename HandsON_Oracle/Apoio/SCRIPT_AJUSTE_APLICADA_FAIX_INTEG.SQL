	DECLARE
	   VID_TARIFA_APLICADA             TCFG_TARIFA_APLICADA.ID_TARIFA_APLICADA%TYPE;
	   VID_COMPORT_SENT_VIAGEM_FAIXA   TCFG_COMPORT_SENT_VIAGEM_FAIXA.ID_COMPORT_SENT_VIAGEM_FAIXA%TYPE;
    BEGIN	
       --
       FOR I IN (SELECT T.ID_COMPORTAM_SENTIDO_VIAGEM  FROM TCFG_COMPORTAM_SENTIDO_VIAGEM T , TCFG_TARIFA_APLICADA A
                  WHERE 
				    --T.ID_COMPORTAM_SENTIDO_VIAGEM IN (517,516)
                    --AND 
					T.ID_COMPORTAM_SENTIDO_VIAGEM = A.ID_COMPORTAM_SENTIDO_VIAGEM (+)
                    AND A.ID_COMPORT_SENT_VIAGEM_FAIXA IS NULL) 
       LOOP
           --
           SELECT MAX(ID_COMPORT_SENT_VIAGEM_FAIXA) + 1 INTO   VID_COMPORT_SENT_VIAGEM_FAIXA FROM  TCFG_COMPORT_SENT_VIAGEM_FAIXA;
		   --
		   SELECT MAX(ID_TARIFA_APLICADA) + 1 INTO   VID_TARIFA_APLICADA FROM  TCFG_TARIFA_APLICADA;
           --

           --
		   INSERT INTO TCFG_COMPORT_SENT_VIAGEM_FAIXA
                  (
				  ID_COMPORTAM_SENTIDO_VIAGEM,
                  ID_COMPORT_SENT_VIAGEM_FAIXA,
                  DD_SEMANA,
                  DT_ESPECIFICA,
                  HH_INICIAL_FAIXA,
                  MM_INICIAL_FAIXA,
                  HH_FINAL_FAIXA,
                  MM_FINAL_FAIXA,
                  DT_CRIACAO,
                  NM_USUARIO_CRIACAO,
                  NM_USUARIO_ALTERACAO,
                  ID_MOTIVO_SITUACAO
                  ) VALUES (
                  I.ID_COMPORTAM_SENTIDO_VIAGEM,
                  VID_COMPORT_SENT_VIAGEM_FAIXA,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  SYSDATE,
                  'SISTEMA',
                  'SISTEMA',
                  2773
                );
                --		          
		   INSERT INTO TCFG_TARIFA_APLICADA 
		         (ID_TARIFA_APLICADA	,
	              ID_COMPORTAMENTO_POLIT_TAR_B	,
	              ID_COMPORTAMENTO_FAIXA	,
	              ID_COMPORTAM_SENTIDO_VIAGEM	,
	              ID_COMPORT_SENT_VIAGEM_FAIXA	,
	              DT_CRIACAO	,
	              NM_USUARIO_CRIACAO	,
	              DT_ALTERACAO	,
	              NM_USUARIO_ALTERACAO	,
	              ID_MOTIVO_SITUACAO	,
	              FG_EXCLUIDO)	   
		   VALUES
		          ( VID_TARIFA_APLICADA,
				    NULL,
					NULL,
					I.ID_COMPORTAM_SENTIDO_VIAGEM,
					VID_COMPORT_SENT_VIAGEM_FAIXA,
					SYSDATE,
					'SISTEMA',
					NULL,
					NULL,
					2773,
					'N'
				  );				
        END LOOP;
    END;