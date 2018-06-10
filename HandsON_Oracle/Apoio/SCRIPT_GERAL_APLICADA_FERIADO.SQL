SELECT * FROM TCFG_COMPORT_SENT_VIAGEM_FAIXA WHERE ID_COMPORTAM_SENTIDO_VIAGEM = 517;

SELECT * FROM TCFG_TARIFA_APLICADA F WHERE F.ID_COMPORTAM_SENTIDO_VIAGEM = 517;

SELECT 'EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( ' || TO_CHAR(A.ID_COMPORTAM_SENTIDO_VIAGEM) || ');'
 FROM TCFG_COMPORTAM_SENTIDO_VIAGEM A 
WHERE (A.HH_INICIO_FERIADO_MUNICIPAL > 0
   OR A.HH_INICIO_FERIADO_ESTADUAL  > 0
   OR A.HH_INICIO_FERIADO_NACIONAL  > 0)
  AND A.ID_COMPORTAM_SENTIDO_VIAGEM = 517;   
 
 
SELECT 'EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => ' || TO_CHAR(A.ID_COMPORTAM_SENTIDO_VIAGEM) || ' ,' ||
       'p_dd_semana                    => 8 ,' ||
       'p_hh_inicial_faixa             => ' || A.HH_INICIO_FERIADO_MUNICIPAL || ' ,' ||
       'p_mm_inicial_faixa             => ' || A.MM_INICIO_FERIADO_MUNICIPAL || ' ,' ||
       'p_hh_final_faixa               => ' || A.HH_FINAL_FERIADO_MUNICIPAL  || ' ,' ||
       'p_mm_final_faixa               => ' || A.MM_FINAL_FERIADO_MUNICIPAL  || ' ,' ||
       'p_nm_usuario_criacao           => ' || '''' || 'SISTEMA' || '''' || ');'
 FROM TCFG_COMPORTAM_SENTIDO_VIAGEM A 
WHERE A.HH_INICIO_FERIADO_MUNICIPAL > 0
UNION ALL
SELECT 'EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => ' || TO_CHAR(A.ID_COMPORTAM_SENTIDO_VIAGEM) || ' ,' ||
       'p_dd_semana                    => 9 ,' ||
       'p_hh_inicial_faixa             => ' || A.HH_INICIO_FERIADO_ESTADUAL || ' ,' ||
       'p_mm_inicial_faixa             => ' || A.MM_INICIO_FERIADO_ESTADUAL || ' ,' ||
       'p_hh_final_faixa               => ' || A.HH_FINAL_FERIADO_ESTADUAL  || ' ,' ||
       'p_mm_final_faixa               => ' || A.MM_FINAL_FERIADO_ESTADUAL  || ' ,' ||
       'p_nm_usuario_criacao           => ' || '''' || 'SISTEMA' || '''' || ');'
 FROM TCFG_COMPORTAM_SENTIDO_VIAGEM A 
WHERE A.HH_INICIO_FERIADO_ESTADUAL > 0
UNION ALL
SELECT 'EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => ' || TO_CHAR(A.ID_COMPORTAM_SENTIDO_VIAGEM) || ' ,' ||
       'p_dd_semana                    => 10 ,' ||
       'p_hh_inicial_faixa             => ' || A.HH_INICIO_FERIADO_NACIONAL || ' ,' ||
       'p_mm_inicial_faixa             => ' || A.MM_INICIO_FERIADO_NACIONAL || ' ,' ||
       'p_hh_final_faixa               => ' || A.HH_FINAL_FERIADO_NACIONAL  || ' ,' ||
       'p_mm_final_faixa               => ' || A.MM_FINAL_FERIADO_NACIONAL  || ' ,' ||
       'p_nm_usuario_criacao           => ' || '''' || 'SISTEMA' || '''' || ');'
 FROM TCFG_COMPORTAM_SENTIDO_VIAGEM A 
WHERE A.HH_INICIO_FERIADO_NACIONAL > 0

   
           
		   
		   
SELECT * FROM TCFG_COMPORT_SENT_VIAGEM_FAIXA WHERE ID_COMPORTAM_SENTIDO_VIAGEM = 517;

SELECT * FROM TCFG_TARIFA_APLICADA F WHERE F.ID_COMPORTAM_SENTIDO_VIAGEM = 517;

EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 517);

EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 517 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');

SELECT * FROM TCFG_COMPORT_SENT_VIAGEM_FAIXA WHERE ID_COMPORTAM_SENTIDO_VIAGEM = 517;

