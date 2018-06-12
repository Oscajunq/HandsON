ALTER TABLE [tbCepBairro] DROP CONSTRAINT [FK__tbCepBair__Loc_N__1273C1CD]
GO
ALTER TABLE [tbCepLogradouro] DROP CONSTRAINT [FK__tbCepLogr__Bairr__15502E78]
GO
ALTER TABLE [tbCepLogradouro] DROP CONSTRAINT [FK__tbCepLogr__Loc_N__164452B1]
GO
ALTER TABLE [tbLogPessoas] DROP CONSTRAINT [FK__tbLogPess__IdCod__36B12243]
GO
ALTER TABLE [tbPessoas] DROP CONSTRAINT [FK__tbPessoas__IdCar__33D4B598]
GO
ALTER TABLE [tbPessoasContato] DROP CONSTRAINT [FK__tbPessoas__IdCod__286302EC]
GO
ALTER TABLE [tbPessoasContato] DROP CONSTRAINT [FK__tbPessoas__idTip__239E4DCF]
GO
ALTER TABLE [tbPessoasDoctos] DROP CONSTRAINT [FK__tbPessoas__IdTip__2D27B809]
GO
ALTER TABLE [tbPessoasRedesSociais] DROP CONSTRAINT [FK__tbPessoas__IdCod__1DE57479]
GO
ALTER TABLE [tbPessoasRedesSociais] DROP CONSTRAINT [FK__tbPessoas__idTip__20C1E124]
GO
ALTER TABLE [tbPessoasDoctos] DROP CONSTRAINT [fk_tbPessoasDoctos_tbPessoas_1]
GO
ALTER TABLE [tbSalarios] DROP CONSTRAINT [fk_tbSalarios_tbCargos_1]
GO
ALTER TABLE [tbSalarios] DROP CONSTRAINT [fk_tbSalarios_tbNacionalidade_1]
GO
ALTER TABLE [tbPessoas] DROP CONSTRAINT [fk_tbPessoas_tbNacionalidade_1]
GO
ALTER TABLE [tbPessoas] DROP CONSTRAINT [fk_tbPessoas_tbEstadocivil_1]
GO
ALTER TABLE [tbAcesso] DROP CONSTRAINT [fk_tbAcesso_tbPessoas_1]
GO
ALTER TABLE [tbPessoas] DROP CONSTRAINT [fk_tbPessoas_tbComoSoube_1]
GO
ALTER TABLE [tbPessoas] DROP CONSTRAINT [fk_tbPessoas_tbEscolaridade_1]
GO

DROP INDEX [Ind_CepLogradouro] ON [tbCepLogradouro]
GO

ALTER TABLE [tbAcesso]DROP CONSTRAINT [PK__tbAcesso__571DBAE778F1F410]
GO
ALTER TABLE [tbCargos]DROP CONSTRAINT [PK__tbCargos__3D0E29B8F3587E22]
GO
ALTER TABLE [tbCepBairro]DROP CONSTRAINT [PK__tbCepBai__29D6F05351F7B62F]
GO
ALTER TABLE [tbCepCidade]DROP CONSTRAINT [PK__tbCepCid__5664C49C5D210D36]
GO
ALTER TABLE [tbCepLogradouro]DROP CONSTRAINT [PK__tbCepLog__54F54AA6A7824C98]
GO
ALTER TABLE [tbLogPessoas]DROP CONSTRAINT [PK__tbLogPes__760A204E2A44834C]
GO
ALTER TABLE [tbParametros]DROP CONSTRAINT [PK__tbParame__37B016F4200BFB8A]
GO
ALTER TABLE [tbPessoas]DROP CONSTRAINT [PK__tbPessoa__D27DD5CD4777E064]
GO
ALTER TABLE [tbPessoasContato]DROP CONSTRAINT [PK__tbPessoa__760A204E38FA9836]
GO
ALTER TABLE [tbPessoasDoctos]DROP CONSTRAINT [PK__tbPessoa__67760B61A6832061]
GO
ALTER TABLE [tbPessoasRedesSociais]DROP CONSTRAINT [PK__tbPessoa__760A204E9CEA9020]
GO
ALTER TABLE [tbSalarios]DROP CONSTRAINT [PK__tbSalari__22F6F90655CF5506]
GO
ALTER TABLE [tbTipoDoctos]DROP CONSTRAINT [PK__tbTipoDo__4F86DDDEC19CE6E9]
GO
ALTER TABLE [tbTipoFone]DROP CONSTRAINT [PK__tbTipoFo__1483902FCBAC7065]
GO
ALTER TABLE [tbTipoRedeSocial]DROP CONSTRAINT [PK__tbTipoRe__1098E07613EC1BA2]
GO
ALTER TABLE [tbNacionalidade]DROP CONSTRAINT [PK__tbTipoRe__1098E07613EC1BA2]
GO
ALTER TABLE [tbEstadocivil]DROP CONSTRAINT [PK__tbTipoRe__1098E07613EC1BA2]
GO
ALTER TABLE [tbComoSoube]DROP CONSTRAINT [PK__tbTipoRe__1098E07613EC1BA2]
GO
ALTER TABLE [tbEscolaridade]DROP CONSTRAINT [PK__tbTipoRe__1098E07613EC1BA2]
GO

