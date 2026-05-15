# 🚀 Smart Benefits

> **Motor de Benefícios Inteligente** - Sistema corporativo de gestão de benefícios desenvolvido em PostgreSQL com foco em integridade transacional, segregação de saldos por categoria, auditoria completa e automação de processos de RH.

---

## 📋 Índice

| Seção | Descrição |
|-------|-----------|
| [Contexto do Projeto](#-contexto-do-projeto) | Entenda o problema e o cenário |
| [Objetivo da Solução](#-objetivo-da-solução) | O que o sistema entrega |
| [Regras de Negócio](#-regras-de-negócio) | Validações e controles |
| [Arquitetura do Projeto](#-arquitetura-do-projeto) | Estrutura de arquivos |
| [Modelagem do Banco](#-modelagem-do-banco) | Entidades e relacionamentos |
| [Objetos Implementados](#-objetos-implementados) | Functions, Triggers, Procedures, Views |
| [Massa de Dados](#-massa-de-dados) | Volume e geração de dados |
| [Tecnologias](#-tecnologias) | Stack utilizada |
| [Fluxo do Sistema](#-fluxo-do-sistema) | Como os dados fluem |
| [Segurança e Integridade](#-segurança-e-integridade) | Camadas de proteção |
| [Equipe](#-equipe) | Responsabilidades |
| [Professor e Turma](#-professor-e-turma) | Informações acadêmicas |

---

## 🎯 Contexto do Projeto

O **Smart Benefits** simula um motor inteligente de benefícios corporativos inspirado em arquiteturas utilizadas por empresas do ecossistema financeiro e de benefícios, como soluções de vale alimentação, refeição, mobilidade e cultura.

### Cenário Proposto

Cada colaborador possui um **cartão corporativo** com múltiplos **"bolsos"** de saldo segregados por finalidade:

| Tipo de Bolso | Finalidade | Emoji |
|---------------|------------|-------|
| **FOOD** | Vale Alimentação | 🥗 |
| **MEAL** | Vale Refeição | 🍽️ |
| **MOBILITY** | Vale Mobilidade | 🚗 |
| **CULTURE** | Vale Cultura | 🎭 |

### O Problema

Estabelecimentos possuem códigos **MCC** (*Merchant Category Code*) que identificam sua categoria comercial. O desafio é garantir que:

- ✅ O saldo de um bolso **não seja utilizado** em categorias incorretas
- 🚫 Transações inválidas sejam **bloqueadas automaticamente**
- 📝 Todas as operações sejam **auditadas**
- 🤖 O processo de **carga mensal de benefícios** seja automatizado

---

## 🎯 Objetivo da Solução

Construir uma **arquitetura de banco de dados** capaz de:

| Requisito | Descrição |
|-----------|-----------|
| 🎛️ **Controle** | Gerenciar benefícios corporativos |
| ✅ **Validação** | Aplicar regras de negócio diretamente no banco |
| 🔒 **Integridade** | Garantir consistência transacional |
| ⚙️ **Automação** | Automatizar processos de RH |
| 📋 **Auditoria** | Registrar todas as operações |
| 📊 **BI** | Gerar informações gerenciais para análise de consumo |

---

## 📐 Regras de Negócio

### 1. Separação de Bolsos

Cada saldo pertence exclusivamente a um tipo de benefício. Não é permitido utilizar saldo de uma categoria em estabelecimentos de outra.

### 2. Validação por MCC

Os estabelecimentos possuem categorias MCC vinculadas a um **único tipo de bolso permitido**.

#### Exemplo de mapeamento:

| MCC | Categoria | Bolso Permitido |
|-----|-----------|-----------------|
| 5411 | Supermercado | FOOD 🥗 |
| 5812 | Restaurante | MEAL 🍽️ |
| 4111 | Transporte | MOBILITY 🚗 |
| 7832 | Cinema | CULTURE 🎭 |
| 5814 | Fast Food | MEAL 🍽️ |
| 4121 | Táxi | MOBILITY 🚗 |
| 7922 | Teatro | CULTURE 🎭 |

### 3. Validação de Transação

Durante uma transação, o sistema verifica automaticamente:

```sql
-- Pseudocódigo da validação
IF MCC_compatível_com_bolso() 
   AND saldo_suficiente() 
   AND bolso_existe() THEN
    APROVAR_transacao()
    DEBITAR_saldo()
ELSE
    BLOQUEAR_transacao()
    REGISTRAR_auditoria()
END IF
```

---

## 📁 Arquitetura do Projeto

```
SMART-BENEFITS/
├── migrations/
│   ├── V001__initial_database_schema.sql
│   ├── V002__create_audit_tables.sql
│   ├── V003__create_audit_functions_and_triggers.sql
│   ├── V004__transaction_authorization.sql
│   ├── V005__monthly_credit_load_procedure.sql
│   └── V006__create_transaction_views.sql
│
├── seed/
│   ├── requirements.txt
│   └── seed.ipynb
│
├── .env
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🗄️ Modelagem do Banco

O sistema foi modelado utilizando **normalização** (3ª Forma Normal) e **integridade relacional**.

### Entidades Principais

| Entidade | Descrição | Quantidade |
|----------|-----------|------------|
| `tb_grupo_empresarial` | Grupos do ecossistema J&F | 8 |
| `tb_empresa` | Empresas vinculadas aos grupos | 40+ |
| `tb_colaborador` | Colaboradores com seus cargos | 200 |
| `tb_cartao` | Cartões corporativos | 200 |
| `tb_tipo_bolso` | Tipos de benefícios | 4 |
| `tb_saldo_bolso` | Saldos segregados por bolso | 800 |
| `tb_categoria_mcc` | Categorias de estabelecimentos | 22+ |
| `tb_estabelecimento` | Estabelecimentos credenciados | 80+ |
| `tb_transacao` | Histórico de transações | 500+ |
| `tb_carga_mensal` | Controle de cargas mensais | 3 |
| `tb_carga_mensal_item` | Itens das cargas mensais | 2.400+ |
| `tb_auditoria_transacao` | Logs de auditoria | Variável |

### Diagrama ERD

```
┌─────────────────────┐     ┌─────────────────────┐
│ tb_grupo_empresarial│     │    tb_empresa       │
├─────────────────────┤     ├─────────────────────┤
│ id_grupo (PK)       │────<│ id_grupo (FK)       │
│ nome                │     │ id_empresa (PK)     │
│ cnpj_raiz           │     │ nome                │
└─────────────────────┘     └──────────┬──────────┘
                                       │
┌─────────────────────┐     ┌──────────▼──────────┐
│    tb_cartao        │     │  tb_colaborador     │
├─────────────────────┤     ├─────────────────────┤
│ id_cartao (PK)      │     │ id_colaborador (PK) │
│ id_colaborador (FK) │<────│ id_empresa (FK)     │
│ numero_tokenizado   │     │ nome, cpf, matricula│
└──────────┬──────────┘     └─────────────────────┘
           │
┌──────────▼──────────┐     ┌─────────────────────┐
│   tb_saldo_bolso    │     │   tb_tipo_bolso     │
├─────────────────────┤     ├─────────────────────┤
│ id_saldo_bolso (PK) │     │ id_tipo_bolso (PK)  │
│ id_cartao (FK)      │────<│ codigo, descricao   │
│ id_tipo_bolso (FK)  │────>│                     │
│ saldo_atual         │     └─────────────────────┘
└─────────────────────┘

┌─────────────────────┐     ┌─────────────────────┐
│ tb_categoria_mcc    │     │ tb_estabelecimento  │
├─────────────────────┤     ├─────────────────────┤
│ id_categoria_mcc(PK)│     │ id_estabelecimento  │
│ mcc, descricao      │     │ id_categoria_mcc(FK)│
│ id_tipo_bolso (FK)  │────<│ nome, cidade, uf    │
└─────────────────────┘     └──────────┬──────────┘
                                       │
┌─────────────────────┐     ┌──────────▼──────────┐
│   tb_transacao      │     │ tb_auditoria_transacao
├─────────────────────┤     ├─────────────────────┤
│ id_transacao (PK)   │     │ id_auditoria (PK)   │
│ id_cartao (FK)      │     │ operacao, descricao │
│ id_estabelecimento  │     │ data_hora, usuario  │
│ valor, status       │     └─────────────────────┘
└─────────────────────┘
```

---

## 🔧 Objetos Implementados

### 📌 Functions

| Função | Responsabilidade |
|--------|------------------|
| `fn_validar_transacao()` | Valida compatibilidade MCC, existência do bolso e saldo disponível |
| `fn_log_*` (12 funções) | Auditoria de todas as tabelas com NEW/OLD/TG_OP |

### 📌 Triggers

| Trigger | Evento | Tabela | Ação |
|---------|--------|--------|------|
| `trg_validar_transacao` | BEFORE INSERT | `tb_transacao` | Bloqueia transações inválidas |
| `trg_log_*` (12 triggers) | AFTER INSERT/UPDATE/DELETE | Todas as tabelas | Registra auditoria |

### 📌 Procedure

| Procedure | Descrição |
|-----------|-----------|
| `prc_carga_mensal_beneficios` | Processa colaboradores ativos, credita benefícios automaticamente e registra histórico |

### 📌 Views Gerenciais

| View | Finalidade |
|------|------------|
| `vw_consumo_medio_empresa_categoria` | Consumo médio por empresa e categoria |
| `vw_total_gasto_empresa` | Total gasto e média por colaborador |
| `vw_transacoes_negadas` | Transações bloqueadas via auditoria |
| `vw_saldo_atual_colaborador` | Saldo disponível por colaborador |
| `vw_top_estabelecimentos` | Ranking dos estabelecimentos mais usados |
| `vw_resumo_carga_mensal` | Resumo das cargas de benefícios |

---

## 📊 Massa de Dados

O projeto utiliza **geração automática de dados** com:

- 🐍 **Python** + **Faker** para dados fictícios realistas
- 🐘 **PostgreSQL** + **Psycopg2** para persistência
- 📓 **Jupyter Notebook** para execução controlada

### Quantitativos Gerados

| Item | Quantidade |
|------|------------|
| Grupos Empresariais (J&F) | 8 |
| Empresas | 40+ |
| Colaboradores | 200 |
| Cartões | 200 |
| Saldos (4 por cartão) | 800 |
| Categorias MCC | 22 |
| Estabelecimentos | 80+ |
| Transações Aprovadas | 500+ |
| Transações Bloqueadas | Testadas via trigger |

---

## 🛠️ Tecnologias

| Categoria | Tecnologia |
|-----------|------------|
| **Banco de Dados** | PostgreSQL 15+ |
| **Linguagem de Banco** | PL/pgSQL |
| **Linguagem de Script** | Python 3.10+ |
| **Bibliotecas Python** | Faker, Psycopg2, python-dotenv |
| **Ambiente** | Jupyter Notebook |
| **Versionamento** | Git + GitHub |

---

## 🔄 Fluxo do Sistema

```
Colaborador
     │
     ▼
Cartão Corporativo
     │
     ▼
Bolsos (FOOD, MEAL, MOBILITY, CULTURE) ◄─── Carga Mensal (Procedure)
     │
     ▼
Transação
     │
     ▼
Validação (Function)
     │
     ├──► Aprovada → Debita Saldo → Sucesso
     │
     └──► Bloqueada → Auditoria → Registra Log
```

---

## 🔒 Segurança e Integridade

O projeto implementa múltiplas camadas de proteção:

| Camada | Mecanismo |
|--------|-----------|
| **Integridade Referencial** | PK/FK constraints |
| **Validação de Regras** | Function com validações antes do INSERT |
| **Bloqueio Automático** | Trigger com RETURN NULL |
| **Auditoria Transacional** | Tabelas de log com NEW/OLD/TG_OP |
| **Rastreabilidade** | CURRENT_USER capturado em todas as operações |
| **Segregação de Saldo** | Validação por MCC e tipo de bolso |

### Exemplo de Auditoria

```sql
-- Registro gerado ao tentar usar benefício FOOD em restaurante
INSERT INTO tb_auditoria_transacao VALUES (
    tabela_origem = 'tb_transacao',
    operacao = 'BLOQUEADO',
    descricao = 'Categoria MCC incompatível com o tipo de bolso',
    usuario = 'teste_auditoria',
    data_hora = NOW()
);
```

---

## 👥 Equipe

| Nome | Responsabilidades |
|------|-------------------|
| **Davi Arakaki** | Functions , Integração Python, Triggers |
| **Felipe Jorge** | Modelagem do Banco, Documentação |
| **Giulia Manara** | Modelagem do Banco, Slides, README |
| **João Maldonado** | Modelagem do Banco, Views, Testes |
| **Luiza Cursino** | Script SQL, Triggers, Validação MCC |

---

## 👨‍🏫 Professor e Turma

| Campo | Informação |
|-------|------------|
| **Disciplina** | Modelagem de Dados |
| **Professor** | Marcelo Silva |
| **Turma** | 2º Ano D |
| **Grupo** | 02 |

---

## 📌 Status do Projeto

| Módulo | Status |
|--------|--------|
| ✅ Modelagem do Banco | Concluído |
| ✅ Migrations (V001-V006) | Concluído |
| ✅ Triggers de Auditoria | Concluído |
| ✅ Function de Validação | Concluído |
| ✅ Procedure de Carga Mensal | Concluído |
| ✅ Views Gerenciais | Concluído |
| ✅ Seed de Dados (500+ registros) | Concluído |
| ✅ Testes de Transações Negadas | Concluído |
| ✅ Documentação | Concluído |

---

## 🎯 Conclusão

O **Smart Benefits** demonstra como é possível construir uma **solução robusta de benefícios corporativos** diretamente no banco de dados, utilizando recursos avançados do PostgreSQL como:

- Functions e Procedures para regras de negócio
- Triggers para validação e auditoria
- Views para inteligência de negócio
- Constraints para integridade referencial

A arquitetura é **escalável**, **auditável** e **segura**, atendendo todos os requisitos solicitados pelo professor e preparada para uma eventual migração para nuvem.

---

