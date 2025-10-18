# 🔋 Previsão de Risco de Déficit Energético em Goiás
**Machine Learning para Políticas Públicas**

---

## 📌 Visão Geral

Este projeto tem como objetivo desenvolver um modelo de machine learning para classificar o risco diário de déficit de energia elétrica em Goiás. O modelo deve categorizar cada dia em três níveis de risco (**baixo**, **médio** ou **alto**), servindo como uma ferramenta de apoio à decisão para a segurança do suprimento energético.

Este repositório contém duas abordagens para este desafio:

1. Um processo de **análise exploratória e modelagem local** usando notebooks Jupyter.

2.  Um **pipeline de dados de produção em nuvem (ELT)** usando Snowflake, dbt, Airflow e Airbyte, projetado para automatizar a engenharia de features e entregar a tabela de modelagem final para o treinamento de modelos na AWS.
---

## 🚀 Abordagem 1: Análise Exploratória e Modelagem Local (Notebooks)

Esta abordagem descreve o fluxo de trabalho de pesquisa e desenvolvimento, executado localmente para explorar os dados e validar a viabilidade do modelo.

1. **Configuração do Ambiente**

Clone o repositório e configure o ambiente virtual:

```bash
# Clone o repositório
git clone [URL_DO_REPOSITORIO]
cd ons-risk-prediction

# Crie e ative o ambiente virtual
python -m venv venv
source venv/bin/activate   # Mac/Linux
.\venv\Scripts\activate    # Windows

# Instale as dependências
pip install -r requirements.txt
```

2. **Definição do Período de Análise**

Edite o arquivo ```config.py``` na raiz do projeto para definir o intervalo de tempo desejado para a análise. O arquivo de configuração agora permite uma execução dinâmica.

- ```START_YEAR``` e ```START_MONTH``` definem o início do período de coleta (ex: 2010, 1).

- ```USE_CURRENT_DATE = True``` fará com que o pipeline colete dados até o mês e ano atuais.

- ```USE_CURRENT_DATE = False``` usará os valores manuais END_YEAR e END_MONTH para definir um período fixo.

```python
# Exemplo em config.py
from datetime import datetime

# --- Período de Análise ---
START_YEAR = 2010
START_MONTH = 1

# --- Controle Automático ---
USE_CURRENT_DATE = True

# Datas finais
if USE_CURRENT_DATE:
    today = datetime.today()
    END_YEAR = today.year
    END_MONTH = today.month
else:
    END_YEAR = 2025
    END_MONTH = 10
```

3. **Coleta Automatizada de Dados**

Execute os scripts na pasta ```/scripts``` para baixar todos os dados brutos necessários para a pasta ```data/raw/```. Eles lerão a configuração do ```config.py```.

```bash
# Baixa os arquivos CSV do S3 da ONS (Geração, Rede, Hídricos, etc.)
python scripts/download_data.py

# Extrai os dados de Carga (Programada e Verificada) da API da ONS
python scripts/extract_carga_api.py

# Baixa os dados meteorológicos da API NASA POWER
python scripts/download_weather_data.py
```

4. **Engenharia de Features e Modelagem**

Execute os notebooks Jupyter em sequência, do 01 ao final. Cada notebook realiza uma etapa do processamento e salva seu resultado, que é usado pelo notebook seguinte:

```01-EDA-Variavel-Alvo-Interrupcao.ipynb```
```02-EDA-Carga-Energia.ipynb```
```03-EDA-Geracao.ipynb```
```04-EDA-Rede.ipynb```
```05-EDA-Hidrica.ipynb```
```06-Feature-Engineering-Avancada.ipynb```
```07-Features-Adicionais.ipynb```
```08-Features-Meteorologicas.ipynb```
```09-Modelagem-XGBoost.ipynb```
```10-Modelagem-LTSM.ipynb```
```11-Modelagem-Unbalanced-Learning.ipynb```
```12-Ensemble.ipynb```

---

## ☁️ Abordagem 2: Pipeline de Produção em Nuvem (Snowflake + dbt + Airflow)

Esta abordagem transforma a lógica exploratória dos notebooks em um pipeline de dados ELT (Extract, Load, Transform) robusto, automatizado e escalável, pronto para um ambiente de produção.

- **Ferramentas Utilizadas**:

- **Snowflake**: Data Warehouse em nuvem, onde os dados serão armazenados e transformados.

