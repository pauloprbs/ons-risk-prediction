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

**Passo 6: Transformação de Dados (dbt)**

Com a camada `RAW` populada, esta etapa executa o pipeline de transformação SQL que replica a lógica dos notebooks Jupyter.

1. Estrutura do dbt: O projeto `dbt_ons/` está organizado em três camadas:

    - `models/staging/`: Contém 12 modelos (1 para cada fonte) que limpam, renomeiam e corrigem os tipos de dados da camada RAW.

    - `models/intermediate/`: Contém 9 modelos que agregam os dados por dia (ex: `int_deficit_diario.sql`, `int_geracao_diaria.sql`), preparando-os para a junção final.

    - `models/core/`: Contém o modelo `fct_modeling_table_final.sql`, que une todas as fontes intermediárias e aplica as features de janela deslizante (ex: carga_media_7d, ear_ontem).

2. Configuração (Primeira Execução):

    - Assegure-se de que seu arquivo `.env`, conforme o exemplo, na raiz do projeto está com as credenciais corretas do Snowflake.

    ```env
    # ==========================================================
    # ARQUIVO .ENV EXEMPLO
    # Este arquivo NÃO DEVE ser enviado para o Git.
    # Preencha com suas credenciais pessoais.
    # ==========================================================

    # --- Airbyte ---
    VERSION=latest
    DATABASE_USER=docker
    DATABASE_PASSWORD=docker
    DATABASE_DB=airbyte
    CONFIG_ROOT=/data
    WORKSPACE_ROOT=/workspace
    # ... (outras variáveis do Airbyte)

    # --- Airflow ---
    AIRFLOW_DB_USER=airflow
    AIRFLOW_DB_PASSWORD=airflow
    AIRFLOW_DB_NAME=airflow
    AIRFLOW_USER=admin
    AIRFLOW_PASSWORD=admin
    AIRFLOW__CORE__FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
    AIRFLOW__WEBSERVER__SECRET_KEY=changeme

    # --- Snowflake (dbt) ---
    # Conta (da sua URL)
    SNOWFLAKE_ACCOUNT=utkyvtt-ub67942

    # Warehouse (que criamos no script 01_setup.sql)
    SNOWFLAKE_WAREHOUSE=DBT_WH

    # Banco de dados e Schema padrão (definidos no profiles.yml do dbt)
    SNOWFLAKE_DATABASE=CORE_DB
    SNOWFLAKE_SCHEMA=ML_FEATURES

    # --- PREENCHA COM SUAS CREDENCIAIS ---
    SNOWFLAKE_USER=SEU_USUARIO_DBT
    SNOWFLAKE_PASSWORD=SUA_SENHA_DBT
    SNOWFLAKE_ROLE=SUA_ROLE_DBT
    ```

    - O arquivo `dbt_ons/profiles.yml` está configurado para ler essas variáveis.

    - Instale os pacotes de dependência (como o `dbt_utils`):

```bash
docker-compose exec dbt dbt deps
```

3. Executar o Pipeline dbt:

    - A partir da pasta raiz do projeto (`ons-risk-prediction/`), execute o pipeline completo:

    ```bash
    docker-compose exec dbt dbt run
    ```

    - O que faz: O dbt irá compilar e executar todos os 22 modelos (`.sql`) em ordem. Ele criará as views de `staging` e `intermediate` no banco `STAGING_DB` e a tabela final `FCT_MODELING_TABLE_FINAL` no banco `CORE_DB`.

