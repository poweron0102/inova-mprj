import csv

total = 0.0

with open('Questao-3/contrato.csv', mode='r', encoding='utf-8') as ficheiro:
    leitor = csv.DictReader(ficheiro)
    
    for linha in leitor:
        total += float(linha['valor']) # 12,934,223.48

print(f"O valor total de contrato é: {total:.2f}")

total = 0.0

with open('Questao-3/pagamento.csv', mode='r', encoding='utf-8') as ficheiro:
    leitor = csv.DictReader(ficheiro)
    
    for linha in leitor:
        total += float(linha['valor']) # 12,869,913.06

print(f"O valor total de pagamento é: {total:.2f}")