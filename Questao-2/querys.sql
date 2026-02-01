/*
  Pagamentos sem empenhos correspondentes  
  Não encontados
*/
SELECT
    p.id_pagamento,
    p.valor,
    p.id_empenho
FROM pagamento p
LEFT JOIN empenho e ON p.id_empenho = e.id_empenho
WHERE e.id_empenho IS NULL;


/*
  Divergência entre valor da Nota Fiscal e valor do Pagamento da NFe
  Não encontados
*/
SELECT
    n.chave_nfe,
    n.valor_total_nfe,
    SUM(np.valor_pagamento) AS total_alocado_pagamento
FROM nfe n
JOIN nfe_pagamento np ON n.chave_nfe = np.chave_nfe
GROUP BY n.chave_nfe, n.valor_total_nfe
HAVING SUM(np.valor_pagamento) > n.valor_total_nfe;



-- ------------------------
/*
  Pagamentos acima do valor empenhado
  255 encontrados
*/
SELECT
    e.id_empenho,
    e.valor AS valor_reservado,
    SUM(p.valor) AS total_pago_no_empenho
FROM empenho e
JOIN pagamento p ON e.id_empenho = p.id_empenho
GROUP BY e.id_empenho, e.valor
HAVING SUM(p.valor) > e.valor;


/*
  Contratos com pagamentos acima do valor total contratado
  255 encontrados
*/
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
-- ------------------------



/*
  Pagamento realizado antes da data do Empenho
  41 encontrados
*/
SELECT
    p.id_pagamento,
    p.datapagamentoempenho  AS data_pagamento,
    e.id_empenho,
    e.data_empenho
FROM pagamento p
JOIN empenho e ON p.id_empenho = e.id_empenho
WHERE p.datapagamentoempenho < e.data_empenho;