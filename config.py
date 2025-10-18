# Arquivo de Configuração Central para o Projeto
from datetime import datetime

# --- Período de Análise ---
# Datas iniciais fixas
START_YEAR = 2010
START_MONTH = 1

# --- Controle Automático ---
# Se True -> usa o mês mais recente automaticamente
# Se False -> usa os valores definidos manualmente em END_YEAR / END_MONTH
USE_CURRENT_DATE = True  

# Datas finais
if USE_CURRENT_DATE:
    today = datetime.today()
    END_YEAR = today.year
    END_MONTH = today.month
else:
    END_YEAR = 2025
    END_MONTH = 10
