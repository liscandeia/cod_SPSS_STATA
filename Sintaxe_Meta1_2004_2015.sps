*Abrir o Banco no Stata
*Verificar se existem todas as var que vamos utilizar no banco.
*Criar a var idade_cne e idade_cnei (é a única que falta nesse banco)
*Código para criação no STATA:
*gen idade_cne=v0101-v3033 if v3032<=3
*replace idade_cne=v0101-v3033-1 if v3032>3 & v3032<=12 & *v3033!=v0101

*gen idade_cnei=v8005 if idade_cne==.
*replace idade_cnei=idade_cne if idade_cne<.
*label variable idade_cnei "idade_cne com imputação da *v8005"
*Salvar o banco no tipo: Stata 9/10 Data (*.dta) para conseguir abrir no SPSS.

*Abrir o banco no SPSS:
*Obs:O SPSS do INEP está desatualizado portanto não abre.

GET
 STATA FILE='C:\Users\Usuario\Desktop\testeStata.dta'.
DATASET NAME Conjunto_de_dados1 WINDOW=FRONT.
USE ALL.

*Salvar o db original no tipo sav:

SAVE OUTFILE='C:\Users\Usuario\Desktop\Meta1\Banco_Original_2004_2015_SPSS.sav'
 /COMPRESSED.


*Renomear as var para padronizar o db:

RENAME VARIABLES (v0101=Ano) (region=Região) (uf=UF) (v0302=Sexo) (v0404=Cor_Raça) (v4729=Peso) (urbano=Localização) .

*Tirar a frequencia para verificar a compatibilidade com o db antigo:

FREQUENCIES VARIABLES=Ano Região UF Sexo Cor_Raça Quintil idade_cnei estuda Peso Localização
 /ORDER=ANALYSIS.

*Agregar variaveis utilizadas na meta 1 por peso:

DATASET DECLARE Banco_var_2004_2015.
AGGREGATE
  /OUTFILE='Banco_var_2004_2015'
  /BREAK=Ano UF Região Localização idade_cnei Cor_Raça Sexo Quintil estuda
  /Peso_sum=SUM(Peso).

*Alterar o nome que recebeu a var Peso após agregar:

RENAME VARIABLES (Peso_sum=Peso). 

*Alterar todos os tipos das var para escalar:

ALTER TYPE Ano  (F4.0) .
VARIABLE LEVEL  Ano  (SCALE).
FORMATS Ano (F4.0) .
 
ALTER TYPE Região  (F1.0) .
VARIABLE LEVEL  Região  (SCALE).
FORMATS Região (F1.0) .
 
ALTER TYPE UF  (F2.0) .
VARIABLE LEVEL  UF  (SCALE).
FORMATS UF (F2.0) .
 
ALTER TYPE Sexo  (F1.0) .
VARIABLE LEVEL  Sexo  (SCALE).
FORMATS Sexo (F1.0) .
 
ALTER TYPE Cor_Raça  (F1.0) .
VARIABLE LEVEL  Cor_Raça  (SCALE).
FORMATS Cor_Raça (F1.0) .
 
ALTER TYPE Peso  (F12.3) .
VARIABLE LEVEL  Peso  (SCALE).
FORMATS Peso (F12.3) .
 
ALTER TYPE Localização  (F1.0) .
VARIABLE LEVEL  Localização (SCALE).
FORMATS Localização (F1.0) .
 
ALTER TYPE idade_cnei  (F1.0) .
VARIABLE LEVEL  idade_cnei (SCALE).
FORMATS idade_cnei (F1.0) .
 
ALTER TYPE estuda  (F1.0) .
VARIABLE LEVEL  estuda (SCALE).
FORMATS estuda (F1.0) .

ALTER TYPE Quintil  (F1.0) .
VARIABLE LEVEL  Quintil (SCALE).
FORMATS Quintil(F1.0) .

*Recodificar as var e declarar as labels para o padrão IBGE:

RECODE Sexo (2=1) (4=2) (ELSE=SYSMIS).
EXECUTE.
 
VALUE LABELS
 Sexo
 1 "Masculino"
 2 "Feminino"
 .
 
RECODE Cor_Raça (2=1) (4=2) (6=3) (8=4) (0=5) (9=9) (ELSE=SYSMIS).
EXECUTE.

VALUE LABELS
 Cor_Raça
 1 "Branca"
 2 "Preta"
 3 "Amarela"
 4 "Parda"
 5 "Indígena"
 9 "Ignorado"
 .
 