DROP TABLE [tbAcesso]
GO
DROP TABLE [tbCargos]
GO
DROP TABLE [tbCepBairro]
GO
DROP TABLE [tbCepCidade]
GO
DROP TABLE [tbCepLogradouro]
GO
DROP TABLE [tbLogPessoas]
GO
DROP TABLE [tbParametros]
GO
DROP TABLE [tbPessoas]
GO
DROP TABLE [tbPessoasContato]
GO
DROP TABLE [tbPessoasDoctos]
GO
DROP TABLE [tbPessoasRedesSociais]
GO
DROP TABLE [tbSalarios]
GO
DROP TABLE [tbTipoDoctos]
GO
DROP TABLE [tbTipoFone]
GO
DROP TABLE [tbTipoRedeSocial]
GO
DROP TABLE [tbNacionalidade]
GO
DROP TABLE [tbEstadocivil]
GO
DROP TABLE [tbComoSoube]
GO
DROP TABLE [tbEscolaridade]
GO

CREATE TABLE [tbAcesso] (
[Apelido] varchar(20) COLLATE Latin1_General_CI_AS NOT NULL,
[IdCodigoCli] bigint NOT NULL,
[Password] varbinary(100) NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
CONSTRAINT [PK__tbAcesso__571DBAE778F1F410] PRIMARY KEY ([Apelido]) 
)
GO

DBCC CHECKIDENT (N'[tbAcesso]', RESEED, 1)
GO
ALTER TABLE [tbAcesso] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbCargos] (
[idCargo] int NOT NULL,
[NomeCargo] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[Descricao] nvarchar(MAX) COLLATE Latin1_General_CI_AS NULL,
[Ambiente] nvarchar(MAX) COLLATE Latin1_General_CI_AS NULL,
[Exigencia] nvarchar(MAX) COLLATE Latin1_General_CI_AS NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
[IdCagoSemelhante] int NOT NULL,
CONSTRAINT [PK__tbCargos__3D0E29B8F3587E22] PRIMARY KEY ([idCargo]) 
)
GO

DBCC CHECKIDENT (N'[tbCargos]', RESEED, 1)
GO
ALTER TABLE [tbCargos] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbCepBairro] (
[Id_bai] int NOT NULL,
[UF_bai] varchar(2) COLLATE Latin1_General_CI_AS NULL,
[Loc_Nu] int NULL,
[Nome_bai] varchar(72) COLLATE Latin1_General_CI_AS NULL,
[Nome_abrev_bai] varchar(36) COLLATE Latin1_General_CI_AS NULL,
CONSTRAINT [PK__tbCepBai__29D6F05351F7B62F] PRIMARY KEY ([Id_bai]) 
)
GO

DBCC CHECKIDENT (N'[tbCepBairro]', RESEED, 1)
GO
ALTER TABLE [tbCepBairro] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbCepCidade] (
[Id_cid] int NOT NULL,
[UF_cid] varchar(2) COLLATE Latin1_General_CI_AS NULL,
[Cep_cid] varchar(8) COLLATE Latin1_General_CI_AS NULL,
[Nome_cid] varchar(72) COLLATE Latin1_General_CI_AS NULL,
[Nome_abrev_cid] varchar(36) COLLATE Latin1_General_CI_AS NULL,
CONSTRAINT [PK__tbCepCid__5664C49C5D210D36] PRIMARY KEY ([Id_cid]) 
)
GO

