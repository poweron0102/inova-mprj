# Relatório: Análise de Anomalias em Despesas Públicas
**Desafio de Dados - INOVA MPRJ**

Este repositório contém os artefatos da entrega final do desafio de dados. O projeto consiste na modelagem, análise exploratória (SQL) e visualização de dados (Power BI) focados no fluxo da despesa pública, com o objetivo de identificar inconsistências e indícios de irregularidades.

---

## 📑 Índice de Navegação

1.  [Acesso aos Artefatos](#-acesso-aos-artefatos)
2.  [Resumo da Questão 1: Modelagem de Dados](#1-modelagem-de-dados-questão-1)
3.  [Resumo da Questão 2: Investigação de Anomalias](#2-investigação-de-anomalias-questão-2)
4.  [Resumo da Questão 3: Visualização de Dados](#3-visualização-de-dados-questão-3)
5.  [Conclusão](#-conclusão)

---

## 🚀 Acesso aos Artefatos

Siga as instruções abaixo para visualizar os entregáveis deste projeto:

* **Repositório Online:** [Acessar GitHub](https://github.com/poweron0102/inova-mprj/tree/main)
* **Modelo de Dados:** Disponível na pasta `Questao-1` (Diagramas e documentação).
* **Relatório SQL:** Scripts e log de execução disponíveis na pasta `Questao-2`.
* **Dashboard Interativo:**
    * O arquivo fonte **`INOVA.pbix`** está disponível na pasta `Questao-3`.
    * Para visualizar, é necessário ter o **Microsoft Power BI Desktop** instalado.
    * Uma versão em PDF estático (`INOVA.pdf`) também está disponível na mesma pasta para visualização rápida.

---

## 1. Modelagem de Dados (Questão 1)

Foi desenvolvido um modelo relacional robusto para mapear o fluxo da despesa pública, garantindo a integridade referencial desde a contratação até o pagamento final.

**Principais Decisões de Arquitetura:**
* **Fluxo Cronológico:** O modelo conecta as entidades `Contrato` -> `Empenho` -> `Liquidação` -> `Pagamento`.
* **Normalização:** Entidades e Fornecedores foram separados em tabelas de *lookup* para evitar redundância.
* **Integridade:** Uso estrito de chaves estrangeiras (FK) para impedir "pagamentos órfãos" ou registros sem lastro contratual.

🔗 **[Clique aqui para ver a documentação completa da Modelagem e o Diagrama ERD](./Questao-1/readme.md)**

---

## 2. Investigação de Anomalias (Questão 2)

Através de consultas SQL exploratórias, foram auditadas as regras de negócio da administração pública (Lei 4.320/64). A análise revelou inconsistências significativas no controle de tetos financeiros e cronologia.

**Quadro Resumo dos Achados:**

| Tipo de Verificação | Status | Ocorrências Identificadas |
| :--- | :--- | :--- |
| Pagamentos sem empenho | ✅ Íntegro | 0 |
| Divergência Valor NF vs Pagamento | ✅ Íntegro | 0 |
| **Pagamento > Valor Empenhado** | 🚨 **Crítico** | **225 casos** |
| **Pagamento > Valor Contrato** | 🚨 **Crítico** | **255 casos** |
| **Inversão Cronológica (Pagou antes de Empenhar)** | ⚠️ **Irregular** | **41 casos** |

A análise sugere possíveis falhas no registro de aditivos contratuais ou execução de despesa não autorizada.

🔗 **[Clique aqui para ver as queries SQL e a análise detalhada](./Questao-2/readme.md)**

---

## 3. Visualização de Dados (Questão 3)

Foi desenvolvido um painel gerencial no **Power BI** para tangibilizar o impacto financeiro das anomalias encontradas.

**Destaques do Dashboard:**
* **Impacto Financeiro:** Identificação de **R$ 4,11 Milhões** em pagamentos que excederam o valor original dos contratos.
* **Geolocalização:** Mapa de calor identificando os municípios com maior incidência de irregularidades.
* **Detalhamento:** Tabela analítica por Fornecedor, permitindo auditoria pontual das empresas com maiores divergências.

![Preview do Dashboard](./Questao-3/pg1.png)

🔗 **[Clique aqui para acessar os arquivos do Dashboard e galeria de imagens](./Questao-3/readme.md)**

---
