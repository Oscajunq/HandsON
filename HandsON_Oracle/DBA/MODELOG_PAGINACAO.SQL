SELECT ROUND(MAX(QTDELIN) / 50,0) FROM               
select 5, * from (
select rownum qtdelin , proposta,nome from (
select proposta,nome from proposta where nome like '%ANA%' order by 2))
where qtdelin >= (50 * 5 - 49) AND qtdelin <= (50 * 5)

where qtdelin >= (total_linhas_paginas_desejada * numero_pagina_selecionada - (numero_pagina_selecionada - 1)) 
  AND qtdelin <= (total_linhas_paginas_desejada * numero_pagina_selecionada)