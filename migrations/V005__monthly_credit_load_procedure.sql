-- =========================================================
-- PROCEDURE: CARGA MENSAL DE BENEFÍCIOS
-- =========================================================

CREATE OR REPLACE PROCEDURE prc_carga_mensal_beneficios(
    p_competencia       VARCHAR(7),
    p_usuario_execucao  VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_carga_mensal      INTEGER;

    v_valor_food           NUMERIC(12,2) := 800.00;
    v_valor_meal           NUMERIC(12,2) := 600.00;
    v_valor_mobility       NUMERIC(12,2) := 300.00;
    v_valor_culture        NUMERIC(12,2) := 150.00;

    v_colaborador          RECORD;
    v_cartao               INTEGER;
BEGIN

    -- =====================================================
    -- INICIA REGISTRO DA CARGA MENSAL
    -- =====================================================

    INSERT INTO tb_carga_mensal (
        competencia,
        usuario_execucao,
        status
    )
    VALUES (
        p_competencia,
        p_usuario_execucao,
        'PROCESSANDO'
    )
    RETURNING id_carga_mensal
    INTO v_id_carga_mensal;

    -- =====================================================
    -- PROCESSA TODOS OS COLABORADORES ATIVOS
    -- =====================================================

    FOR v_colaborador IN
        SELECT
            c.id_colaborador,
            ct.id_cartao
        FROM tb_colaborador c
        INNER JOIN tb_cartao ct
            ON ct.id_colaborador = c.id_colaborador
        WHERE c.status = 'ATIVO'
          AND ct.status = 'ATIVO'
    LOOP

        v_cartao := v_colaborador.id_cartao;

        -- ================================================
        -- FOOD
        -- ================================================

        UPDATE tb_saldo_bolso
        SET
            saldo_atual = saldo_atual + v_valor_food,
            ultima_atualizacao = CURRENT_TIMESTAMP
        WHERE id_cartao = v_cartao
          AND id_tipo_bolso = 1;

        INSERT INTO tb_carga_mensal_item (
            id_carga_mensal,
            id_colaborador,
            id_tipo_bolso,
            valor_creditado
        )
        VALUES (
            v_id_carga_mensal,
            v_colaborador.id_colaborador,
            1,
            v_valor_food
        );

        -- ================================================
        -- MEAL
        -- ================================================

        UPDATE tb_saldo_bolso
        SET
            saldo_atual = saldo_atual + v_valor_meal,
            ultima_atualizacao = CURRENT_TIMESTAMP
        WHERE id_cartao = v_cartao
          AND id_tipo_bolso = 2;

        INSERT INTO tb_carga_mensal_item (
            id_carga_mensal,
            id_colaborador,
            id_tipo_bolso,
            valor_creditado
        )
        VALUES (
            v_id_carga_mensal,
            v_colaborador.id_colaborador,
            2,
            v_valor_meal
        );

        -- ================================================
        -- MOBILITY
        -- ================================================

        UPDATE tb_saldo_bolso
        SET
            saldo_atual = saldo_atual + v_valor_mobility,
            ultima_atualizacao = CURRENT_TIMESTAMP
        WHERE id_cartao = v_cartao
          AND id_tipo_bolso = 3;

        INSERT INTO tb_carga_mensal_item (
            id_carga_mensal,
            id_colaborador,
            id_tipo_bolso,
            valor_creditado
        )
        VALUES (
            v_id_carga_mensal,
            v_colaborador.id_colaborador,
            3,
            v_valor_mobility
        );

        -- ================================================
        -- CULTURE
        -- ================================================

        UPDATE tb_saldo_bolso
        SET
            saldo_atual = saldo_atual + v_valor_culture,
            ultima_atualizacao = CURRENT_TIMESTAMP
        WHERE id_cartao = v_cartao
          AND id_tipo_bolso = 4;

        INSERT INTO tb_carga_mensal_item (
            id_carga_mensal,
            id_colaborador,
            id_tipo_bolso,
            valor_creditado
        )
        VALUES (
            v_id_carga_mensal,
            v_colaborador.id_colaborador,
            4,
            v_valor_culture
        );

    END LOOP;

    -- =====================================================
    -- FINALIZA CARGA
    -- =====================================================

    UPDATE tb_carga_mensal
    SET status = 'CONCLUIDA'
    WHERE id_carga_mensal = v_id_carga_mensal;

END;
$$;