SELECT * FROM TCFG_TARIFA_APLICADA F WHERE F.ID_COMPORTAM_SENTIDO_VIAGEM = 517;





EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 296);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 325);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 317);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 371);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 344);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 386);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 402);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 406);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 490);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 346);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 397);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 513);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 519);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 517);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 518);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 466);
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.remove_faixa_feriado ( 396);



EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 325 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 12 ,p_mm_inicial_faixa             => 12 ,p_hh_final_faixa               => 13 ,p_mm_final_faixa               => 13 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 317 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 1 ,p_mm_inicial_faixa             => 23 ,p_hh_final_faixa               => 23 ,p_mm_final_faixa               => 49 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 371 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 5 ,p_mm_inicial_faixa             => 12 ,p_hh_final_faixa               => 17 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 344 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 12 ,p_mm_inicial_faixa             => 12 ,p_hh_final_faixa               => 13 ,p_mm_final_faixa               => 13 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 386 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 1 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 0 ,p_mm_final_faixa               => 0 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 402 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 50 ,p_hh_final_faixa               => 23 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 406 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 12 ,p_mm_inicial_faixa             => 12 ,p_hh_final_faixa               => 12 ,p_mm_final_faixa               => 12 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 490 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 513 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 519 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 517 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 518 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 466 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 396 ,p_dd_semana                    => 8 ,p_hh_inicial_faixa             => 12 ,p_mm_inicial_faixa             => 12 ,p_hh_final_faixa               => 23 ,p_mm_final_faixa               => 0 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 296 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 1 ,p_mm_inicial_faixa             => 22 ,p_hh_final_faixa               => 2 ,p_mm_final_faixa               => 0 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 317 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 9 ,p_mm_inicial_faixa             => 9 ,p_hh_final_faixa               => 21 ,p_mm_final_faixa               => 9 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 371 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 5 ,p_mm_inicial_faixa             => 6 ,p_hh_final_faixa               => 17 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 344 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 13 ,p_mm_inicial_faixa             => 13 ,p_hh_final_faixa               => 13 ,p_mm_final_faixa               => 13 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 386 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 10 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 0 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 490 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 346 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 12 ,p_mm_inicial_faixa             => 12 ,p_hh_final_faixa               => 13 ,p_mm_final_faixa               => 13 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 513 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 519 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 517 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 518 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 466 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 396 ,p_dd_semana                    => 9 ,p_hh_inicial_faixa             => 12 ,p_mm_inicial_faixa             => 12 ,p_hh_final_faixa               => 23 ,p_mm_final_faixa               => 0 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 317 ,p_dd_semana                    => 10 ,p_hh_inicial_faixa             => 7 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 19 ,p_mm_final_faixa               => 8 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 371 ,p_dd_semana                    => 10 ,p_hh_inicial_faixa             => 8 ,p_mm_inicial_faixa             => 59 ,p_hh_final_faixa               => 8 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 344 ,p_dd_semana                    => 10 ,p_hh_inicial_faixa             => 13 ,p_mm_inicial_faixa             => 31 ,p_hh_final_faixa               => 13 ,p_mm_final_faixa               => 31 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 386 ,p_dd_semana                    => 10 ,p_hh_inicial_faixa             => 12 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 10 ,p_mm_final_faixa               => 0 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 490 ,p_dd_semana                    => 10 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 397 ,p_dd_semana                    => 10 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 23 ,p_mm_final_faixa               => 58 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 513 ,p_dd_semana                    => 10 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 519 ,p_dd_semana                    => 10 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 517 ,p_dd_semana                    => 10 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 518 ,p_dd_semana                    => 10 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 466 ,p_dd_semana                    => 10 ,p_hh_inicial_faixa             => 23 ,p_mm_inicial_faixa             => 0 ,p_hh_final_faixa               => 22 ,p_mm_final_faixa               => 59 ,p_nm_usuario_criacao           => 'SISTEMA');
EXECUTE KSBE_POLITICA_INTEGRACAO_TARIF.manter_faixa_feriado ( p_id_comportam_sentido_viagem  => 396 ,p_dd_semana                    => 10 ,p_hh_inicial_faixa             => 12 ,p_mm_inicial_faixa             => 8 ,p_hh_final_faixa               => 23 ,p_mm_final_faixa               => 0 ,p_nm_usuario_criacao           => 'SISTEMA');
