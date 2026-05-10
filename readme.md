# Smart Benefits

Sistema de benefícios corporativos desenvolvido em PostgreSQL com foco em integridade transacional, separação de saldo por categoria de uso, auditoria completa e automação de processos de RH.

---

# Contexto do Projeto

O projeto simula um motor inteligente de benefícios corporativos inspirado em arquiteturas utilizadas por empresas do ecossistema financeiro e de benefícios, como soluções de vale alimentação, refeição e mobilidade.

No cenário proposto, cada colaborador possui um cartão corporativo com múltiplos “bolsos” de saldo segregados por finalidade:

* Alimentação
* Refeição
* Mobilidade
* Cultura

Cada estabelecimento possui um código MCC (*Merchant Category Code*), que identifica sua categoria comercial.

O sistema garante que:

* o saldo de um bolso não seja utilizado em categorias incorretas;
* transações inválidas sejam bloqueadas automaticamente;
* todas as operações sejam auditadas;
* o processo de carga mensal de benefícios seja automatizado.

---

# Objetivo da Solução

Construir uma arquitetura de banco de dados capaz de:

* controlar benefícios corporativos;
* validar regras de negócio diretamente no banco;
* garantir integridade transacional;
* automatizar processos de RH;
* registrar auditoria completa das operações;
* gerar informações gerenciais para análise de consumo.

---

# Principais Regras de Negócio

## Separação de Bolsos

Cada saldo pertence a um tipo específico de benefício:

| Tipo de Bolso | Finalidade  |
| ------------- | ----------- |
| FOOD          | Alimentação |
| MEAL          | Refeição    |
| MOBILITY      | Mobilidade  |
| CULTURE       | Cultura     |

---

## Validação por MCC

Os estabelecimentos possuem categorias MCC vinculadas a um tipo de bolso permitido.

Exemplo:

| MCC  | Categoria    | Bolso Permitido |
| ---- | ------------ | --------------- |
| 5411 | Supermercado | FOOD            |
| 5812 | Restaurante  | MEAL            |
| 4111 | Transporte   | MOBILITY        |
| 7832 | Cinema       | CULTURE         |

Durante uma transação, o sistema verifica automaticamente:

* se o MCC é compatível com o bolso utilizado;
* se existe saldo disponível;
* se o bolso pertence ao cartão informado.

Caso alguma validação falhe, a transação é bloqueada e registrada em auditoria.

---

# Estrutura do Projeto

```txt
SMART-BENEFITS/
├── migrations/
│   ├── V001__initial_database_schema.sql
│   ├── V002__create_audit_tables.sql
│   ├── V003__create_audit_functions_and_triggers.sql
│   ├── V004__transaction_authorization.sql
│   └── V005__monthly_credit_load_procedure.sql
│
├── seed/
│   ├── requirements.txt
│   └── seed.ipynb
│
└── .env
```

---

# Modelagem do Banco

O sistema foi modelado utilizando conceitos de normalização e integridade relacional.

Principais entidades:

* Grupo Empresarial
* Empresa
* Colaborador
* Cartão
* Tipo de Bolso
* Saldo do Bolso
* Categoria MCC
* Estabelecimento
* Transação
* Carga Mensal
* Auditoria

---

# Objetos de Banco Implementados

## Functions

Responsáveis pelas regras de negócio e validações automáticas.

### `fn_validar_transacao()`

Valida:

* compatibilidade entre MCC e bolso;
* existência do bolso;
* saldo disponível.

---

## Triggers

Executam validações e auditorias automaticamente.

### `trg_validar_transacao`

Intercepta transações antes da inserção e bloqueia operações inválidas.

### Triggers de Auditoria

Todas as tabelas principais possuem triggers de auditoria utilizando:

* `NEW`
* `OLD`
* `TG_OP`
* `CURRENT_USER`

---

## Procedure

### `prc_carga_mensal_beneficios`

Simula a rotina mensal do RH.

Responsabilidades:

* processar colaboradores ativos;
* creditar benefícios automaticamente;
* atualizar saldos;
* registrar histórico da carga mensal.

---

# Massa de Dados

O projeto utiliza geração automática de dados com:

* Python
* Faker
* PostgreSQL
* Psycopg2

A seed gera:

* grupos empresariais;
* empresas;
* colaboradores;
* cartões;
* estabelecimentos;
* saldos;
* transações;
* categorias MCC.

O ambiente possui centenas de registros para testes de performance e integridade.

---

# Tecnologias Utilizadas

* PostgreSQL
* PL/pgSQL
* Python
* Faker
* Psycopg2
* Jupyter Notebook

---

# Segurança e Integridade

O projeto implementa:

* integridade referencial com PK/FK;
* validação automática de regras;
* auditoria transacional;
* rastreabilidade completa;
* segregação de saldo por categoria;
* controle de operações inválidas.

---

# Fluxo do Sistema

```txt
Colaborador
    ↓
Cartão Corporativo
    ↓
Bolsos de Benefício
    ↓
Transação
    ↓
Validação MCC
    ↓
Aprovação ou Bloqueio
    ↓
Auditoria
```

---

# Objetivo Acadêmico

O projeto foi desenvolvido para a disciplina de Modelagem de Dados com foco em:

* modelagem relacional;
* regras de negócio em banco;
* automação com procedures;
* uso de triggers;
* auditoria;
* processamento transacional;
* arquitetura de dados.

---

# Integrantes

* Nome Davi Arakaki 
* Nome Felipe Jorge
* Nome Giulia Manara
* Nome João Maldonado
* Nome Luiza Cursino

---

# Professor

Marcelo Silva

---

# Turma

2º Ano D

---

# Grupo

2