DBCC CHECKIDENT (N'[tbCepCidade]', RESEED, 1)
GO
ALTER TABLE [tbCepCidade] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbCepLogradouro] (
[Id_log] int NOT NULL,
[UF_log] varchar(2) COLLATE Latin1_General_CI_AS NULL,
[Loc_Nu] int NULL,
[Bairro_Nu] int NULL,
[Nome_log] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[Comple_log] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[Cep_log] varchar(8) COLLATE Latin1_General_CI_AS NULL,
[Tipo_log] varchar(36) COLLATE Latin1_General_CI_AS NULL,
[Nome_abrev_log] varchar(50) COLLATE Latin1_General_CI_AS NULL,
CONSTRAINT [PK__tbCepLog__54F54AA6A7824C98] PRIMARY KEY ([Id_log]) 
)
GO

CREATE INDEX [Ind_CepLogradouro] ON [tbCepLogradouro] ([Cep_log] ASC)
GO
DBCC CHECKIDENT (N'[tbCepLogradouro]', RESEED, 1)
GO
ALTER TABLE [tbCepLogradouro] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbLogPessoas] (
[IdCodigoCli] bigint NOT NULL,
[Sequencia] bigint NOT NULL IDENTITY(1,1),
[DtAlteracao] date NULL,
[IdCargoAntes] int NULL,
[IdCargoDepois] int NULL,
CONSTRAINT [PK__tbLogPes__760A204E2A44834C] PRIMARY KEY ([IdCodigoCli], [Sequencia]) 
)
GO

DBCC CHECKIDENT (N'[tbLogPessoas]', RESEED, 1)
GO
ALTER TABLE [tbLogPessoas] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbParametros] (
[IdParametro] int NOT NULL,
[DtVigencia] date NULL,
CONSTRAINT [PK__tbParame__37B016F4200BFB8A] PRIMARY KEY ([IdParametro]) 
)
GO

DBCC CHECKIDENT (N'[tbParametros]', RESEED, 1)
GO
ALTER TABLE [tbParametros] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbPessoas] (
[IdCodigoCli] bigint NOT NULL IDENTITY(1,1),
[Nome] varchar(100) COLLATE Latin1_General_CI_AS NOT NULL,
[DtNascimento] date NOT NULL,
[Sexo] char(1) COLLATE Latin1_General_CI_AS NOT NULL,
[IdNacionalidade] int NOT NULL,
[IdEstadoCivil] varchar(2) COLLATE Latin1_General_CI_AS NOT NULL,
[IdComoSoube] int NOT NULL,
[IdEscolar] int NOT NULL,
[Empregado] char(1) COLLATE Latin1_General_CI_AS NOT NULL,
[Email] varchar(100) COLLATE Latin1_General_CI_AS NOT NULL,
[Endereco] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[Numero] varchar(5) COLLATE Latin1_General_CI_AS NULL,
[Complemento] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[Bairro] varchar(72) COLLATE Latin1_General_CI_AS NULL,
[Cidade] varchar(72) COLLATE Latin1_General_CI_AS NULL,
[Uf] varchar(2) COLLATE Latin1_General_CI_AS NULL,
[CEP] varchar(8) COLLATE Latin1_General_CI_AS NOT NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
[IdCargo] int NULL,
CONSTRAINT [PK__tbPessoa__D27DD5CD4777E064] PRIMARY KEY ([IdCodigoCli]) 
)
GO

DBCC CHECKIDENT (N'[tbPessoas]', RESEED, 1)
GO
ALTER TABLE [tbPessoas] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbPessoasContato] (
[IdCodigoCli] bigint NOT NULL,
[Sequencia] int NOT NULL IDENTITY(1,1),
[idTipoFone] int NOT NULL,
[DDI] int NULL,
[DDD] int NULL,
[NumeroFone] varchar(15) COLLATE Latin1_General_CI_AS NULL,
[Complemento] varchar(30) COLLATE Latin1_General_CI_AS NULL,
[Horario] varchar(5) COLLATE Latin1_General_CI_AS NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
CONSTRAINT [PK__tbPessoa__760A204E38FA9836] PRIMARY KEY ([IdCodigoCli], [Sequencia]) 
)
GO

DBCC CHECKIDENT (N'[tbPessoasContato]', RESEED, 1)
GO
ALTER TABLE [tbPessoasContato] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbPessoasDoctos] (
[IdCodigoCli] bigint NOT NULL,
[IdTipoDoctos] int NOT NULL,
[NumeroDocto] varchar(20) COLLATE Latin1_General_CI_AS NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
CONSTRAINT [PK__tbPessoa__67760B61A6832061] PRIMARY KEY ([IdCodigoCli], [IdTipoDoctos]) 
)
GO

