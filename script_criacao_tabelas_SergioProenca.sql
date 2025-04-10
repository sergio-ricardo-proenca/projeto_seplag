----------------------------------Obs: Seguir a sequência de criação das tabelas ------------------------------

----------------------------------------------- Tabela Cidade -------------------------------------------------- 

CREATE SEQUENCE cid_id MINVALUE 1 INCREMENT 1;
CREATE TABLE cidade (
  cid_id   BIGINT    NOT NULL    DEFAULT Nextval('cid_id'),
  cid_nome VARCHAR(200),
  cid_uf   CHAR(2),
     PRIMARY KEY ( cid_id ));
	 
COMMENT ON TABLE cidade IS 'cidade';
COMMENT ON COLUMN cidade.cid_id IS 'Id da Cidade';
COMMENT ON COLUMN cidade.cid_nome IS 'Nome da Cidade';
COMMENT ON COLUMN cidade.cid_uf IS 'UF da Cidade';	 


----------------------------------------------- Tabela endereco -------------------------------------------------- 

CREATE SEQUENCE end_id MINVALUE 1 INCREMENT 1;
CREATE TABLE endereco (
  end_id              BIGINT    NOT NULL    DEFAULT Nextval('end_id'),
  end_tipo_logradouro VARCHAR(50),
  end_logradouro      VARCHAR(200),
  end_numero          BIGINT,
  end_bairro          VARCHAR(100),
  cid_id              BIGINT,
     PRIMARY KEY ( end_id ));
	 
COMMENT ON TABLE endereco IS 'endereco';
COMMENT ON COLUMN endereco.end_id IS 'Id do Endereço';
COMMENT ON COLUMN endereco.end_tipo_logradouro IS 'Tipo Logradouro';
COMMENT ON COLUMN endereco.end_logradouro IS 'Logradouro';
COMMENT ON COLUMN endereco.end_numero IS 'Numero';
COMMENT ON COLUMN endereco.end_bairro IS 'Bairro';
COMMENT ON COLUMN endereco.cid_id IS 'Id da Cidade';
CREATE INDEX IENDERECO1 ON endereco (cid_id);

ALTER TABLE endereco ADD CONSTRAINT IENDERECO1 FOREIGN KEY ( cid_id ) REFERENCES cidade(cid_id);


----------------------------------------------- Tabela pessoa --------------------------------------------------

CREATE SEQUENCE pes_id MINVALUE 1 INCREMENT 1;
CREATE TABLE pessoa (
  pes_id              BIGINT    NOT NULL    DEFAULT Nextval('pes_id'),
  pes_nome            VARCHAR(200),
  pes_data_nascimento DATE,
  pes_sexo            VARCHAR(9),
  pes_mae             VARCHAR(200),
  pes_pai             VARCHAR(200),
     PRIMARY KEY ( pes_id ));
	 
COMMENT ON TABLE pessoa IS 'pessoa';
COMMENT ON COLUMN pessoa.pes_id IS 'Id da Pessoa';
COMMENT ON COLUMN pessoa.pes_nome IS 'Nome da Pessoa';
COMMENT ON COLUMN pessoa.pes_data_nascimento IS 'Data de Nascimento';
COMMENT ON COLUMN pessoa.pes_sexo IS 'Sexo';
COMMENT ON COLUMN pessoa.pes_mae IS 'Mãe';
COMMENT ON COLUMN pessoa.pes_pai IS 'Nome do Pai';

----------------------------------------------- Tabela foto_pessoa --------------------------------------------------

CREATE SEQUENCE fp_id MINVALUE 1 INCREMENT 1;
CREATE TABLE foto_pessoa (
  fp_id       BIGINT    NOT NULL    DEFAULT Nextval('fp_id'),
  pes_id      BIGINT    NOT NULL,
  fp_data     DATE,
  fp_bucket   VARCHAR(50),
  fp_hash     VARCHAR(50),
  fp_foto     BYTEA,
  fp_foto_GXI VARCHAR(2048),
     PRIMARY KEY ( fp_id ));
	 
COMMENT ON TABLE foto_pessoa IS 'foto_pessoa';
COMMENT ON COLUMN foto_pessoa.fp_id IS 'Id da Foto';
COMMENT ON COLUMN foto_pessoa.pes_id IS 'Id da Pessoa';
COMMENT ON COLUMN foto_pessoa.fp_data IS 'Data';
COMMENT ON COLUMN foto_pessoa.fp_bucket IS 'Bucket';
COMMENT ON COLUMN foto_pessoa.fp_hash IS 'Hash';
COMMENT ON COLUMN foto_pessoa.fp_foto IS 'fp_foto';
COMMENT ON COLUMN foto_pessoa.fp_foto_GXI IS '';
CREATE INDEX IFOTO_PESSOA1 ON foto_pessoa (pes_id);

ALTER TABLE foto_pessoa ADD CONSTRAINT IFOTO_PESSOA1 FOREIGN KEY ( pes_id ) REFERENCES pessoa(pes_id);

----------------------------------------------- Tabela pessoa_endereco --------------------------------------------------

CREATE TABLE pessoa_endereco (
  pes_id BIGINT    NOT NULL,
  end_id BIGINT    NOT NULL,
     PRIMARY KEY ( pes_id,end_id ));
	 
COMMENT ON TABLE pessoa_endereco IS 'endereco';
COMMENT ON COLUMN pessoa_endereco.pes_id IS 'Id da Pessoa';
COMMENT ON COLUMN pessoa_endereco.end_id IS 'Id do Endereço';
CREATE INDEX IPESSOAENDERECO1 ON pessoa_endereco (end_id);

