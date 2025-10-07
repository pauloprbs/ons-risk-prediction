import requests
import pandas as pd
from datetime import datetime
from dateutil.relativedelta import relativedelta
import os
import json

BASE_URL = "https://apicarga.ons.org.br/prd" 

ENDPOINT_VERIFICADA = "/cargaverificada"
ENDPOINT_PROGRAMADA = "/cargaprogramada"
CODIGO_AREA = "GO"

DATA_INICIO_TOTAL = datetime(2024, 1, 1)
DATA_FIM_TOTAL = datetime(2024, 12, 31)

def fetch_ons_data(endpoint, data_inicio, data_fim, cod_areacarga):
    """
    Função para buscar dados de um endpoint específico da API do ONS,
    com logging de erro melhorado.
    """
    url = f"{BASE_URL}{endpoint}"
    params = {
        'dat_inicio': data_inicio.strftime('%Y-%m-%d'),
        'dat_fim': data_fim.strftime('%Y-%m-%d'),
        'cod_areacarga': cod_areacarga
    }
    
    print(f"Buscando dados em {url} de {params['dat_inicio']} a {params['dat_fim']}...")
    
    try:
        response = requests.get(url, params=params)
        
        if response.status_code != 200:
            print(f"  -> ERRO: API retornou status {response.status_code}")
            print(f"  -> Resposta: {response.text}")
            return None

        if not response.json():
             print("  -> AVISO: A API retornou uma lista vazia para este período.")
             return [] 

        return response.json()

    except requests.exceptions.RequestException as e:
        print(f"  -> ERRO de Conexão: {e}")
        return None

def main():
    """
    Função principal para orquestrar a extração.
    """
    all_data_verificada = []
    all_data_programada = []

    data_atual = DATA_INICIO_TOTAL
    while data_atual < DATA_FIM_TOTAL:
        data_fim_janela = min(data_atual + relativedelta(months=3, days=-1), DATA_FIM_TOTAL)
        
        dados_verificados = fetch_ons_data(ENDPOINT_VERIFICADA, data_atual, data_fim_janela, CODIGO_AREA)
        if dados_verificados is not None:
            all_data_verificada.extend(dados_verificados)
            
        dados_programados = fetch_ons_data(ENDPOINT_PROGRAMADA, data_atual, data_fim_janela, CODIGO_AREA)
        if dados_programados is not None:
            all_data_programada.extend(dados_programados)

        data_atual += relativedelta(months=3)

    print("\nExtração de todas as janelas concluída.")

    if not all_data_verificada or not all_data_programada:
        print("\nResultado: Nenhum dado extraído. Verifique os logs de erro acima.")
        return

    df_verificada = pd.json_normalize(all_data_verificada)
    df_programada = pd.json_normalize(all_data_programada)
    
    # --- CORREÇÃO APLICADA AQUI ---
    # Removemos o '../' para que o caminho seja relativo à pasta raiz do projeto.
    output_dir = 'data/raw/'
    # -----------------------------
    os.makedirs(output_dir, exist_ok=True)
    
    path_verificada = os.path.join(output_dir, 'carga_verificada_go.parquet')
    path_programada = os.path.join(output_dir, 'carga_programada_go.parquet')
    
    df_verificada.to_parquet(path_verificada, index=False)
    df_programada.to_parquet(path_programada, index=False)
    
    print(f"\nDados salvos com sucesso em:")
    print(f"- {path_verificada} ({len(df_verificada)} registros)")
    print(f"- {path_programada} ({len(df_programada)} registros)")

if __name__ == "__main__":
    main()