Projeto: Previsão de Risco de Déficit Energético em Goiás
Módulo 2: Machine Learning para Políticas Públicas

Visão Geral
Este projeto tem como objetivo desenvolver um modelo de machine learning para classificar o risco diário de déficit de energia elétrica no estado de Goiás. O modelo final deverá categorizar cada dia em um dos três níveis de risco: baixo, médio ou alto, servindo como uma ferramenta de apoio à decisão para a operação do sistema elétrico.

Status Atual (05/10/2025)
Concluímos com sucesso a fase de fundação e a primeira etapa de construção de features. A tabela de dados para modelagem está sendo construída incrementalmente.

[✔] Estrutura do Projeto e Ambiente:

Repositório Git configurado com um .gitignore robusto.

Ambiente virtual (venv) e dependências gerenciadas via requirements.txt.

[✔] Definição da Variável Alvo (Notebook 01):

Utilizamos o dataset de Interrupção de Carga como a fonte de verdade para os déficits.

Agregamos os eventos por dia para calcular a "Energia Não Suprida" (ENS) diária em Goiás.

Criamos a variável-alvo nivel_risco ('baixo', 'medio', 'alto') com base em uma metodologia robusta, inspirada na literatura do setor (usando quantis para definir os limiares dos eventos mais severos).

O resultado foi salvo em data/processed/target_variable_daily.parquet.

[✔] Feature Engineering: Demanda/Carga (Notebook 02):

Desenvolvemos um script (scripts/extract_carga_api.py) para extrair dados da API do ONS de forma automatizada.

Processamos os dados de carga verificada e programada.

Criamos as primeiras features, como carga_total_diaria e a diferenca_verif_prog.

Juntamos essas features à tabela-alvo, salvando o resultado em data/processed/feature_table_v1.parquet.

[✔] Feature Engineering: Oferta/Geração (Notebook 03):

Processamos os datasets de Geração por Usina e Fator de Capacidade.

Criamos features de oferta de energia, como geracao_total_diaria_go, geração por tipo de usina e fator_cap_solar_medio_seco.

A análise inicial mostrou que a relação entre risco e geração é complexa, sugerindo que outros fatores (como restrições na rede) são muito importantes.

O resultado final foi salvo em data/processed/feature_table_v2.parquet.

Próximos Passos
A base de dados atual (feature_table_v2.parquet) contém a variável-alvo e features de demanda e oferta. O próximo passo é enriquecer esta base com variáveis que descrevem a saúde e o estresse da rede de transmissão.

Tarefa Imediata: Notebook 04 - Análise da Rede e Transmissão
O objetivo é criar e executar o notebook 04-EDA-Rede.ipynb.

Preparação: Baixar os seguintes datasets do Portal de Dados Abertos do ONS e salvá-los na pasta /data:

Restrição de Operação por Constrained-off de Usinas Fotovoltaicas / Eólicas

Intercâmbios Entre Subsistemas

Carregar Dados: No novo notebook, carregar a nossa tabela de features mais recente: data/processed/feature_table_v2.parquet.

Processar e Criar Features:

Para o dataset de Restrição de Operação, filtre para Goiás, agregue por dia e crie uma feature como total_mwh_restrito_go. Um valor alto aqui é um forte indicador de gargalos na rede.

Para o dataset de Intercâmbios, filtre para o subsistema Sudeste/Centro-Oeste (SE/CO) e crie uma feature como saldo_intercambio_seco. Um valor muito negativo (alta importação) pode indicar que o subsistema não é autossuficiente naquele dia.

Juntar e Analisar: Faça o merge das novas features na tabela principal. Crie visualizações (boxplots) para analisar a relação entre as restrições na rede e os níveis de risco.

Salvar: Salve a tabela final, agora ainda mais completa, como data/processed/feature_table_v3.parquet.

Olhando para o Futuro
Após a conclusão do Notebook 04, o último passo da engenharia de features será o Notebook 05, focado na Análise Hídrica (usando os datasets de EAR e ENA), que nos dará o contexto de segurança de longo prazo do sistema.

Como Começar
Para continuar o trabalho:

Clone o repositório: git clone [URL_DO_REPOSITORIO]

Crie e ative o ambiente virtual:

python -m venv venv

source venv/bin/activate (no Mac/Linux) ou .\venv\Scripts\activate (no Windows)

Instale as dependências: pip install -r requirements.txt

Certifique-se de que os dados brutos necessários estão na pasta /data (conforme descrito nos próximos passos).

Abra o Jupyter Lab (jupyter lab) e comece a trabalhar no 04-EDA-Rede.ipynb.

Bom trabalho, equipe!