DBCC CHECKIDENT (N'[tbPessoasDoctos]', RESEED, 1)
GO
ALTER TABLE [tbPessoasDoctos] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbPessoasRedesSociais] (
[IdCodigoCli] bigint NOT NULL,
[Sequencia] int NOT NULL IDENTITY(1,1),
[idTipoRede] int NOT NULL,
[Endereco] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
CONSTRAINT [PK__tbPessoa__760A204E9CEA9020] PRIMARY KEY ([IdCodigoCli], [Sequencia]) 
)
GO

DBCC CHECKIDENT (N'[tbPessoasRedesSociais]', RESEED, 1)
GO
ALTER TABLE [tbPessoasRedesSociais] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbSalarios] (
[idCargo] int NOT NULL,
[IdNacionalidade] int NOT NULL,
[Uf] varchar(2) COLLATE Latin1_General_CI_AS NOT NULL,
[DtVigencia] date NOT NULL,
[VrSalarioMic] numeric(12,2) NULL,
[VrSalarioPeq] numeric(12,2) NULL,
[VrSalarioMed] numeric(12,2) NULL,
[VrSalarioGrd] numeric(12,2) NULL,
CONSTRAINT [PK__tbSalari__22F6F90655CF5506] PRIMARY KEY ([idCargo], [IdNacionalidade], [Uf], [DtVigencia]) 
)
GO

DBCC CHECKIDENT (N'[tbSalarios]', RESEED, 1)
GO
ALTER TABLE [tbSalarios] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbTipoDoctos] (
[idTipoDocto] int NOT NULL,
[NomeDocto] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[SiglaDocto] varchar(10) COLLATE Latin1_General_CI_AS NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
CONSTRAINT [PK__tbTipoDo__4F86DDDEC19CE6E9] PRIMARY KEY ([idTipoDocto]) 
)
GO

DBCC CHECKIDENT (N'[tbTipoDoctos]', RESEED, 1)
GO
ALTER TABLE [tbTipoDoctos] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbTipoFone] (
[idTipoFone] int NOT NULL,
[NomeFone] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
CONSTRAINT [PK__tbTipoFo__1483902FCBAC7065] PRIMARY KEY ([idTipoFone]) 
)
GO

DBCC CHECKIDENT (N'[tbTipoFone]', RESEED, 1)
GO
ALTER TABLE [tbTipoFone] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbTipoRedeSocial] (
[idTipoRede] int NOT NULL,
[NomeRede] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
CONSTRAINT [PK__tbTipoRe__1098E07613EC1BA2] PRIMARY KEY ([idTipoRede]) 
)
GO

DBCC CHECKIDENT (N'[tbTipoRedeSocial]', RESEED, 1)
GO
ALTER TABLE [tbTipoRedeSocial] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbNacionalidade] (
[IdNacionalidade] int NOT NULL,
[Nacionalidade] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
CONSTRAINT [PK__tbTipoRe__1098E07613EC1BA2] PRIMARY KEY ([IdNacionalidade]) 
)
GO

DBCC CHECKIDENT (N'[tbNacionalidade]', RESEED, 1)
GO
ALTER TABLE [tbNacionalidade] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbEstadocivil] (
[IdEstadoCivil] varchar(2) NOT NULL,
[Descricao] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
CONSTRAINT [PK__tbTipoRe__1098E07613EC1BA2] PRIMARY KEY ([IdEstadoCivil]) 
)
GO

DBCC CHECKIDENT (N'[tbEstadocivil]', RESEED, 1)
GO
ALTER TABLE [tbEstadocivil] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbComoSoube] (
[IdComoSoube] int NOT NULL,
[Descricao] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
CONSTRAINT [PK__tbTipoRe__1098E07613EC1BA2] PRIMARY KEY ([IdComoSoube]) 
)
GO

DBCC CHECKIDENT (N'[tbComoSoube]', RESEED, 1)
GO
ALTER TABLE [tbComoSoube] SET ( LOCK_ESCALATION = TABLE )
GO

CREATE TABLE [tbEscolaridade] (
[IdEscolar] int NOT NULL,
[Descricao] varchar(100) COLLATE Latin1_General_CI_AS NULL,
[DtInclusao] date NULL,
[DtAlteracao] date NULL,
CONSTRAINT [PK__tbTipoRe__1098E07613EC1BA2] PRIMARY KEY ([IdEscolar]) 
)
GO

DBCC CHECKIDENT (N'[tbEscolaridade]', RESEED, 1)
GO
ALTER TABLE [tbEscolaridade] SET ( LOCK_ESCALATION = TABLE )
GO