- **dbt (Data Build Tool)**: Ferramenta para gerenciar as transformações SQL (a lógica dos notebooks).

- **Airflow**: Orquestrador para agendar e executar o pipeline automaticamente.

- **Airbyte**: Ferramenta de ingestão de dados (para os dados dinâmicos, em um próximo passo).

**Ingestão da Camada RAW**

Os passos a seguir descrevem como configurar o Data Warehouse no Snowflake e executar a **carga inicial (snapshot)** de todos os dados brutos. Esta é a fundação necessária antes de construir as transformações com dbt.

**Passo 1: Gerar Arquivos de Snapshot (Local)**

Antes de popular o Snowflake, precisamos ter todos os arquivos brutos disponíveis localmente.

1. **Definir Período no** ```config.py```: Certifique-se de que o config.py está configurado para o período desejado (ex: ```USE_CURRENT_DATE = True``` para pegar tudo até hoje).

2. **Baixar Dados Históricos**: Execute python scripts/download_data.py.

3. **Gerar Dados das APIs**: Execute python ```scripts/extract_carga_api.py``` e ```python scripts/download_weather_data.py```.

Ao final, sua pasta ```data/raw/``` deve conter todos os arquivos CSV e Parquet necessários.

**Passo 2: Configurar o Ambiente no Snowflake**

No Snowflake, execute o script ```snowflake_scripts_ons/01_setup.sql```.

- O que faz:

    - ```CREATE DATABASE```: Cria os bancos ```RAW_DB```, ```STAGING_DB``` e ```CORE_DB```.
    - ```CREATE WAREHOUSE```: Cria o warehouse ```DBT_WH```.
    - ```CREATE FILE FORMAT```: Cria os formatos ```ONS_CSV_FORMAT``` e ```ONS_PARQUET_FORMAT```.
    - ```CREATE STAGE```: Cria o stage ```ONS_RAW_STAGE``` de forma permanente, garantindo que os arquivos de upload não sejam apagados.

**Passo 3: Criar as Tabelas da Camada RAW**

Execute o script ```snowflake_scripts_ons/02_create_raw_tables.sql```.

- O que faz:

    - ```CREATE OR REPLACE TABLE```: Cria todas as 12 tabelas (ex: ```GERACAO_USINA_RAW```, ```INTERRUPCAO_CARGA_RAW```, ```CLIMA_GO_DIARIO_RAW```, etc.) no schema ```RAW_DB.ONS_DATA```.
    - **Importante**: As tabelas são criadas com todas as colunas como ```VARCHAR``` (ou tipos de dados compatíveis) para garantir que a carga de dados brutos nunca falhe por tipos de dados inesperados.

**Passo 4: Fazer Upload dos Arquivos para o Stage**

Esta etapa é manual e usa a interface Web do Snowflake (Snowsight).

Navegue até o stage ```RAW_DB.ONS_DATA.ONS_RAW_STAGE```.

Clique em "+ Files" e faça o upload de todos os arquivos da sua pasta ```data/raw/``` para os seus respectivos diretórios no stage, conforme o mapeamento abaixo:

| Fonte de Dados (Notebook) | Diretório no Stage | Arquivos a Serem Carregados (da pasta `data/raw/`) |
| :--- | :--- | :--- |
| `02-EDA-Carga-Energia.ipynb` | `carga_verificada/` | `carga_verificada_go.parquet` |
| `02-EDA-Carga-Energia.ipynb` | `carga_programada/` | `carga_programada_go.parquet` |
| `08-Features-Meteorologicas.ipynb` | `clima/` | `clima_go_diario.csv` |
| `01-EDA-Variavel-Alvo-Interrupcao.ipynb` | `interrupcao/` | `INTERRUPCAO_CARGA.csv` |
| `03-EDA-Geracao.ipynb` | `geracao_usina/` | `GERACAO_USINA_*.csv` |
| `04-EDA-Rede.ipynb` | `restricao_eolica/` | `RESTRICAO_COFF_EOLICA*.csv` |
| `04-EDA-Rede.ipynb` | `restricao_fotovoltaica/` | `RESTRICAO_COFF_FOTOVOLTAICA*.csv` |
| `04-EDA-Rede.ipynb` | `intercambio_nacional/` | `INTERCAMBIO_NACIONAL_*.csv` |
| `05-EDA-Hidrica.ipynb` | `ear_diario/` | `EAR_DIARIO_SUBSISTEMA_*.csv` |
| `05-EDA-Hidrica.ipynb` | `ena_diario/` | `ENA_DIARIO_SUBSISTEMA_*.csv` |
| `07-Features-Adicionais.ipynb` | `cmo_semanal/` | `CMO_SEMANAL_*.csv` |
| `07-Features-Adicionais.ipynb` | `disponibilidade_usina/` | `DISPONIBILIDADE_USINA_*.csv` |

