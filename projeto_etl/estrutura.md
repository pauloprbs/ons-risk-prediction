%% Diagrama de Fluxo (Flowchart) representando a Arquitetura da Solução em Nuvem para o Projeto de Energia
graph TD
    %% Camada 1: Fontes de Dados
    subgraph Camada 1: Fontes de Dados
        A[Portal ONS] --> B{Arquivos CSV na AWS S3};
    end

    %% Conexão Camada 1 -> Camada 2
    B -->|Ingestão de Dados (ELT)| C(Airbyte.com);

    %% Camada 2: Ingestão de Dados
    subgraph Camada 2: Ingestão de Dados (Extract & Load)
        C --> D[Carrega para Snowflake];
    end

    %% Camada 3: Armazenamento e Transformação
    subgraph Camada 3: Armazenamento e Transformação (Snowflake)
        D --> E(Database RAW_DATA);
        E --> F[dbt - Data Build Tool];
        F --> G{models/staging/};
        F --> H{models/marts/};
        G --> I(Database ANALYTICS);
        H --> I;
    end

    %% Conexão Camada 3 -> Camada 4
    I -->|Extração Orquestrada| J(Apache Airflow);

    %% Camada 4: Orquestração e Execução
    subgraph Camada 4: Orquestração e Execução (Airflow em Docker)
        J --> K[DAG dbt_etl_pipeline: Executa dbt run/test];
        J --> L[DAG export_fact_to_gcs];
    end

    %% Fluxo de transformação interna (simplificado)
    K --> I; %% Airflow dispara dbt, que transforma dados no Snowflake

    %% Fluxo de Exportação
    L --> M[Consulta fct_geracao_energia];
    M --> N[Exporta para CSV];

    %% Conexão Camada 4 -> Camada 5
    N -->|Armazenamento de Artefato| O[Google Cloud Storage (GCS)];

    %% Camada 5: Camada de Saída
    subgraph Camada 5: Camada de Saída (Output Layer)
        O --> P{Bucket: projeto-etl-m2-fatos};
    end

    %% Conexão Camada 5 -> Camada 6
    P -->|Leitura e Análise| Q[Google Colab];

    %% Camada 6: Análise e Consumo
    subgraph Camada 6: Análise e Consumo
        Q --> R[Análises Exploratórias];
        Q --> S[Treinamento de Modelos ML];
    end