ALTER TABLE [tbCepBairro] ADD CONSTRAINT [FK__tbCepBair__Loc_N__1273C1CD] FOREIGN KEY ([Loc_Nu]) REFERENCES [tbCepCidade] ([Id_cid]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO
ALTER TABLE [tbCepLogradouro] ADD CONSTRAINT [FK__tbCepLogr__Bairr__15502E78] FOREIGN KEY ([Bairro_Nu]) REFERENCES [tbCepBairro] ([Id_bai]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO
ALTER TABLE [tbCepLogradouro] ADD CONSTRAINT [FK__tbCepLogr__Loc_N__164452B1] FOREIGN KEY ([Loc_Nu]) REFERENCES [tbCepCidade] ([Id_cid]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO
ALTER TABLE [tbLogPessoas] ADD CONSTRAINT [FK__tbLogPess__IdCod__36B12243] FOREIGN KEY ([IdCodigoCli]) REFERENCES [tbPessoas] ([IdCodigoCli]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO
ALTER TABLE [tbPessoas] ADD CONSTRAINT [FK__tbPessoas__IdCar__33D4B598] FOREIGN KEY ([IdCargo]) REFERENCES [tbCargos] ([idCargo]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO
ALTER TABLE [tbPessoasContato] ADD CONSTRAINT [FK__tbPessoas__IdCod__286302EC] FOREIGN KEY ([IdCodigoCli]) REFERENCES [tbPessoas] ([IdCodigoCli]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO
ALTER TABLE [tbPessoasContato] ADD CONSTRAINT [FK__tbPessoas__idTip__239E4DCF] FOREIGN KEY ([idTipoFone]) REFERENCES [tbTipoFone] ([idTipoFone]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO
ALTER TABLE [tbPessoasDoctos] ADD CONSTRAINT [FK__tbPessoas__IdTip__2D27B809] FOREIGN KEY ([IdTipoDoctos]) REFERENCES [tbTipoDoctos] ([idTipoDocto]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO
ALTER TABLE [tbPessoasRedesSociais] ADD CONSTRAINT [FK__tbPessoas__IdCod__1DE57479] FOREIGN KEY ([IdCodigoCli]) REFERENCES [tbPessoas] ([IdCodigoCli]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO
ALTER TABLE [tbPessoasRedesSociais] ADD CONSTRAINT [FK__tbPessoas__idTip__20C1E124] FOREIGN KEY ([idTipoRede]) REFERENCES [tbTipoRedeSocial] ([idTipoRede]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO
ALTER TABLE [tbPessoasDoctos] ADD CONSTRAINT [fk_tbPessoasDoctos_tbPessoas_1] FOREIGN KEY ([IdCodigoCli]) REFERENCES [tbPessoas] ([IdCodigoCli])
GO
ALTER TABLE [tbSalarios] ADD CONSTRAINT [fk_tbSalarios_tbCargos_1] FOREIGN KEY ([idCargo]) REFERENCES [tbCargos] ([idCargo])
GO
ALTER TABLE [tbSalarios] ADD CONSTRAINT [fk_tbSalarios_tbNacionalidade_1] FOREIGN KEY ([IdNacionalidade]) REFERENCES [tbNacionalidade] ([IdNacionalidade])
GO
ALTER TABLE [tbPessoas] ADD CONSTRAINT [fk_tbPessoas_tbNacionalidade_1] FOREIGN KEY ([IdNacionalidade]) REFERENCES [tbNacionalidade] ([IdNacionalidade])
GO
ALTER TABLE [tbPessoas] ADD CONSTRAINT [fk_tbPessoas_tbEstadocivil_1] FOREIGN KEY ([IdEstadoCivil]) REFERENCES [tbEstadocivil] ([IdEstadoCivil])
GO
ALTER TABLE [tbAcesso] ADD CONSTRAINT [fk_tbAcesso_tbPessoas_1] FOREIGN KEY ([IdCodigoCli]) REFERENCES [tbPessoas] ([IdCodigoCli])
GO
ALTER TABLE [tbPessoas] ADD CONSTRAINT [fk_tbPessoas_tbComoSoube_1] FOREIGN KEY ([IdComoSoube]) REFERENCES [tbComoSoube] ([IdComoSoube])
GO
ALTER TABLE [tbPessoas] ADD CONSTRAINT [fk_tbPessoas_tbEscolaridade_1] FOREIGN KEY ([Empregado]) REFERENCES [tbEscolaridade] ([IdEscolar])
GO