**Passo 5: Ingestão de Dados (Load)**

Execute o script ```snowflake_scripts_ons/03_load_raw_data.sql```.

- O que faz:

    - Executa 12 comandos ```COPY INTO``` ... que carregam os arquivos das subpastas do stage para as tabelas RAW correspondentes.
    - Usa ```MATCH_BY_COLUMN_NAME = 'CASE_INSENSITIVE'``` para os arquivos Parquet, garantindo o mapeamento correto das colunas.
    - Usa ```PURGE = FALSE``` para que os arquivos no stage não sejam apagados após a carga, permitindo re-execuções para desenvolvimento.
    - Finaliza com uma consulta ```UNION ALL``` que mostra a contagem de linhas em todas as 12 tabelas, validando que a ingestão foi bem-sucedida.

---

## 📊 Estrutura e Descobertas do Projeto

- **Coleta e Configuração (Scripts e config.py)**: O projeto demonstrou a importância de uma pipeline de dados robusta. A coleta foi automatizada e centralizada para lidar com dezenas de arquivos de múltiplos anos (desde 2010), superando inconsistências nos dados de origem.
- **Definição do Alvo (Notebook 01):** A variável alvo do projeto, `nivel_risco`, foi derivada da métrica `val_energianaosuprida_mwh` (Energia Não Suprida), escolhida por ser o indicador mais direto de um déficit no sistema. Para converter esta métrica contínua (MWh de déficit diário) em três classes de risco discretas (**baixo**, **médio**, **alto**), os limiares de classificação foram definidos estatisticamente. Foram utilizados os quantis (como P34 e P67, conforme explorado no notebook) calculados sobre os dias que registraram algum déficit, de forma a contornar o desbalanceamento natural dos dados e viabilizar a modelagem de 3 classes.
- **Engenharia de Features (Notebooks 02 a 08)**: Foi construída uma tabela de dados abrangente, cobrindo os pilares de Demanda (Carga), Oferta (Geração), Rede (Restrição, Intercâmbio), Hidrologia (EAR/ENA), Economia (CMO) e Meteorologia (Clima). Notavelmente, foram adicionadas features avançadas de janela deslizante e interação (Notebook 06).
- **Modelagem (Notebooks 09 a 12)**: Foram implementadas técnicas avançadas para lidar com o desbalanceamento de classes (Notebook 11). Foram treinados e otimizados modelos, incluindo XGBoost (Notebook 09), LTSM (Notebook 10) e técnicas de Ensemble (Notebook 12).

---

## 📉 Conclusões Finais

*1. Principal Descoberta: O Problema da "Agulha no Palheiro."* A principal conclusão do projeto é que, mesmo com um dataset abrangendo **mais de uma década (desde 2010)** e uma engenharia de features complexa, a previsão de 3 classes de risco é extremamente desafiadora. Os eventos de risco "médio" e "alto" são tão raros que os modelos de machine learning, embora tecnicamente funcionais, apresentaram um baixo poder preditivo (Recall nulo ou próximo de zero) para essas classes.

*2. Análise de Insights: Identificando os Fatores-Chave de Risco*: Uma das saídas mais valiosas do projeto, obtida através da modelagem (incluindo XGBoost e Ensemble), é o ranking de Importância das Features. Esta análise revelou quais indicadores são os mais sensíveis ao estresse do sistema elétrico. Consistentemente, variáveis ligadas à segurança e ao custo do sistema, como:

* `ear_percentual_seco` (nível dos reservatórios)
* `cmo_semanal_seco` (preço da energia)
* `saldo_intercambio_seco` (dependência de outras regiões)
* Features de tendência, como `carga_media_7d` (média móvel da carga)

... apareceram como as mais importantes. Este resultado fornece um insight acionável sobre quais métricas são cruciais e devem ser monitoradas com mais atenção para uma gestão proativa do risco energético.