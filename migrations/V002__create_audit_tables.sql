-- =========================================================
-- DROP TABLES LOG
-- =========================================================

DROP TABLE IF EXISTS log_tb_auditoria_transacao CASCADE;
DROP TABLE IF EXISTS log_tb_carga_mensal_item CASCADE;
DROP TABLE IF EXISTS log_tb_carga_mensal CASCADE;
DROP TABLE IF EXISTS log_tb_transacao CASCADE;
DROP TABLE IF EXISTS log_tb_estabelecimento CASCADE;
DROP TABLE IF EXISTS log_tb_categoria_mcc CASCADE;
DROP TABLE IF EXISTS log_tb_saldo_bolso CASCADE;
DROP TABLE IF EXISTS log_tb_tipo_bolso CASCADE;
DROP TABLE IF EXISTS log_tb_cartao CASCADE;
DROP TABLE IF EXISTS log_tb_colaborador CASCADE;
DROP TABLE IF EXISTS log_tb_empresa CASCADE;
DROP TABLE IF EXISTS log_tb_grupo_empresarial CASCADE;


-- =========================================================
-- LOG: GRUPO EMPRESARIAL
-- =========================================================

CREATE TABLE log_tb_grupo_empresarial (
    id_log_grupo               SERIAL PRIMARY KEY,
    id_grupo                   INTEGER,
    operacao                   VARCHAR(20) NOT NULL,
    campo_alterado             VARCHAR(100),
    valor_anterior             JSONB,
    valor_novo                 JSONB,
    usuario                    VARCHAR(100),
    data_hora                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- LOG: EMPRESA
-- =========================================================

CREATE TABLE log_tb_empresa (
    id_log_empresa             SERIAL PRIMARY KEY,
    id_empresa                 INTEGER,
    operacao                   VARCHAR(20) NOT NULL,
    campo_alterado             VARCHAR(100),
    valor_anterior             JSONB,
    valor_novo                 JSONB,
    usuario                    VARCHAR(100),
    data_hora                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- LOG: COLABORADOR
-- =========================================================

CREATE TABLE log_tb_colaborador (
    id_log_colaborador         SERIAL PRIMARY KEY,
    id_colaborador             INTEGER,
    operacao                   VARCHAR(20) NOT NULL,
    campo_alterado             VARCHAR(100),
    valor_anterior             JSONB,
    valor_novo                 JSONB,
    usuario                    VARCHAR(100),
    data_hora                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- LOG: CARTAO
-- =========================================================

CREATE TABLE log_tb_cartao (
    id_log_cartao              SERIAL PRIMARY KEY,
    id_cartao                  INTEGER,
    operacao                   VARCHAR(20) NOT NULL,
    campo_alterado             VARCHAR(100),
    valor_anterior             JSONB,
    valor_novo                 JSONB,
    usuario                    VARCHAR(100),
    data_hora                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- LOG: TIPO BOLSO
-- =========================================================

CREATE TABLE log_tb_tipo_bolso (
    id_log_tipo_bolso          SERIAL PRIMARY KEY,
    id_tipo_bolso              INTEGER,
    operacao                   VARCHAR(20) NOT NULL,
    campo_alterado             VARCHAR(100),
    valor_anterior             JSONB,
    valor_novo                 JSONB,
    usuario                    VARCHAR(100),
    data_hora                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- LOG: SALDO BOLSO
-- =========================================================

CREATE TABLE log_tb_saldo_bolso (
    id_log_saldo_bolso         SERIAL PRIMARY KEY,
    id_saldo_bolso             INTEGER,
    operacao                   VARCHAR(20) NOT NULL,
    campo_alterado             VARCHAR(100),
    saldo_anterior             NUMERIC(12,2),
    saldo_novo                 NUMERIC(12,2),
    valor_anterior             JSONB,
    valor_novo                 JSONB,
    usuario                    VARCHAR(100),
    data_hora                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- LOG: CATEGORIA MCC
-- =========================================================

CREATE TABLE log_tb_categoria_mcc (
    id_log_categoria_mcc       SERIAL PRIMARY KEY,
    id_categoria_mcc           INTEGER,
    operacao                   VARCHAR(20) NOT NULL,
    campo_alterado             VARCHAR(100),
    valor_anterior             JSONB,
    valor_novo                 JSONB,
    usuario                    VARCHAR(100),
    data_hora                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- LOG: ESTABELECIMENTO
-- =========================================================

CREATE TABLE log_tb_estabelecimento (
    id_log_estabelecimento     SERIAL PRIMARY KEY,
    id_estabelecimento         INTEGER,
    operacao                   VARCHAR(20) NOT NULL,
    campo_alterado             VARCHAR(100),
    valor_anterior             JSONB,
    valor_novo                 JSONB,
    usuario                    VARCHAR(100),
    data_hora                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- LOG: TRANSACAO
-- =========================================================

CREATE TABLE log_tb_transacao (
    id_log_transacao           SERIAL PRIMARY KEY,
    id_transacao               INTEGER,
    status                     VARCHAR(30),
    motivo                     VARCHAR(255),
    valor                      NUMERIC(12,2),
    operacao                   VARCHAR(20) NOT NULL,
    campo_alterado             VARCHAR(100),
    valor_anterior             JSONB,
    valor_novo                 JSONB,
    usuario                    VARCHAR(100),
    data_hora                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- LOG: CARGA MENSAL
-- =========================================================

CREATE TABLE log_tb_carga_mensal (
    id_log_carga_mensal        SERIAL PRIMARY KEY,
    id_carga_mensal            INTEGER,
    operacao                   VARCHAR(20) NOT NULL,
    campo_alterado             VARCHAR(100),
    valor_anterior             JSONB,
    valor_novo                 JSONB,
    usuario                    VARCHAR(100),
    data_hora                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- LOG: CARGA MENSAL ITEM
-- =========================================================

CREATE TABLE log_tb_carga_mensal_item (
    id_log_carga_item          SERIAL PRIMARY KEY,
    id_carga_mensal_item       INTEGER,
    operacao                   VARCHAR(20) NOT NULL,
    campo_alterado             VARCHAR(100),
    valor_anterior             JSONB,
    valor_novo                 JSONB,
    usuario                    VARCHAR(100),
    data_hora                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- LOG: AUDITORIA TRANSACAO
-- =========================================================

CREATE TABLE log_tb_auditoria_transacao (
    id_log_auditoria           SERIAL PRIMARY KEY,
    id_auditoria               INTEGER,
    operacao                   VARCHAR(20) NOT NULL,
    campo_alterado             VARCHAR(100),
    valor_anterior             JSONB,
    valor_novo                 JSONB,
    usuario                    VARCHAR(100),
    data_hora                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);