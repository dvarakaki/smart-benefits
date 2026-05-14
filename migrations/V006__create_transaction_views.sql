-- View 1

CREATE OR REPLACE VIEW vw_consumo_medio_empresa_categoria AS
    SELECT ep.nome AS empresa,
           tb.codigo AS categoria_bolso,
           count(t.id_transacao) AS qtd_transacoes,
           sum(t.valor) AS valor_total_gasto,
           round(avg(t.valor), 2) AS consumo_medio
    FROM tb_transacao t
    JOIN tb_estabelecimento e ON t.id_estabelecimento = e.id_estabelecimento
    JOIN tb_categoria_mcc mcc ON e.id_categoria_mcc = mcc.id_categoria_mcc
    JOIN tb_tipo_bolso tb ON mcc.id_tipo_bolso = tb.id_tipo_bolso
    JOIN tb_cartao ct ON t.id_cartao = ct.id_cartao
    JOIN tb_colaborador cl ON ct.id_colaborador = cl.id_colaborador
    JOIN tb_empresa ep ON cl.id_empresa = ep.id_empresa
    WHERE t.status = 'aprovada'
    GROUP BY ep.nome, tb.codigo;

-- View 2

CREATE OR REPLACE VIEW vw_total_gasto_empresa AS
    SELECT ep.nome AS empresa,
           sum(t.valor) AS valor_total_gasto,
           count(DISTINCT cl.id_colaborador) AS qtd_colaboradores,
           round(sum(t.valor) / nullif(count(DISTINCT cl.id_colaborador), 0), 2) AS media_por_colaborador
    FROM tb_empresa ep
    JOIN tb_colaborador cl ON ep.id_empresa = cl.id_empresa
    JOIN tb_cartao ct ON cl.id_colaborador = ct.id_cartao
    JOIN tb_transacao t ON ct.id_cartao = t.id_cartao
    WHERE t.status = 'aprovada'
    GROUP BY ep.nome;

-- View 3

CREATE OR REPLACE VIEW vw_transacoes_negadas AS
    SELECT cl.nome AS colaborador,
           e.nome AS estabelecimento,
           t.motivo,
           t.valor,
           t.data_hora
    FROM tb_transacao t
    JOIN tb_cartao ct ON t.id_cartao = ct.id_cartao
    JOIN tb_colaborador cl ON ct.id_colaborador = cl.id_colaborador
    JOIN tb_estabelecimento e ON t.id_estabelecimento = e.id_estabelecimento
    WHERE t.status = 'negada';

-- View 4

CREATE OR REPLACE VIEW vw_saldo_atual_colaborador AS
    SELECT cl.nome AS colaborador,
           cl.cpf,
           tb.codigo AS bolso,
           sb.saldo_atual AS saldo_disponivel,
           sb.ultima_atualizacao
    FROM tb_saldo_bolso sb
    JOIN tb_tipo_bolso tb ON sb.id_tipo_bolso = tb.id_tipo_bolso
    JOIN tb_cartao ct ON sb.id_cartao = ct.id_cartao
    JOIN tb_colaborador cl ON ct.id_colaborador = cl.id_colaborador;

-- View 5

CREATE OR REPLACE VIEW vw_top_estabelecimentos AS
    SELECT e.nome AS estabelecimento,
           count(t.id_transacao) AS qtd_transacoes,
           sum(t.valor) AS valor_total_movimentado
    FROM tb_estabelecimento e
    JOIN tb_transacao t ON e.id_estabelecimento = t.id_estabelecimento
    WHERE t.status = 'aprovada'
    GROUP BY e.nome
    ORDER BY valor_total_movimentado DESC;

-- View 6
select * from tb_transacao;
CREATE OR REPLACE VIEW vw_resumo_carga_mensal AS
    SELECT cm.competencia,
           count(DISTINCT cmi.id_colaborador) AS quantidade_colaboradores_processados,
           sum(cmi.valor_creditado) AS total_distribuido,
           cm.status AS status_carga
    FROM tb_carga_mensal cm
    JOIN tb_carga_mensal_item cmi ON cm.id_carga_mensal = cmi.id_carga_mensal
    GROUP BY cm.id_carga_mensal, cm.competencia, cm.status
    ORDER BY cm.competencia DESC;