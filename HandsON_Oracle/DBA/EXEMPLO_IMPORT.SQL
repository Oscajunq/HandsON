INSERT      /*+NESTED_TABLE_SET_REFS+*/INTO "DIR_VINCULADOS"
            ("EMISOR", "SUCURSAL_EMISOR", "PRODUCTO", "NUMERO_CUENTA",
             "TIPO_DE_DOCUMENTO", "DOCUMENTO", "TIPO_DIRECCION",
             "FECHA_DESDE", "FECHA_HASTA", "CALLE", "NUMERO_PUERTA",
             "BARRIO", "COMPLEMENTO", "CIUDAD", "COD_ESTADO", "PAIS",
             "CODIGO_POSTAL", "TELEFONO", "CELULAR", "FAX", "E_MAIL",
             "INTERNO", "TIEMPO_RESIDENCIA"
            )
     VALUES (:1, :2, :3, :4,
             :5, :6, :7,
             :8, :9, :10, :11,
             :12, :13, :14, :15, :16,
             :17, :18, :19, :20, :21,
             :22, :23
            )