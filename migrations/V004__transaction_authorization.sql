-- =========================================================
-- FUNCTION: VALIDAR TRANSACAO
-- =========================================================

CREATE OR REPLACE FUNCTION fn_validar_transacao()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_saldo_atual          NUMERIC(12,2);
    v_tipo_bolso_mcc       INTEGER;
BEGIN
    SELECT id_tipo_bolso
    INTO v_tipo_bolso_mcc
    FROM tb_estabelecimento e
    INNER JOIN tb_categoria_mcc c
        ON c.id_categoria_mcc = e.id_categoria_mcc
    WHERE e.id_estabelecimento = NEW.id_estabelecimento;

    IF v_tipo_bolso_mcc <> NEW.id_tipo_bolso THEN

        INSERT INTO tb_auditoria_transacao (
            tabela_origem,
            id_registro,
            operacao,
            usuario,
            descricao
        )
        VALUES (
            'tb_transacao',
            NEW.id_cartao,
            'BLOQUEIO',
            NEW.usuario_registro,
            'Categoria MCC incompatível com o tipo de bolso.'
        );

        RAISE EXCEPTION
            'Transação negada: MCC incompatível com o bolso informado.';
    END IF;
	
    SELECT saldo_atual
    INTO v_saldo_atual
    FROM tb_saldo_bolso
    WHERE id_cartao = NEW.id_cartao
      AND id_tipo_bolso = NEW.id_tipo_bolso;

    IF v_saldo_atual IS NULL THEN

        INSERT INTO tb_auditoria_transacao (
            tabela_origem,
            id_registro,
            operacao,
            usuario,
            descricao
        )
        VALUES (
            'tb_transacao',
            NEW.id_cartao,
            'BLOQUEIO',
            NEW.usuario_registro,
            'Bolso não encontrado para o cartão.'
        );

        RAISE EXCEPTION
            'Transação negada: bolso não encontrado.';
    END IF;

    IF v_saldo_atual < NEW.valor THEN

        INSERT INTO tb_auditoria_transacao (
            tabela_origem,
            id_registro,
            operacao,
            usuario,
            descricao
        )
        VALUES (
            'tb_transacao',
            NEW.id_cartao,
            'BLOQUEIO',
            NEW.usuario_registro,
            'Saldo insuficiente.'
        );

        RAISE EXCEPTION
            'Transação negada: saldo insuficiente.';
    END IF;

    UPDATE tb_saldo_bolso
    SET
        saldo_atual = saldo_atual - NEW.valor,
        ultima_atualizacao = CURRENT_TIMESTAMP
    WHERE id_cartao = NEW.id_cartao
      AND id_tipo_bolso = NEW.id_tipo_bolso;

    RETURN NEW;

END;
$$;

CREATE TRIGGER trg_validar_transacao
BEFORE INSERT
ON tb_transacao
FOR EACH ROW
EXECUTE FUNCTION fn_validar_transacao();