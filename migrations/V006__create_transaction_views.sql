-- =========================================================
-- DROPAR VIEWS EXISTENTES (para recriar do zero)
-- =========================================================

DROP VIEW IF EXISTS vw_consumo_medio_empresa_categoria CASCADE;
DROP VIEW IF EXISTS vw_total_gasto_empresa CASCADE;
DROP VIEW IF EXISTS vw_transacoes_negadas CASCADE;
DROP VIEW IF EXISTS vw_saldo_atual_colaborador CASCADE;
DROP VIEW IF EXISTS vw_top_estabelecimentos CASCADE;
DROP VIEW IF EXISTS vw_resumo_carga_mensal CASCADE;

-- =========================================================
-- VIEW 1: Consumo médio por empresa e categoria de benefício
-- =========================================================

CREATE OR REPLACE VIEW vw_consumo_medio_empresa_categoria AS
    SELECT ep.nome AS empresa,
           tb.codigo AS categoria_bolso,
           COUNT(t.id_transacao) AS qtd_transacoes,
           SUM(t.valor) AS valor_total_gasto,
           ROUND(AVG(t.valor), 2) AS consumo_medio
    FROM tb_transacao t
    JOIN tb_estabelecimento e ON t.id_estabelecimento = e.id_estabelecimento
    JOIN tb_categoria_mcc mcc ON e.id_categoria_mcc = mcc.id_categoria_mcc
    JOIN tb_tipo_bolso tb ON mcc.id_tipo_bolso = tb.id_tipo_bolso
    JOIN tb_cartao ct ON t.id_cartao = ct.id_cartao
    JOIN tb_colaborador cl ON ct.id_colaborador = cl.id_colaborador
    JOIN tb_empresa ep ON cl.id_empresa = ep.id_empresa
    WHERE t.status = 'APROVADA'
    GROUP BY ep.nome, tb.codigo;

-- =========================================================
-- VIEW 2: Total gasto por empresa
-- =========================================================

CREATE OR REPLACE VIEW vw_total_gasto_empresa AS
    SELECT ep.nome AS empresa,
           SUM(t.valor) AS valor_total_gasto,
           COUNT(DISTINCT cl.id_colaborador) AS qtd_colaboradores,
           ROUND(SUM(t.valor) / NULLIF(COUNT(DISTINCT cl.id_colaborador), 0), 2) AS media_por_colaborador
    FROM tb_empresa ep
    JOIN tb_colaborador cl ON ep.id_empresa = cl.id_empresa
    JOIN tb_cartao ct ON cl.id_colaborador = ct.id_colaborador
    JOIN tb_transacao t ON ct.id_cartao = t.id_cartao
    WHERE t.status = 'APROVADA'
    GROUP BY ep.nome;

-- =========================================================
-- VIEW 3: Transações negadas (via tabela de auditoria)
-- =========================================================

CREATE OR REPLACE VIEW vw_transacoes_negadas AS
    SELECT 
        cl.nome AS colaborador,
        a.descricao AS motivo,
        a.data_hora,
        a.usuario AS usuario_origem
    FROM tb_auditoria_transacao a
    JOIN tb_cartao ct ON ct.id_cartao = a.id_registro
    JOIN tb_colaborador cl ON cl.id_colaborador = ct.id_colaborador
    WHERE a.operacao = 'BLOQUEADO'
    ORDER BY a.data_hora DESC;

-- =========================================================
-- VIEW 4: Saldo atual por colaborador e bolso
-- =========================================================

CREATE OR REPLACE VIEW vw_saldo_atual_colaborador AS
    SELECT cl.nome AS colaborador,
           cl.cpf,
           tb.codigo AS bolso,
           sb.saldo_atual AS saldo_disponivel,
           sb.ultima_atualizacao
    FROM tb_saldo_bolso sb
    JOIN tb_tipo_bolso tb ON sb.id_tipo_bolso = tb.id_tipo_bolso
    JOIN tb_cartao ct ON sb.id_cartao = ct.id_cartao
    JOIN tb_colaborador cl ON ct.id_colaborador = cl.id_colaborador
    ORDER BY cl.nome, tb.codigo;

-- =========================================================
-- VIEW 5: Top estabelecimentos por movimentação
-- =========================================================

CREATE OR REPLACE VIEW vw_top_estabelecimentos AS
    SELECT e.nome AS estabelecimento,
           e.cidade,
           e.uf,
           COUNT(t.id_transacao) AS qtd_transacoes,
           SUM(t.valor) AS valor_total_movimentado
    FROM tb_estabelecimento e
    JOIN tb_transacao t ON e.id_estabelecimento = t.id_estabelecimento
    WHERE t.status = 'APROVADA'
    GROUP BY e.id_estabelecimento, e.nome, e.cidade, e.uf
    ORDER BY valor_total_movimentado DESC
    LIMIT 20;

-- =========================================================
-- VIEW 6: Resumo das cargas mensais
-- =========================================================

CREATE OR REPLACE VIEW vw_resumo_carga_mensal AS
    SELECT cm.competencia,
           cm.data_execucao,
           COUNT(DISTINCT cmi.id_colaborador) AS quantidade_colaboradores,
           SUM(cmi.valor_creditado) AS total_distribuido,
           cm.status
    FROM tb_carga_mensal cm
    JOIN tb_carga_mensal_item cmi ON cm.id_carga_mensal = cmi.id_carga_mensal
    GROUP BY cm.id_carga_mensal, cm.competencia, cm.data_execucao, cm.status
    ORDER BY cm.competencia DESC;

-- =========================================================
-- VERIFICAR SE TODAS AS VIEWS FORAM CRIADAS
-- =========================================================

SELECT viewname 
FROM pg_views 
WHERE schemaname = 'public' 
  AND viewname LIKE 'vw_%'
ORDER BY viewname;