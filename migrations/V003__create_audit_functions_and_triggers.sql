-- =========================================================
-- DROPS DAS TRIGGERS EXISTENTES
-- =========================================================

DROP TRIGGER IF EXISTS trg_log_tb_grupo_empresarial ON tb_grupo_empresarial;
DROP TRIGGER IF EXISTS trg_log_tb_empresa ON tb_empresa;
DROP TRIGGER IF EXISTS trg_log_tb_colaborador ON tb_colaborador;
DROP TRIGGER IF EXISTS trg_log_tb_cartao ON tb_cartao;
DROP TRIGGER IF EXISTS trg_log_tb_tipo_bolso ON tb_tipo_bolso;
DROP TRIGGER IF EXISTS trg_log_tb_saldo_bolso ON tb_saldo_bolso;
DROP TRIGGER IF EXISTS trg_log_tb_categoria_mcc ON tb_categoria_mcc;
DROP TRIGGER IF EXISTS trg_log_tb_estabelecimento ON tb_estabelecimento;
DROP TRIGGER IF EXISTS trg_log_tb_transacao ON tb_transacao;
DROP TRIGGER IF EXISTS trg_log_tb_carga_mensal ON tb_carga_mensal;
DROP TRIGGER IF EXISTS trg_log_tb_carga_mensal_item ON tb_carga_mensal_item;
DROP TRIGGER IF EXISTS trg_log_tb_auditoria_transacao ON tb_auditoria_transacao;

-- =========================================================
-- FUNCTION + TRIGGER: GRUPO EMPRESARIAL
-- =========================================================

