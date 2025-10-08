# 🔋 Previsão de Risco de Déficit Energético em Goiás  
**Módulo 2: Machine Learning para Políticas Públicas**

---

## 📌 Visão Geral  
Este projeto tem como objetivo desenvolver um modelo de *machine learning* para classificar o risco diário de déficit de energia elétrica no estado de Goiás.  

O modelo final deverá categorizar cada dia em um dos três níveis de risco: **baixo, médio ou alto**, servindo como uma ferramenta de apoio à decisão para a operação do sistema elétrico.  

Este repositório contém uma **pipeline completa** de coleta de dados, engenharia de *features* e modelagem para abordar este problema.  

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

## 2. Definição do Período de Análise

Edite o arquivo config.py na raiz do projeto para definir o intervalo de tempo desejado:

```python
# Exemplo em config.py
START_YEAR = 2022
END_YEAR = 2025
END_MONTH = 10

```

## 3. Coleta de Dados

Execute os scripts na pasta /scripts para baixar todos os dados brutos necessários:

```bash
# Baixa os arquivos CSV do S3 da ONS
python scripts/download_data.py

# Extrai os dados de Carga da API da ONS
python scripts/extract_carga_api.py
```

## 4. Engenharia de Features e Modelagem

Execute os notebooks Jupyter em sequência (01 a 08). Cada notebook realiza uma etapa do processamento e salva seu resultado, que será usado pelo próximo:

1. `01-EDA-Variavel-Alvo-Interrupcao.ipynb`
2. `02-EDA-Carga-Energia.ipynb`
3. `03-EDA-Geracao.ipynb`
4. `04-EDA-Rede.ipynb`
5. `05-EDA-Hidrica.ipynb`
6. `06-Feature-Engineering-Avancada.ipynb`
7. `07-Modelagem.ipynb` — *Baseline com XGBoost*
8. `08-Otimizacao-Hiperparametros.ipynb` — *Busca de melhores parâmetros*

---

## 📊 Estrutura dos Notebooks

- **Notebooks 01 a 05**  
  - Coleta e processamento inicial (Demanda, Oferta, Rede, Hidráulica, etc.).  
  - Cada notebook agrega dados em base diária e consolida em `feature_table_final.parquet`.

- **Notebook 06 — Engenharia de features avançadas**  
  - Criação de janelas deslizantes, *lags*, diferenças e interações.  
  - Gera `modeling_table.parquet` para uso em modelagem.

- **Notebook 07 — Modelagem (baseline)**  
  - Treina modelo **XGBoost** com **SMOTE** e avalia métricas iniciais.

- **Notebook 08 — Otimização de hiperparâmetros**  
  - Uso de `RandomizedSearchCV` para buscar melhores configurações do XGBoost.

---

## 📉 Descobertas e Limitações Atuais

- **Desbalanceamento extremo de classes** → eventos `medio` e `alto` são muito raros nos dados históricos.  
- **Performance limitada** → modelos (mesmo otimizados) apresentam *recall* muito baixo ou nulo para `medio` e `alto`.  
- **Conclusão principal** → a previsão multiclasse (3 níveis) é complexa: o sinal que diferencia dias de risco é muito sutil nos dados públicos disponíveis.

---

## 💡 Próximos Passos Sugeridos

### 🔧 Engenharia de Features
- Criar *features* de janela deslizante com diferentes períodos (ex.: 15, 30 dias).  
- Explorar mais *features* de interação (ex.: `restricao / geracao_total`).

### 🤖 Modelagem
- Testar outros algoritmos: `RandomForestClassifier`, `LightGBM`.  
- Experimentar técnicas de amostragem: `ADASYN` ou combinações de over/under-sampling.  
- Ajustar **thresholds de decisão** com `predict_proba` para aumentar a sensibilidade às classes raras.

### 🔀 Mudança de Abordagem (se necessário)
- Se a abordagem de 3 classes não evoluir, justificar migrar para **classificação binária**:  
  - `baixo` vs `risco presente`  
  - Um modelo binário com bom *recall* pode ser mais útil operacionalmente.
