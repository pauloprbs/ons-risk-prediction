# 🔋 Previsão de Risco de Déficit Energético em Goiás

**Módulo 2: Machine Learning para Políticas Públicas**

---

## 📌 Visão Geral
Este projeto tem como objetivo desenvolver um modelo de *machine learning* para classificar o risco diário de déficit de energia elétrica em Goiás.  
O modelo deve categorizar cada dia em três níveis de risco (**baixo**, **médio** ou **alto**), servindo como uma ferramenta de apoio à decisão para a segurança do suprimento energético.

Este repositório contém a **pipeline completa** de coleta de dados, engenharia de *features* e modelagem desenvolvida para abordar este desafio.

---

## 🚀 Pipeline de Execução Completa

### 1. Configuração do Ambiente
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

### 2. Definição do Período de Análise
Edite o arquivo config.py na raiz do projeto para definir o intervalo de tempo desejado para a análise. A pipeline está configurada para lidar com múltiplos anos.

```python
# Exemplo em config.py
START_YEAR = 2022
END_YEAR = 2025
END_MONTH = 10
```

3. Coleta Automatizada de Dados
Execute os scripts na pasta ```/scripts``` para baixar todos os dados brutos necessários. Eles lerão a configuração do ```config.py```.

```bash
# Limpe a pasta de dados brutos para garantir uma coleta nova
# (Opcional, mas recomendado para uma execução limpa)
rm data/raw/*

# Baixa os arquivos CSV do S3 da ONS
python scripts/download_data.py

# Extrai os dados de Carga da API da ONS
python scripts/extract_carga_api.py
```

4. Engenharia de Features e Modelagem
Execute os notebooks Jupyter em sequência, do 01 ao final. Cada notebook realiza uma etapa do processamento e salva seu resultado, que é usado pelo notebook seguinte.

1. ```01-EDA-Variavel-Alvo-Interrupcao.ipynb```

2. ```02-EDA-Carga-Energia.ipynb```

3. ```03-EDA-Geracao.ipynb```

4. ```04-EDA-Rede.ipynb```

5. ```05-EDA-Hidrica.ipynb```

6. ```06-Feature-Engineering-Avancada.ipynb```

7. ```07-Features-Adicionais.ipynb```

8. ```08-Features-Meteorologicas.ipynb```

9. ```09-Modelagem-Thresholding.ipynb```

---

### 📊 Estrutura e Descobertas do Projeto

- Coleta e Configuração (Scripts e config.py): O projeto demonstrou a importância de uma pipeline de dados robusta. A coleta foi automatizada e centralizada para lidar com dezenas de arquivos de múltiplos anos, superando inconsistências nos dados de origem.

- Definição do Alvo (Notebook 01): A variável nivel_risco foi derivada da Energia Não Suprida diária. Uma descoberta crucial foi a necessidade de ajustar os limiares de classificação (usando quantis P80 e P95) para contornar a extrema raridade dos eventos e viabilizar a modelagem de 3 classes.

- Engenharia de Features (Notebooks 02 a 09): Foi construída uma tabela de dados abrangente com mais de 50 features, cobrindo os pilares de Demanda, Oferta, Rede, Hidrologia e Economia. Notavelmente, foram adicionadas features avançadas de janela deslizante e interação, além de indicadores-chave como o CMO Semanal e a Disponibilidade de Usinas.

- Modelagem (Notebooks 10 e 11): Foram implementadas técnicas avançadas para lidar com o desbalanceamento de classes, incluindo Data Augmentation (SMOTE). Foram treinados e otimizados dois modelos poderosos: XGBoost e RandomForest.

---

### 📉 Conclusões Finais
1. Principal Descoberta: O Problema da "Agulha no Palheiro"
A principal conclusão do projeto é que, mesmo com um dataset abrangendo quase quatro anos e uma engenharia de features complexa, a previsão de 3 classes de risco é extremamente desafiadora. Os eventos de risco "médio" e "alto" são tão raros que os modelos de machine learning, embora tecnicamente funcionais, apresentaram um baixo poder preditivo (Recall nulo ou próximo de zero) para essas classes.

2. O Valor Não Está na Acurácia, Mas nos Insights:
Embora o modelo não preveja as classes raras, o resultado mais valioso do projeto é o ranking de Importância das Features. Esta análise revelou os indicadores mais sensíveis ao estresse do sistema elétrico. Consistentemente, variáveis como:

- ```ear_percentual_seco``` (nível dos reservatórios)

- ```cmo_semanal_seco``` (preço da energia)

- ```saldo_intercambio_seco``` (dependência de outras regiões)

Features de tendência, como carga_media_7d (média móvel da carga)

... apareceram como as mais importantes, fornecendo um insight acionável sobre quais métricas devem ser monitoradas com mais atenção.

---

### 💡 Recomendações Estratégicas


- Adotar um Modelo Binário para Uso Prático: Como alternativa, um modelo de classificação binária ('baixo' vs. 'risco presente') teria uma probabilidade muito maior de sucesso, funcionando como um sistema de "alerta geral" eficaz.

- Enriquecer com Novos Dados: Para avançar na previsão de 3 classes, seria crucial a inclusão de novas fontes de dados, como dados meteorológicos detalhados (radiação solar, velocidade do vento), status de manutenção de equipamentos e outras variáveis operacionais não públicas.

- Focar nos Indicadores-Chave: A análise de importância de features pode ser usada para desenvolver um dashboard de monitoramento focado nas variáveis mais sensíveis ao risco.