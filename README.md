# 🔋 Previsão de Risco de Déficit Energético em Goiás
**Módulo 2: Machine Learning para Políticas Públicas**

---

## 📌 Visão Geral
Este projeto tem como objetivo desenvolver um modelo de *machine learning* para **classificar o risco diário de déficit de energia elétrica** no estado de Goiás.

O modelo final deverá categorizar cada dia em um dos três níveis de risco: **baixo, médio ou alto**, servindo como uma **ferramenta de apoio à decisão** para a operação do sistema elétrico.

---

## 📊 Status Atual (07/10/2025)
✅ A fase de **Engenharia de Features** foi concluída com sucesso.  
📂 Construímos uma tabela de dados final, **rica e consistente**, pronta para ser usada na modelagem de *machine learning*.

---

## ✔ Estrutura do Projeto e Ambiente
- Repositório Git configurado com um **.gitignore robusto**  
- **Ambiente virtual (venv)** e dependências gerenciadas via `requirements.txt`  
- **Pipeline de processamento de dados** estabelecido através de notebooks sequenciais  

---

## ✔ Definição da Variável Alvo (Notebook 01)
- **Fonte:** Interrupção de Carga  
- **Lógica:** Agregação da **Energia Não Suprida (ENS)** por dia em Goiás, com classes de risco (baixo, médio, alto) definidas via **quantis dos eventos mais severos**.  
- **Resultado:** `data/processed/target_variable_daily.parquet`

---

## ✔ Feature Engineering

### 🔹 Demanda/Carga (Notebook 02)
- **Fonte:** API do ONS (`scripts/extract_carga_api.py`)  
- **Features Criadas:**  
  - `carga_total_diaria`  
  - `diferenca_verif_prog`  
- **Resultado:** `data/processed/feature_table_v1.parquet`

---

### 🔹 Oferta/Geração (Notebook 03)
- **Fontes:** Geração por Usina e Fator de Capacidade  
- **Features Criadas:**  
  - `geracao_total_diaria_go`  
  - geração por tipo de usina  
  - `fator_cap_solar_medio_seco`  
- **Resultado:** `data/processed/feature_table_v2.parquet`

---

### 🔹 Rede/Transmissão (Notebook 04)
- **Fontes:** Restrição de Operação e Intercâmbios Entre Subsistemas  
- **Features Criadas:**  
  - `total_mwh_restrito_go`  
  - `saldo_intercambio_seco`  
- **Insights:**  
  - Restrições são **ações preventivas**  
  - Intercâmbio é uma **ferramenta de mitigação**  
- **Resultado:** `data/processed/feature_table_v3.parquet`

---

### 🔹 Contexto Hídrico (Notebook 05)
- **Fontes:** EAR Diário e ENA Diário  
- **Features Criadas:**  
  - `ear_percentual_seco` (nível dos reservatórios)  
  - `ena_percentual_mlt_seco` (vazão)  
- **Resultado Final:**  
  - Tabela de features completa, pronta para a modelagem:  
    `data/processed/feature_table_final.parquet`

---

## 🚀 Próximos Passos: Modelagem de Machine Learning
Com a tabela de dados pronta, a próxima fase é **treinar e avaliar os modelos de classificação**.

---

## 📍 Tarefa Imediata: Notebook 06 - Modelagem
### 🎯 Objetivo
Criar o notebook `06-Modelagem.ipynb` para treinar um primeiro modelo.

### 🔑 Passos Sugeridos
1. **Carregar Dados**
   - Ler `data/processed/feature_table_final.parquet`
2. **Pré-processamento**
   - Separar `X` (features) e `y` (variável-alvo `nivel_risco`)  
   - Converter `y` de texto (`baixo`, `medio`, `alto`) para números (`0, 1, 2`)  
   - Dividir em treino e teste (`train_test_split`)  
3. **Treinamento do Modelo Base**
   - Iniciar com **Regressão Logística** (simples e interpretável)  
   - Tratar **desbalanceamento das classes** com `class_weight='balanced'`  
4. **Avaliação**
   - Métricas:  
     - `accuracy_score`  
     - `confusion_matrix`  
     - `classification_report` (precisão, recall, f1-score por classe)  

---

## 🔮 Olhando para o Futuro
Após o modelo base, os próximos passos podem incluir:
- Testar **modelos mais robustos** (ex.: `RandomForestClassifier`, `XGBoost`)  
- Analisar **Feature Importance** para entender variáveis mais relevantes  
- **Otimizar hiperparâmetros** dos melhores modelos  

---