ALTER TABLE pessoa_endereco ADD CONSTRAINT IPESSOAENDERECO2 FOREIGN KEY ( pes_id ) REFERENCES pessoa(pes_id);
ALTER TABLE pessoa_endereco ADD CONSTRAINT IPESSOAENDERECO1 FOREIGN KEY ( end_id ) REFERENCES endereco(end_id);

----------------------------------------------- Tabela servidor_efetivo --------------------------------------------------

CREATE TABLE servidor_efetivo (
  se_pes_id    BIGINT    NOT NULL,
  se_matricula VARCHAR(20),
     PRIMARY KEY ( se_pes_id ));
	 
COMMENT ON TABLE servidor_efetivo IS 'servidor_efetivo';
COMMENT ON COLUMN servidor_efetivo.se_pes_id IS 'Id da Pessoa';
COMMENT ON COLUMN servidor_efetivo.se_matricula IS 'Matrícula do Servidor Efetivo';

ALTER TABLE servidor_efetivo ADD CONSTRAINT ISERVIDOR_EFETIVO FOREIGN KEY ( se_pes_id ) REFERENCES pessoa(pes_id);

----------------------------------------------- Tabela servidor_temporario --------------------------------------------------

CREATE SEQUENCE st_id MINVALUE 1 INCREMENT 1;
CREATE TABLE servidor_temporario (
  st_id            BIGINT    NOT NULL    DEFAULT Nextval('st_id'),
  st_pes_id        BIGINT    NOT NULL,
  st_data_demissao DATE,
  st_data_admissao DATE,
     PRIMARY KEY ( st_id ));
	 
COMMENT ON TABLE servidor_temporario IS 'servidor_temporario';
COMMENT ON COLUMN servidor_temporario.st_id IS 'st_id';
COMMENT ON COLUMN servidor_temporario.st_pes_id IS 'Id da Pessoa';
COMMENT ON COLUMN servidor_temporario.st_data_demissao IS 'st_data_demissao';
COMMENT ON COLUMN servidor_temporario.st_data_admissao IS 'st_data_admissao';

CREATE INDEX ISERVIDOR_TEMPORARIO1 ON servidor_temporario (st_pes_id);

ALTER TABLE servidor_temporario ADD CONSTRAINT ISERVIDOR_TEMPORARIO1 FOREIGN KEY ( st_pes_id ) REFERENCES pessoa(pes_id);

----------------------------------------------- Tabela unidade --------------------------------------------------

CREATE SEQUENCE unid_id MINVALUE 1 INCREMENT 1;
CREATE TABLE unidade (
  unid_id    BIGINT    NOT NULL    DEFAULT Nextval('unid_id'),
  unid_nome  VARCHAR(200),
  unid_sigla VARCHAR(20),
     PRIMARY KEY ( unid_id ));
	 
COMMENT ON TABLE unidade IS 'unidade';
COMMENT ON COLUMN unidade.unid_id IS 'Id da Unidade';
COMMENT ON COLUMN unidade.unid_nome IS 'Nome da Unidade';
COMMENT ON COLUMN unidade.unid_sigla IS 'Sigla da Unidade';

----------------------------------------------- Tabela unidade_endereco --------------------------------------------------

CREATE TABLE unidade_endereco (
  unid_id BIGINT    NOT NULL,
  end_id  BIGINT    NOT NULL,
     PRIMARY KEY ( unid_id,end_id ));
	 
COMMENT ON TABLE unidade_endereco IS 'endereco';
COMMENT ON COLUMN unidade_endereco.unid_id IS 'Id da Unidade';
COMMENT ON COLUMN unidade_endereco.end_id IS 'Id do Endereço';

CREATE INDEX IUNIDADEENDERECO1 ON unidade_endereco (end_id);

ALTER TABLE unidade_endereco ADD CONSTRAINT IUNIDADEENDERECO2 FOREIGN KEY ( unid_id ) REFERENCES unidade(unid_id);
ALTER TABLE unidade_endereco ADD CONSTRAINT IUNIDADEENDERECO1 FOREIGN KEY ( end_id ) REFERENCES endereco(end_id);

----------------------------------------------- Tabela lotacao --------------------------------------------------

CREATE SEQUENCE lot_id MINVALUE 1 INCREMENT 1;
CREATE TABLE lotacao (
  lot_id           BIGINT    NOT NULL    DEFAULT Nextval('lot_id'),
  pes_id           BIGINT    NOT NULL,
  unid_id          BIGINT    NOT NULL,
  lot_data_lotacao DATE,
  lot_data_remocao DATE,
  lot_portaria     VARCHAR(100),
     PRIMARY KEY ( lot_id ));
	 
COMMENT ON TABLE lotacao IS 'lotacao';
COMMENT ON COLUMN lotacao.lot_id IS 'Id da Lotacao';
COMMENT ON COLUMN lotacao.pes_id IS 'Id da Pessoa';
COMMENT ON COLUMN lotacao.unid_id IS 'Id da Unidade';
COMMENT ON COLUMN lotacao.lot_data_lotacao IS 'Data da Lotacao';
COMMENT ON COLUMN lotacao.lot_data_remocao IS 'Data Remocao';
COMMENT ON COLUMN lotacao.lot_portaria IS 'Portaria';

CREATE INDEX ILOTACAO1 ON lotacao (unid_id);
CREATE INDEX ILOTACAO2 ON lotacao (pes_id);

ALTER TABLE lotacao ADD CONSTRAINT ILOTACAO2 FOREIGN KEY ( pes_id ) REFERENCES pessoa(pes_id);
ALTER TABLE lotacao ADD CONSTRAINT ILOTACAO1 FOREIGN KEY ( unid_id ) REFERENCES unidade(unid_id);