4. Verificar o Resultado:

    - Você pode verificar a tabela final diretamente do terminal:

    ```bash
    docker-compose exec dbt dbt show --select fct_modeling_table_final --limit 5
    ```

    Ou consultando no Snowflake: `SELECT * FROM CORE_DB.ML_FEATURES.FCT_MODELING_TABLE_FINAL LIMIT 10;

**Passo 7: Orquestração do Pipeline com Airflow**

Com o pipeline de ELT do Snowflake (Load) e dbt (Transform) validado, o próximo passo é automatizar sua execução usando o Apache Airflow.

1. Configuração do Ambiente Airflow:

    - Para que o Airflow possa executar os comandos do dbt e os scripts de extração, precisamos que ele tenha as bibliotecas necessárias. O arquivo `docker-compose.yml` (localizado na raiz do projeto) foi ajustado para:

        - Instalar `dbt-snowflake` dentro dos containers do Airflow (`airflow-init`, `airflow-webserver`, `airflow-scheduler`).

        - Mapear (montar) as pastas do nosso projeto (`airflow_ons/`, `dbt_ons/` e `scripts/`) para dentro dos containers, para que o Airflow possa acessá-las.

2. Refatoração dos Scripts de Extração (Que foram copiados para a pasta do Airflow):

    - Os scripts `scripts/extract_carga_api.py` e `scripts/download_weather_data.py` foram refatorados. Suas lógicas principais foram movidas de `if __name__ == "__main__":` para funções nomeadas (ex: `extract_carga_main()` e `download_clima_main()`).

    - Isso permite que o Airflow os importe e os execute como tarefas Python (`@task`), ao mesmo tempo em que ainda podem ser executados manualmente via terminal.

3. Criação do DAG (Pipeline Orquestrado):

    - O arquivo `airflow_ons/dags/ons_feature_pipeline_dag.py` define o nosso pipeline. Ele consiste em quatro tarefas principais:

        - `extract_carga_api`: Tarefa Python (`@task`) que chama a função `extract_carga_main()`.

        - `download_weather_data`: Tarefa Python (`@task`) que chama a função `download_clima_main()`.

        - `dbt_run_transformations`: Tarefa `BashOperator` que executa `dbt run` após as extrações terminarem.

        - `dbt_test_data_quality`: Tarefa `BashOperator` que executa `dbt test` após o `dbt run`.

    - As dependências são definidas da seguinte forma: as duas tarefas de extração rodam em paralelo; somente após ambas terminarem com sucesso, a tarefa `dbt_run` é iniciada, seguida pelo `dbt_test`.

4. Executando o Pipeline Orquestrado:

    - Inicie (ou reinicie, se já estiverem rodando) todos os serviços do Docker com as novas configurações:

    ```bash
    # Na pasta raiz (ons-risk-prediction/), pare os containers antigos
    docker-compose down

    # Inicie os containers com as novas configurações (o --build é importante na primeira vez)
    docker-compose up -d --build
    ```

    - Acesse a interface do Airflow em seu navegador: http://localhost:8080 (usuário/senha: admin/admin, conforme seu .env).

    - Na lista de DAGs, encontre ons_feature_pipeline_dag.

    - Ative o DAG clicando no botão de "toggle" (de "Off" para "On").

    - Para rodar o pipeline imediatamente, clique no ícone "Play" (Trigger DAG) à direita.

**Passo 8: Exportação de Dados para S3 (Para Modelagem)**

Após o pipeline do Airflow garantir que a tabela `FCT_MODELING_TABLE_FINAL` está atualizada no Snowflake, o próximo passo é exportar esses dados para um local que o SageMaker possa consumir eficientemente. Usaremos um bucket S3.

Para esta etapa é preciso possuir um bucket S3 vazio criado (ex: `ons-risk-prediction-data-674650987717`).

**8.1 – Configurar o IAM Role na AWS**

Precisamos de um IAM Role na AWS que o Snowflake possa "assumir" para ter permissão de escrever no S3.

1. **Acesse o IAM** no Console da AWS e vá para Roles (Funções).

2. **Anexar Política de Permissões (Permissions Policy)**: Crie ou verifique uma política com as ações necessárias no seu bucket:

    ```json
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:DeleteObject"
        ],
        "Resource": [
            "arn:aws:s3:::ons-risk-prediction-data-674650987717",
            "arn:aws:s3:::ons-risk-prediction-data-674650987717/*"
        ]
        }
    ]
    }
    ```

3. **Editar Política de Confiança (Trust Policy)**: Esta é a parte crucial. Edite a "Trust Relationship" do seu Role para permitir que a conta AWS do Snowflake (ex: arn:aws:iam::851725645124:root) assuma esta função, usando um ExternalId que obteremos do Snowflake.

    ```json
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::851725645124:root"
        },
        "Action": "sts:AssumeRole",
        "Condition": {
            "StringEquals": {
            "sts:ExternalId": "SEU_EXTERNAL_ID_GERADO_NO_PASSO_8_2"
            }
        }
        }
    ]
    }
    ```

**8.2 – Criar a STORAGE INTEGRATION no Snowflake**

Este objeto conecta o Snowflake ao IAM Role da AWS.

    1. Primeiro, obtenha o `STORAGE_AWS_EXTERNAL_ID` executando `DESC INTEGRATION` (ou na criação inicial).

    2. Execute no Snowflake (como `ACCOUNTADMIN`):

    ```sql
    8.2 – Criar a STORAGE INTEGRATION no Snowflake
    Este objeto conecta o Snowflake ao IAM Role da AWS.

    Primeiro, obtenha o STORAGE_AWS_EXTERNAL_ID executando DESC INTEGRATION (ou na criação inicial).

    Execute no Snowflake (como ACCOUNTADMIN):
    ```
    Garanta que o `STORAGE_AWS_EXTERNAL_ID` aqui seja o mesmo usado no `sts:ExternalId` da Política de Confiança do IAM Role.

**8.3 – Criar o STAGE no Snowflake**

O Stage é um ponteiro para o S3, usando a integração que acabamos de criar.

```sql
USE DATABASE CORE_DB;
USE SCHEMA ML_FEATURES;

CREATE OR REPLACE STAGE my_s3_stage
STORAGE_INTEGRATION = my_s3_integration -- Nome da integração
URL = 's3://ons-risk-prediction-data-674650987717/'
FILE_FORMAT = (TYPE = PARQUET COMPRESSION = SNAPPY);
```

**8.4 – Testar a Conexão do Stage (Opcional)**

Execute no Snowflake: `LIST @my_s3_stage;`. Se retornar uma lista (mesmo que vazia) sem erros, a conexão está funcionando.

8.5 – Exportar os Dados da Tabela para o S3
Use o comando `COPY INTO` para descarregar (exportar) os dados da sua tabela dbt para o S3.

```sql
COPY INTO @my_s3_stage/export/ -- Salvará na 'pasta' /export do S3
FROM CORE_DB.ML_FEATURES.FCT_MODELING_TABLE_FINAL
FILE_FORMAT = (TYPE = PARQUET COMPRESSION = SNAPPY)
MAX_FILE_SIZE = 50000000 -- Divide em arquivos de ~50MB
HEADER = TRUE
OVERWRITE = TRUE;
```

**8.6 – Verificar os Arquivos no S3**

Vá até o console do S3, navegue até o bucket `ons-risk-prediction-data-674650987717` e verifique a pasta `export/`. Você deverá ver os arquivos Parquet gerados (ex: `data_0_0_0.parquet.snappy`).



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