CREATE OR REPLACE FUNCTION fn_log_tb_grupo_empresarial()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_operacao VARCHAR(20);
BEGIN

    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERIDO';

        INSERT INTO log_tb_grupo_empresarial (
            id_grupo,
            operacao,
            campo_alterado,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_grupo,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZADO';

        INSERT INTO log_tb_grupo_empresarial (
            id_grupo,
            operacao,
            campo_alterado,
            valor_anterior,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_grupo,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETADO';

        INSERT INTO log_tb_grupo_empresarial (
            id_grupo,
            operacao,
            campo_alterado,
            valor_anterior,
            usuario
        )
        VALUES (
            OLD.id_grupo,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            CURRENT_USER
        );

        RETURN OLD;
    END IF;

END;
$$;

CREATE TRIGGER trg_log_tb_grupo_empresarial
AFTER INSERT OR UPDATE OR DELETE
ON tb_grupo_empresarial
FOR EACH ROW
EXECUTE FUNCTION fn_log_tb_grupo_empresarial();


-- =========================================================
-- FUNCTION + TRIGGER: EMPRESA
-- =========================================================

CREATE OR REPLACE FUNCTION fn_log_tb_empresa()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_operacao VARCHAR(20);
BEGIN

    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERIDO';

        INSERT INTO log_tb_empresa (
            id_empresa,
            operacao,
            campo_alterado,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_empresa,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZADO';

        INSERT INTO log_tb_empresa (
            id_empresa,
            operacao,
            campo_alterado,
            valor_anterior,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_empresa,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETADO';

        INSERT INTO log_tb_empresa (
            id_empresa,
            operacao,
            campo_alterado,
            valor_anterior,
            usuario
        )
        VALUES (
            OLD.id_empresa,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            CURRENT_USER
        );

        RETURN OLD;
    END IF;

END;
$$;

CREATE TRIGGER trg_log_tb_empresa
AFTER INSERT OR UPDATE OR DELETE
ON tb_empresa
FOR EACH ROW
EXECUTE FUNCTION fn_log_tb_empresa();


-- =========================================================
-- FUNCTION + TRIGGER: COLABORADOR
-- =========================================================

CREATE OR REPLACE FUNCTION fn_log_tb_colaborador()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_operacao VARCHAR(20);
BEGIN

    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERIDO';

        INSERT INTO log_tb_colaborador (
            id_colaborador,
            operacao,
            campo_alterado,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_colaborador,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZADO';

        INSERT INTO log_tb_colaborador (
            id_colaborador,
            operacao,
            campo_alterado,
            valor_anterior,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_colaborador,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETADO';

        INSERT INTO log_tb_colaborador (
            id_colaborador,
            operacao,
            campo_alterado,
            valor_anterior,
            usuario
        )
        VALUES (
            OLD.id_colaborador,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            CURRENT_USER
        );

        RETURN OLD;
    END IF;

END;
$$;

CREATE TRIGGER trg_log_tb_colaborador
AFTER INSERT OR UPDATE OR DELETE
ON tb_colaborador
FOR EACH ROW
EXECUTE FUNCTION fn_log_tb_colaborador();


-- =========================================================
-- FUNCTION + TRIGGER: CARTAO
-- =========================================================

CREATE OR REPLACE FUNCTION fn_log_tb_cartao()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_operacao VARCHAR(20);
BEGIN

    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERIDO';

        INSERT INTO log_tb_cartao (
            id_cartao,
            operacao,
            campo_alterado,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_cartao,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZADO';

        INSERT INTO log_tb_cartao (
            id_cartao,
            operacao,
            campo_alterado,
            valor_anterior,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_cartao,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETADO';

        INSERT INTO log_tb_cartao (
            id_cartao,
            operacao,
            campo_alterado,
            valor_anterior,
            usuario
        )
        VALUES (
            OLD.id_cartao,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            CURRENT_USER
        );

        RETURN OLD;
    END IF;

END;
$$;

CREATE TRIGGER trg_log_tb_cartao
AFTER INSERT OR UPDATE OR DELETE
ON tb_cartao
FOR EACH ROW
EXECUTE FUNCTION fn_log_tb_cartao();

-- =========================================================
-- FUNCTION + TRIGGER: TIPO BOLSO
-- =========================================================

CREATE OR REPLACE FUNCTION fn_log_tb_tipo_bolso()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_operacao VARCHAR(20);
BEGIN

    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERIDO';

        INSERT INTO log_tb_tipo_bolso (
            id_tipo_bolso,
            operacao,
            campo_alterado,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_tipo_bolso,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZADO';

        INSERT INTO log_tb_tipo_bolso (
            id_tipo_bolso,
            operacao,
            campo_alterado,
            valor_anterior,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_tipo_bolso,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETADO';

        INSERT INTO log_tb_tipo_bolso (
            id_tipo_bolso,
            operacao,
            campo_alterado,
            valor_anterior,
            usuario
        )
        VALUES (
            OLD.id_tipo_bolso,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            CURRENT_USER
        );

        RETURN OLD;
    END IF;

END;
$$;

CREATE TRIGGER trg_log_tb_tipo_bolso
AFTER INSERT OR UPDATE OR DELETE
ON tb_tipo_bolso
FOR EACH ROW
EXECUTE FUNCTION fn_log_tb_tipo_bolso();


-- =========================================================
-- FUNCTION + TRIGGER: SALDO BOLSO
-- =========================================================

CREATE OR REPLACE FUNCTION fn_log_tb_saldo_bolso()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_operacao VARCHAR(20);
    v_campo_alterado VARCHAR(100);
BEGIN

    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERIDO';
        v_campo_alterado := 'saldo_atual';

        INSERT INTO log_tb_saldo_bolso (
            id_saldo_bolso,
            operacao,
            campo_alterado,
            saldo_novo,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_saldo_bolso,
            v_operacao,
            v_campo_alterado,
            NEW.saldo_atual,
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZADO';
        
        -- Identifica quais campos foram alterados
        IF OLD.saldo_atual IS DISTINCT FROM NEW.saldo_atual THEN
            v_campo_alterado := 'saldo_atual';
        ELSE
            v_campo_alterado := 'multiplos_campos';
        END IF;

        INSERT INTO log_tb_saldo_bolso (
            id_saldo_bolso,
            operacao,
            campo_alterado,
            saldo_anterior,
            saldo_novo,
            valor_anterior,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_saldo_bolso,
            v_operacao,
            v_campo_alterado,
            OLD.saldo_atual,
            NEW.saldo_atual,
            to_jsonb(OLD),
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETADO';
        v_campo_alterado := 'saldo_atual';

        INSERT INTO log_tb_saldo_bolso (
            id_saldo_bolso,
            operacao,
            campo_alterado,
            saldo_anterior,
            valor_anterior,
            usuario
        )
        VALUES (
            OLD.id_saldo_bolso,
            v_operacao,
            v_campo_alterado,
            OLD.saldo_atual,
            to_jsonb(OLD),
            CURRENT_USER
        );

        RETURN OLD;
    END IF;

END;
$$;

CREATE TRIGGER trg_log_tb_saldo_bolso
AFTER INSERT OR UPDATE OR DELETE
ON tb_saldo_bolso
FOR EACH ROW
EXECUTE FUNCTION fn_log_tb_saldo_bolso();


-- =========================================================
-- FUNCTION + TRIGGER: CATEGORIA MCC
-- =========================================================

CREATE OR REPLACE FUNCTION fn_log_tb_categoria_mcc()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_operacao VARCHAR(20);
BEGIN

    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERIDO';

        INSERT INTO log_tb_categoria_mcc (
            id_categoria_mcc,
            operacao,
            campo_alterado,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_categoria_mcc,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZADO';

        INSERT INTO log_tb_categoria_mcc (
            id_categoria_mcc,
            operacao,
            campo_alterado,
            valor_anterior,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_categoria_mcc,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETADO';

        INSERT INTO log_tb_categoria_mcc (
            id_categoria_mcc,
            operacao,
            campo_alterado,
            valor_anterior,
            usuario
        )
        VALUES (
            OLD.id_categoria_mcc,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            CURRENT_USER
        );

        RETURN OLD;
    END IF;

END;
$$;

CREATE TRIGGER trg_log_tb_categoria_mcc
AFTER INSERT OR UPDATE OR DELETE
ON tb_categoria_mcc
FOR EACH ROW
EXECUTE FUNCTION fn_log_tb_categoria_mcc();


-- =========================================================
-- FUNCTION + TRIGGER: ESTABELECIMENTO
-- =========================================================

CREATE OR REPLACE FUNCTION fn_log_tb_estabelecimento()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_operacao VARCHAR(20);
BEGIN

    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERIDO';

        INSERT INTO log_tb_estabelecimento (
            id_estabelecimento,
            operacao,
            campo_alterado,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_estabelecimento,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZADO';

        INSERT INTO log_tb_estabelecimento (
            id_estabelecimento,
            operacao,
            campo_alterado,
            valor_anterior,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_estabelecimento,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETADO';

        INSERT INTO log_tb_estabelecimento (
            id_estabelecimento,
            operacao,
            campo_alterado,
            valor_anterior,
            usuario
        )
        VALUES (
            OLD.id_estabelecimento,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            CURRENT_USER
        );

        RETURN OLD;
    END IF;

END;
$$;

CREATE TRIGGER trg_log_tb_estabelecimento
AFTER INSERT OR UPDATE OR DELETE
ON tb_estabelecimento
FOR EACH ROW
EXECUTE FUNCTION fn_log_tb_estabelecimento();


-- =========================================================
-- FUNCTION + TRIGGER: TRANSACAO
-- =========================================================

CREATE OR REPLACE FUNCTION fn_log_tb_transacao()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_operacao VARCHAR(20);
    v_campo_alterado VARCHAR(100);
BEGIN

    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERIDO';
        v_campo_alterado := 'REGISTRO_COMPLETO';

        INSERT INTO log_tb_transacao (
            id_transacao,
            status,
            motivo,
            valor,
            operacao,
            campo_alterado,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_transacao,
            NEW.status,
            NEW.motivo,
            NEW.valor,
            v_operacao,
            v_campo_alterado,
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZADO';
        
        -- Identifica quais campos foram alterados
        IF OLD.status IS DISTINCT FROM NEW.status THEN
            v_campo_alterado := 'status';
        ELSIF OLD.motivo IS DISTINCT FROM NEW.motivo THEN
            v_campo_alterado := 'motivo';
        ELSIF OLD.valor IS DISTINCT FROM NEW.valor THEN
            v_campo_alterado := 'valor';
        ELSE
            v_campo_alterado := 'multiplos_campos';
        END IF;

        INSERT INTO log_tb_transacao (
            id_transacao,
            status,
            motivo,
            valor,
            operacao,
            campo_alterado,
            valor_anterior,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_transacao,
            NEW.status,
            NEW.motivo,
            NEW.valor,
            v_operacao,
            v_campo_alterado,
            to_jsonb(OLD),
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETADO';
        v_campo_alterado := 'REGISTRO_COMPLETO';

        INSERT INTO log_tb_transacao (
            id_transacao,
            status,
            motivo,
            valor,
            operacao,
            campo_alterado,
            valor_anterior,
            usuario
        )
        VALUES (
            OLD.id_transacao,
            OLD.status,
            OLD.motivo,
            OLD.valor,
            v_operacao,
            v_campo_alterado,
            to_jsonb(OLD),
            CURRENT_USER
        );

        RETURN OLD;
    END IF;

END;
$$;

CREATE TRIGGER trg_log_tb_transacao
AFTER INSERT OR UPDATE OR DELETE
ON tb_transacao
FOR EACH ROW
EXECUTE FUNCTION fn_log_tb_transacao();


-- =========================================================
-- FUNCTION + TRIGGER: CARGA MENSAL
-- =========================================================

CREATE OR REPLACE FUNCTION fn_log_tb_carga_mensal()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_operacao VARCHAR(20);
BEGIN

    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERIDO';

        INSERT INTO log_tb_carga_mensal (
            id_carga_mensal,
            operacao,
            campo_alterado,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_carga_mensal,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZADO';

        INSERT INTO log_tb_carga_mensal (
            id_carga_mensal,
            operacao,
            campo_alterado,
            valor_anterior,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_carga_mensal,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETADO';

        INSERT INTO log_tb_carga_mensal (
            id_carga_mensal,
            operacao,
            campo_alterado,
            valor_anterior,
            usuario
        )
        VALUES (
            OLD.id_carga_mensal,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            CURRENT_USER
        );

        RETURN OLD;
    END IF;

END;
$$;

CREATE TRIGGER trg_log_tb_carga_mensal
AFTER INSERT OR UPDATE OR DELETE
ON tb_carga_mensal
FOR EACH ROW
EXECUTE FUNCTION fn_log_tb_carga_mensal();


-- =========================================================
-- FUNCTION + TRIGGER: CARGA MENSAL ITEM
-- =========================================================

CREATE OR REPLACE FUNCTION fn_log_tb_carga_mensal_item()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_operacao VARCHAR(20);
    v_campo_alterado VARCHAR(100);
BEGIN

    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERIDO';
        v_campo_alterado := 'REGISTRO_COMPLETO';

        INSERT INTO log_tb_carga_mensal_item (
            id_carga_mensal_item,
            operacao,
            campo_alterado,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_carga_mensal_item,
            v_operacao,
            v_campo_alterado,
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZADO';
        
        -- Identifica quais campos foram alterados
        IF OLD.valor_creditado IS DISTINCT FROM NEW.valor_creditado THEN
            v_campo_alterado := 'valor_creditado';
        ELSE
            v_campo_alterado := 'multiplos_campos';
        END IF;

        INSERT INTO log_tb_carga_mensal_item (
            id_carga_mensal_item,
            operacao,
            campo_alterado,
            valor_anterior,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_carga_mensal_item,
            v_operacao,
            v_campo_alterado,
            to_jsonb(OLD),
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETADO';
        v_campo_alterado := 'REGISTRO_COMPLETO';

        INSERT INTO log_tb_carga_mensal_item (
            id_carga_mensal_item,
            operacao,
            campo_alterado,
            valor_anterior,
            usuario
        )
        VALUES (
            OLD.id_carga_mensal_item,
            v_operacao,
            v_campo_alterado,
            to_jsonb(OLD),
            CURRENT_USER
        );

        RETURN OLD;
    END IF;

END;
$$;

CREATE TRIGGER trg_log_tb_carga_mensal_item
AFTER INSERT OR UPDATE OR DELETE
ON tb_carga_mensal_item
FOR EACH ROW
EXECUTE FUNCTION fn_log_tb_carga_mensal_item();


-- =========================================================
-- FUNCTION + TRIGGER: AUDITORIA TRANSACAO
-- =========================================================

CREATE OR REPLACE FUNCTION fn_log_tb_auditoria_transacao()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_operacao VARCHAR(20);
BEGIN

    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERIDO';

        INSERT INTO log_tb_auditoria_transacao (
            id_auditoria,
            operacao,
            campo_alterado,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_auditoria,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZADO';

        INSERT INTO log_tb_auditoria_transacao (
            id_auditoria,
            operacao,
            campo_alterado,
            valor_anterior,
            valor_novo,
            usuario
        )
        VALUES (
            NEW.id_auditoria,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            to_jsonb(NEW),
            CURRENT_USER
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETADO';

        INSERT INTO log_tb_auditoria_transacao (
            id_auditoria,
            operacao,
            campo_alterado,
            valor_anterior,
            usuario
        )
        VALUES (
            OLD.id_auditoria,
            v_operacao,
            'REGISTRO_COMPLETO',
            to_jsonb(OLD),
            CURRENT_USER
        );

        RETURN OLD;
    END IF;

END;
$$;

CREATE TRIGGER trg_log_tb_auditoria_transacao
AFTER INSERT OR UPDATE OR DELETE
ON tb_auditoria_transacao
FOR EACH ROW
EXECUTE FUNCTION fn_log_tb_auditoria_transacao();