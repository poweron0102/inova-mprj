# Fluxo da Despesa Pública: Modelo de Dados

## 1. Os Atores Envolvidos

* **Quem compra (`entidade`):** Representa o órgão público (governo, prefeitura, autarquia) que está realizando a compra.
* **Quem vende (`fornecedor`):** É a empresa ou pessoa contratada para prestar o serviço ou vender o produto.

---

## 2. O Fluxo da Despesa

O modelo conecta as tabelas seguindo a ordem cronológica do gasto público:

###  Fase 1: Contratação (`contrato`)
Tudo começa com um contrato assinado entre a **entidade** e o **fornecedor**.
* Esta tabela guarda o objeto (o que está sendo comprado), o valor total e as datas de vigência.

### Fase 2: Empenho (`empenho`)
No setor público, antes de gastar, o governo precisa "reservar" o dinheiro do orçamento para garantir que poderá pagar. Isso se chama **Empenho**.
* A tabela `empenho` vincula essa reserva ao contrato original e define o credor (quem vai receber).

### Fase 3: Liquidação (`liquidacao_nota_fiscal` e `nfe`)
A liquidação é o momento em que o governo confere se o produto foi entregue ou o serviço prestado.
* **`nfe`**: Armazena os dados da Nota Fiscal Eletrônica emitida pelo fornecedor.
* **`liquidacao_nota_fiscal`**: Conecta essa nota fiscal ao empenho, atestando que aquele valor específico pode ser pago.

### Fase 4: Pagamento (`pagamento` e `nfe_pagamento`)
É a finalização do processo, onde o dinheiro é efetivamente transferido.
* **`pagamento`**: Registra a data do desembolso e o vínculo com o empenho.
* **`nfe_pagamento`**: Detalha a forma como a nota fiscal específica foi paga.

---

### Diagrama de Relacionamento
![q1png.png](Questao-1/q1png.png)

