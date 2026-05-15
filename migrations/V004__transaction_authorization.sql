-- =========================================================
-- CORRIGIR FUNCTION DE VALIDAÇÃO (COM AUDITORIA)
-- =========================================================

CREATE OR REPLACE FUNCTION fn_validar_transacao()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_saldo_atual          NUMERIC(12,2);
    v_tipo_bolso_mcc       INTEGER;
    v_motivo               VARCHAR(255);
BEGIN
    -- 1. Verificar compatibilidade do MCC com o tipo de bolso
    SELECT id_tipo_bolso
    INTO v_tipo_bolso_mcc
    FROM tb_estabelecimento e
    INNER JOIN tb_categoria_mcc c
        ON c.id_categoria_mcc = e.id_categoria_mcc
    WHERE e.id_estabelecimento = NEW.id_estabelecimento;

    IF v_tipo_bolso_mcc <> NEW.id_tipo_bolso THEN
        v_motivo := 'Categoria MCC incompatível com o tipo de bolso.';
        
        -- Registrar na auditoria ANTES do exception
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
            'BLOQUEADO',
            NEW.usuario_registro,
            v_motivo
        );
        
        RAISE EXCEPTION 'Transação negada: %', v_motivo;
    END IF;
    
    -- 2. Verificar saldo disponível
    SELECT saldo_atual
    INTO v_saldo_atual
    FROM tb_saldo_bolso
    WHERE id_cartao = NEW.id_cartao
      AND id_tipo_bolso = NEW.id_tipo_bolso;

    IF v_saldo_atual IS NULL THEN
        v_motivo := 'Bolso não encontrado para o cartão.';
        
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
            'BLOQUEADO',
            NEW.usuario_registro,
            v_motivo
        );
        
        RAISE EXCEPTION 'Transação negada: %', v_motivo;
    END IF;

    IF v_saldo_atual < NEW.valor THEN
        v_motivo := 'Saldo insuficiente.';
        
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
            'BLOQUEADO',
            NEW.usuario_registro,
            v_motivo
        );
        
        RAISE EXCEPTION 'Transação negada: %', v_motivo;
    END IF;

    -- 3. Se passou por todas as validações, debitar o saldo
    UPDATE tb_saldo_bolso
    SET
        saldo_atual = saldo_atual - NEW.valor,
        ultima_atualizacao = CURRENT_TIMESTAMP
    WHERE id_cartao = NEW.id_cartao
      AND id_tipo_bolso = NEW.id_tipo_bolso;

    -- Registrar transação aprovada na auditoria (opcional)
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
        'APROVADA',
        NEW.usuario_registro,
        'Transação autorizada com sucesso.'
    );

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        -- Garantir que qualquer erro não esperado também seja registrado
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
            'ERRO',
            NEW.usuario_registro,
            'Erro inesperado: ' || SQLERRM
        );
        RAISE;
END;
$$;