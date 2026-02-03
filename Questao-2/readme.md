# Relatório de Investigação de Anomalias e Análise Exploratória

**Contexto:** Análise da base de dados de despesa pública (Empenho, Liquidação, Pagamento e Contratos).
**Objetivo:** Identificar inconsistências, erros procedimentais ou indícios de fraude no fluxo da despesa.

---

## 1. Resumo dos Achados

Durante a análise exploratória, foram executadas 5 consultas de verificação de integridade e conformidade.
* **2 testes** não retornaram inconsistências (Dados íntegros).
* **3 testes** retornaram anomalias significativas que requerem auditoria detalhada.

| Verificação | Status | Ocorrências |
| :--- | :--- | :--- |
| Pagamentos sem empenhos (órfãos) | ✅ OK | 0 |
| Divergência Valor NF vs. Pagamento | ✅ OK | 0 |
| **Pagamento > Valor Empenhado** | 🚨 **Alerta** | **225** |
| **Pagamento > Valor Contrato** | 🚨 **Alerta** | **255** |
| **Pagamento antes do Empenho** | ⚠️ **Irregular** | **41** |

---

## 2. Detalhamento das Investigações

### 2.1. Pagamentos acima do valor empenhado
**Descrição:** Verifica se o total pago excede o valor reservado na Nota de Empenho.
**Análise:** O empenho é o teto máximo de gasto autorizado. Pagamentos excedentes indicam falha no controle orçamentário ou erro de registro.
**Resultado:** Foram encontradas **225** ocorrências.

```sql
SELECT
    e.id_empenho,
    e.valor AS valor_reservado,
    SUM(p.valor) AS total_pago_no_empenho
FROM empenho e
JOIN pagamento p ON e.id_empenho = p.id_empenho
GROUP BY e.id_empenho, e.valor
HAVING SUM(p.valor) > e.valor;

```

### 2.2. Contratos com pagamentos acima do valor total contratado

**Descrição:** Compara a soma de todos os pagamentos vinculados a um contrato com o valor facial do contrato.
**Análise:** Pagamentos que excedem o valor do contrato sugerem:

1. Falta de registro de aditivos contratuais (falha de transparência).
2. Pagamentos indevidos (superfaturamento).
**Resultado:** Foram encontradas **255** ocorrências.

```sql
SELECT
    c.id_contrato,
    c.objeto,
    c.valor AS valor_teto_contrato,
    SUM(p.valor) AS total_pago,
    (SUM(p.valor) - c.valor) AS excesso
FROM contrato c
JOIN empenho e ON c.id_contrato = e.id_contrato
JOIN pagamento p ON e.id_empenho = p.id_empenho
GROUP BY c.id_contrato, c.valor
HAVING SUM(p.valor) > c.valor;

```

### 2.3. Pagamento realizado antes da data do Empenho

**Descrição:** Verifica a cronologia da despesa pública.
**Análise:** Pela Lei 4.320/64, é vedada a realização de despesa sem prévio empenho. O pagamento (última etapa) jamais pode ter data anterior à reserva do recurso (primeira etapa). Isso caracteriza "despesa sem empenho" ou erro grave de data.
**Resultado:** Foram encontradas **41** ocorrências.

```sql
SELECT
    p.id_pagamento,
    p.datapagamentoemp  AS data_pagamento,
    e.id_empenho,
    e.data_empenho
FROM pagamento p
JOIN empenho e ON p.id_empenho = e.id_empenho
WHERE p.datapagamentoemp < e.data_empenho;

```

---

## 3. Testes de Integridade (Resultados Negativos)

As consultas abaixo foram executadas para validar a consistência referencial e matemática dos dados. **Nenhuma anomalia foi encontrada nestes pontos**, o que indica boa integridade referencial básica do banco.

### 3.1. Pagamentos sem empenhos correspondentes

*Verifica se existem pagamentos "órfãos" no sistema.*

```sql
SELECT
    p.id_pagamento,
    p.valor,
    p.id_empenho
FROM pagamento p
LEFT JOIN empenho e ON p.id_empenho = e.id_empenho
WHERE e.id_empenho IS NULL;

```

### 3.2. Divergência entre valor da Nota Fiscal e Pagamento

*Verifica se o valor pago atrelado a uma NFe é maior que o valor da própria nota.*

```sql
SELECT
    n.chave_nfe,
    n.valor_total_nfe,
    SUM(np.valor_pagamento) AS total_alocado_pagamento
FROM nfe n
JOIN nfe_pagamento np ON n.chave_nfe = np.chave_nfe
GROUP BY n.chave_nfe, n.valor_total_nfe
HAVING SUM(np.valor_pagamento) > n.valor_total_nfe;

```

---

## 4. Conclusão

A base de dados apresenta inconsistências graves no que tange ao **respeito aos tetos financeiros** (contratuais e orçamentários) e à **cronologia legal** da despesa.
