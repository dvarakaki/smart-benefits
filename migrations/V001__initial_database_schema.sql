    -- =========================================================
    -- DROP TABLES
    -- =========================================================

    DROP TABLE IF EXISTS tb_auditoria_transacao CASCADE;
    DROP TABLE IF EXISTS tb_carga_mensal_item CASCADE;
    DROP TABLE IF EXISTS tb_carga_mensal CASCADE;
    DROP TABLE IF EXISTS tb_transacao CASCADE;
    DROP TABLE IF EXISTS tb_estabelecimento CASCADE;
    DROP TABLE IF EXISTS tb_categoria_mcc CASCADE;
    DROP TABLE IF EXISTS tb_saldo_bolso CASCADE;
    DROP TABLE IF EXISTS tb_tipo_bolso CASCADE;
    DROP TABLE IF EXISTS tb_cartao CASCADE;
    DROP TABLE IF EXISTS tb_colaborador CASCADE;
    DROP TABLE IF EXISTS tb_empresa CASCADE;
    DROP TABLE IF EXISTS tb_grupo_empresarial CASCADE;


    -- =========================================================
    -- TABELA: GRUPO EMPRESARIAL
    -- =========================================================

    CREATE TABLE tb_grupo_empresarial (
        id_grupo               SERIAL PRIMARY KEY,
        nome                   VARCHAR(150) NOT NULL,
        cnpj_raiz              VARCHAR(14) NOT NULL UNIQUE,
        ativo                  BOOLEAN NOT NULL DEFAULT TRUE
    );


    -- =========================================================
    -- TABELA: EMPRESA
    -- =========================================================

    CREATE TABLE tb_empresa (
        id_empresa             SERIAL PRIMARY KEY,
        id_grupo               INTEGER NOT NULL,
        nome                   VARCHAR(150) NOT NULL,
        cnpj                   VARCHAR(14) NOT NULL UNIQUE,
        ativa                  BOOLEAN NOT NULL DEFAULT TRUE,

        CONSTRAINT fk_tb_empresa_grupo
            FOREIGN KEY (id_grupo)
            REFERENCES tb_grupo_empresarial(id_grupo)
    );


    -- =========================================================
    -- TABELA: COLABORADOR
    -- =========================================================

    CREATE TABLE tb_colaborador (
        id_colaborador         SERIAL PRIMARY KEY,
        id_empresa             INTEGER NOT NULL,
        nome                   VARCHAR(150) NOT NULL,
        cpf                    VARCHAR(11) NOT NULL UNIQUE,
        matricula              VARCHAR(30) NOT NULL UNIQUE,
        data_admissao          DATE NOT NULL,
        status                 VARCHAR(30) NOT NULL,

        CONSTRAINT fk_tb_colaborador_empresa
            FOREIGN KEY (id_empresa)
            REFERENCES tb_empresa(id_empresa)
    );


    -- =========================================================
    -- TABELA: CARTÃO
    -- =========================================================

    CREATE TABLE tb_cartao (
        id_cartao              SERIAL PRIMARY KEY,
        id_colaborador         INTEGER NOT NULL UNIQUE,
        numero_tokenizado      VARCHAR(100) NOT NULL UNIQUE,
        status                 VARCHAR(30) NOT NULL,
        data_emissao           DATE NOT NULL,
        data_validade          DATE NOT NULL,

        CONSTRAINT fk_tb_cartao_colaborador
            FOREIGN KEY (id_colaborador)
            REFERENCES tb_colaborador(id_colaborador)
    );


    -- =========================================================
    -- TABELA: TIPO BOLSO
    -- =========================================================

    CREATE TABLE tb_tipo_bolso (
        id_tipo_bolso          SERIAL PRIMARY KEY,
        codigo                 VARCHAR(50) NOT NULL UNIQUE,
        descricao              VARCHAR(150) NOT NULL
    );


    -- =========================================================
    -- TABELA: SALDO BOLSO
    -- =========================================================

    CREATE TABLE tb_saldo_bolso (
        id_saldo_bolso         SERIAL PRIMARY KEY,
        id_cartao              INTEGER NOT NULL,
        id_tipo_bolso          INTEGER NOT NULL,
        saldo_atual            NUMERIC(12,2) NOT NULL DEFAULT 0,
        ultima_atualizacao     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

        CONSTRAINT fk_tb_saldo_cartao
            FOREIGN KEY (id_cartao)
            REFERENCES tb_cartao(id_cartao),

        CONSTRAINT fk_tb_saldo_tipo_bolso
            FOREIGN KEY (id_tipo_bolso)
            REFERENCES tb_tipo_bolso(id_tipo_bolso),

        CONSTRAINT uq_tb_saldo_cartao_bolso
            UNIQUE (id_cartao, id_tipo_bolso)
    );


    -- =========================================================
    -- TABELA: CATEGORIA MCC
    -- =========================================================

    CREATE TABLE tb_categoria_mcc (
        id_categoria_mcc       SERIAL PRIMARY KEY,
        mcc                    VARCHAR(10) NOT NULL UNIQUE,
        descricao              VARCHAR(150) NOT NULL,
        id_tipo_bolso          INTEGER NOT NULL,
        ativa                  BOOLEAN NOT NULL DEFAULT TRUE,

        CONSTRAINT fk_tb_categoria_bolso
            FOREIGN KEY (id_tipo_bolso)
            REFERENCES tb_tipo_bolso(id_tipo_bolso)
    );


    -- =========================================================
    -- TABELA: ESTABELECIMENTO
    -- =========================================================

    CREATE TABLE tb_estabelecimento (
        id_estabelecimento     SERIAL PRIMARY KEY,
        nome                   VARCHAR(150) NOT NULL,
        cnpj                   VARCHAR(14) NOT NULL UNIQUE,
        id_categoria_mcc       INTEGER NOT NULL,
        cidade                 VARCHAR(100) NOT NULL,
        uf                     CHAR(2) NOT NULL,

        CONSTRAINT fk_tb_estabelecimento_categoria
            FOREIGN KEY (id_categoria_mcc)
            REFERENCES tb_categoria_mcc(id_categoria_mcc)
    );


    -- =========================================================
    -- TABELA: TRANSAÇÃO
    -- =========================================================

    CREATE TABLE tb_transacao (
        id_transacao           SERIAL PRIMARY KEY,
        id_cartao              INTEGER NOT NULL,
        id_estabelecimento     INTEGER NOT NULL,
        id_tipo_bolso          INTEGER NOT NULL,
        valor                  NUMERIC(12,2) NOT NULL,
        status                 VARCHAR(30),
        motivo                 VARCHAR(255),
        data_hora              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        usuario_registro       VARCHAR(100) NOT NULL,

        CONSTRAINT fk_tb_transacao_cartao
            FOREIGN KEY (id_cartao)
            REFERENCES tb_cartao(id_cartao),

        CONSTRAINT fk_tb_transacao_estabelecimento
            FOREIGN KEY (id_estabelecimento)
            REFERENCES tb_estabelecimento(id_estabelecimento),

        CONSTRAINT fk_tb_transacao_tipo_bolso
            FOREIGN KEY (id_tipo_bolso)
            REFERENCES tb_tipo_bolso(id_tipo_bolso)
    );


    -- =========================================================
    -- TABELA: CARGA MENSAL
    -- =========================================================

    CREATE TABLE tb_carga_mensal (
        id_carga_mensal        SERIAL PRIMARY KEY,
        competencia            VARCHAR(7) NOT NULL,
        data_execucao          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        usuario_execucao       VARCHAR(100) NOT NULL,
        status                 VARCHAR(30) NOT NULL
    );


    -- =========================================================
    -- TABELA: CARGA MENSAL ITEM
    -- =========================================================

    CREATE TABLE tb_carga_mensal_item (
        id_carga_mensal_item   SERIAL PRIMARY KEY,
        id_carga_mensal        INTEGER NOT NULL,
        id_colaborador         INTEGER NOT NULL,
        id_tipo_bolso          INTEGER NOT NULL,
        valor_creditado        NUMERIC(12,2) NOT NULL,

        CONSTRAINT fk_tb_item_carga
            FOREIGN KEY (id_carga_mensal)
            REFERENCES tb_carga_mensal(id_carga_mensal),

        CONSTRAINT fk_tb_item_colaborador
            FOREIGN KEY (id_colaborador)
            REFERENCES tb_colaborador(id_colaborador),

        CONSTRAINT fk_tb_item_tipo_bolso
            FOREIGN KEY (id_tipo_bolso)
            REFERENCES tb_tipo_bolso(id_tipo_bolso)
    );


    -- =========================================================
    -- TABELA: AUDITORIA TRANSAÇÃO
    -- =========================================================

    CREATE TABLE tb_auditoria_transacao (
        id_auditoria           SERIAL PRIMARY KEY,
        tabela_origem          VARCHAR(100) NOT NULL,
        id_registro            INTEGER NOT NULL,
        operacao               VARCHAR(20) NOT NULL,
        usuario                VARCHAR(100) NOT NULL,
        data_hora              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        descricao              VARCHAR(255)
    );
