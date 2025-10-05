# Projeto: Previsão de Risco de Déficit Energético em Goiás  
**Módulo 2: Machine Learning para Políticas Públicas**

---

## 📌 Visão Geral
Este projeto tem como objetivo desenvolver um modelo de *machine learning* para classificar o **risco diário de déficit de energia elétrica** no estado de Goiás.  

O modelo final deverá categorizar cada dia em um dos três níveis de risco: **baixo, médio ou alto**, servindo como uma ferramenta de apoio à decisão para a operação do sistema elétrico.

---

## 📊 Status Atual (05/10/2025)
Concluímos com sucesso a fase de fundação e a primeira etapa de construção de *features*.  
A tabela de dados para modelagem está sendo construída incrementalmente.

### ✔ Estrutura do Projeto e Ambiente
- Repositório Git configurado com um `.gitignore` robusto  
- Ambiente virtual (`venv`) e dependências gerenciadas via `requirements.txt`  

### ✔ Definição da Variável Alvo (Notebook 01)
- Utilizamos o dataset de **Interrupção de Carga** como fonte de verdade para os déficits  
- Agregamos os eventos por dia para calcular a **Energia Não Suprida (ENS)** diária em Goiás  
- Criamos a variável-alvo `nivel_risco` (*'baixo'*, *'medio'*, *'alto'*) com base em quantis da distribuição dos eventos mais severos  
- Resultado salvo em:  

```
data/processed/target_variable_daily.parquet
```


### ✔ Feature Engineering: Demanda/Carga (Notebook 02)
- Script de extração: `scripts/extract_carga_api.py` (dados da API do ONS)  
- Processamento dos dados de **carga verificada** e **programada**  
- Criação de features:
- `carga_total_diaria`
- `diferenca_verif_prog`  
- Resultado salvo em:  

```
data/processed/feature_table_v1.parquet
```


### ✔ Feature Engineering: Oferta/Geração (Notebook 03)
- Processamento dos datasets de **Geração por Usina** e **Fator de Capacidade**  
- Criação de features:
- `geracao_total_diaria_go`
- Geração por tipo de usina
- `fator_cap_solar_medio_seco`  
- Insights iniciais mostram que a relação risco ↔ geração é complexa, indicando importância das restrições de rede  
- Resultado salvo em:  

```
data/processed/feature_table_v2.parquet
```


---

## 🚀 Próximos Passos

### 📍 Tarefa Imediata: Notebook 04 - Análise da Rede e Transmissão
- **Objetivo**: Criar e executar o notebook `04-EDA-Rede.ipynb`  

#### Preparação
- Baixar os seguintes datasets do Portal de Dados Abertos do ONS e salvar em `/data`:
- Restrição de Operação por Constrained-off de Usinas Fotovoltaicas / Eólicas  
- Intercâmbios Entre Subsistemas  

#### Processamento e Features
- **Restrição de Operação**:  
- Filtrar para Goiás  
- Agregar por dia → criar `total_mwh_restrito_go`  
- Valores altos = gargalos na rede  

- **Intercâmbios Entre Subsistemas**:  
- Filtrar subsistema Sudeste/Centro-Oeste (SE/CO)  
- Criar `saldo_intercambio_seco`  
- Valores negativos = alta importação → subsistema não autossuficiente  

#### Integração
- Merge das novas features na tabela principal  
- Criação de visualizações (boxplots) para analisar relação entre restrições de rede e níveis de risco  
- Resultado salvo em:  


```
data/processed/feature_table_v3.parquet
```


---

## 🔮 Olhando para o Futuro
Após a conclusão do **Notebook 04**, o último passo da engenharia de features será o **Notebook 05**, focado em **Análise Hídrica** (usando os datasets de **EAR** e **ENA**), fornecendo contexto de segurança de longo prazo do sistema.

---

## 🛠 Como Começar
Para continuar o trabalho:

```bash
# Clone o repositório
git clone [URL_DO_REPOSITORIO]

# Crie e ative o ambiente virtual
python -m venv venv
source venv/bin/activate   # Mac/Linux
.\venv\Scripts\activate    # Windows

# Instale as dependências
pip install -r requirements.txt
```
Certifique-se de que os dados brutos necessários estão na pasta /data

Abra o Jupyter Lab:

```
jupyter lab
```

Comece a trabalhar no 04-EDA-Rede.ipynb

👨‍💻 Bom trabalho, equipe!