RECODE Quintil (1=1) (5=5) (ELSE=SYSMIS).
EXECUTE.
 
VARIABLE LABELS
 Quintil "Quintil de Renda".
  
VALUE LABELS
 Quintil
 1 "20% mais pobres"
 5 "20% mais ricos".
 
RECODE Localização (1=1) (0=2) (ELSE=SYSMIS).
EXECUTE.
  
VALUE LABELS
 Localização
 1 "Urbana"
 2 "Rural".
 
VALUE LABELS
 UF
 11 "Rondônia"
 12 "Acre"
 13 "Amazonas"
 14 "Roraima"
 15 "Pará"
 16 "Amapá"
 17 "Tocantins"
 21 "Maranhão"
 22 "Piauí"
 23 "Ceará"
 24 "Rio Grande do Norte"
 25 "Paraíba"
 26 "Pernambuco"
 27 "Alagoas"
 28 "Sergipe"
 29 "Bahia"
 31 "Minas Gerais"
 32 "Espírito Santo"
 33 "Rio de Janeiro"
 35 "São Paulo"
 41 "Paraná"
 42 "Santa Catarina"
 43 "Rio Grande do Sul"
 50 "Mato Grosso do Sul"
 51 "Mato Grosso"
 52 "Goiás"
 53 "Distrito Federal"
 .

RECODE Região (3=6) (4=7) (5=8).
EXECUTE.
RECODE Região (6=5) (7=3) (8=4).
EXECUTE.
VALUE LABELS
 Região
 1 "Norte"
 2 "Nordeste"
 3 "Sudeste"
 4 "Sul"
 5 "Centro_Oeste"
 .

*Criar os numeradores e denominadores utilizados para a meta 1(a e b)

IF  (idade_cnei = 4 or idade_cnei = 5) Numerador_1A=Peso*estuda.
EXECUTE.
IF  (idade_cnei >= 0 and idade_cnei <= 3) Numerador_1B=Peso*estuda.
EXECUTE.
IF  (idade_cnei = 4 or idade_cnei = 5) Denominador_1A=Peso.
EXECUTE.
 
IF  (idade_cnei >= 0 and idade_cnei <= 3) Denominador_1B=Peso.
EXECUTE.

*criar a var Brancos_Negros (importante para a meta)

RECODE Cor_Raça (1=1) (2=2) (4=2) INTO Brancos_Negros.
EXECUTE.

VALUE LABELS
 Brancos_Negros
 1 "Brancos"
 2 "Negros"
 .

*Criar var para códigos que vão auxiliar na criação do painel interativo.

RECODE Região UF Cor_Raça (ELSE=Copy) INTO Cod_Região Cod_UF Cod_Cor.

*Agregar os valores que iremos utilizar na meta em um novo db: 

EXECUTE.
DATASET DECLARE Meta_1_2004_2015.
AGGREGATE
 /OUTFILE='Meta_1_2004_2015'
 /BREAK=Ano Região UF Sexo Cor_Raça Quintil Localização Brancos_Negros Cod_Região Cod_UF Cod_Cor
 /Numerador_1A_sum=SUM(Numerador_1A)
 /Numerador_1B_sum=SUM(Numerador_1B)
 /Denominador_1A_sum=SUM(Denominador_1A)
 /Denominador_1B_sum=SUM(Denominador_1B).

*Alterar as novas var para escalar:

ALTER TYPE Brancos_Negros  (F4.0) .
VARIABLE LEVEL  Brancos_Negros  (SCALE).
FORMATS Brancos_Negros (F4.0) .
 
ALTER TYPE Cod_Região  (F1.0) .
VARIABLE LEVEL  Cod_Região  (SCALE).
FORMATS Cod_Região (F1.0) .
 
ALTER TYPE Cod_UF  (F2.0) .
VARIABLE LEVEL  Cod_UF  (SCALE).
FORMATS Cod_UF (F2.0) .

ALTER TYPE Cod_Cor  (F2.0) .
VARIABLE LEVEL  Cod_Cor  (SCALE).
FORMATS Cod_Cor (F2.0) .


*Salvar db no SPSS:

SAVE OUTFILE='C:\Users\Usuario\Desktop\Meta_1_Lis\2016\Meta1_2004_2015.sav'
  /COMPRESSED.

Salvar db em csv:

SAVE TRANSLATE OUTFILE='C:\Users\edna.pereira\Desktop\Meta1_Lis\2004_2015\Meta_1_2004_2015.csv'
  /TYPE=CSV
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=LABELS.
