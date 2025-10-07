import os
import sys
import requests
import pandas as pd
from tqdm import tqdm

# Adiciona a pasta raiz ao path para encontrar o config.py
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from config import START_YEAR, START_MONTH, END_YEAR, END_MONTH

# 2. Defina a pasta de destino para os dados brutos
DESTINATION_FOLDER = 'data/raw/'

# 3. Configuração dos datasets com base nos links que você forneceu
BASE_URL = "https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/"
DATASETS = [
    {
        "name": "Geracao por Usina",
        "folder": "geracao_usina_2_ho",
        "file_prefix": "GERACAO_USINA-2",
        "frequency": "monthly"
    },
    {
        "name": "Fator de Capacidade",
        "folder": "fator_capacidade_2_di",
        "file_prefix": "FATOR_CAPACIDADE-2",
        "frequency": "monthly"
    },
    {
        "name": "Restricao Eolica",
        "folder": "restricao_coff_eolica_tm",
        "file_prefix": "RESTRICAO_COFF_EOLICA",
        "frequency": "monthly"
    },
    {
        "name": "Restricao Fotovoltaica",
        "folder": "restricao_coff_fotovoltaica_tm",
        "file_prefix": "RESTRICAO_COFF_FOTOVOLTAICA",
        "frequency": "monthly"
    },
    {
        "name": "EAR por Subsistema",
        "folder": "ear_subsistema_di",
        "file_prefix": "EAR_DIARIO_SUBSISTEMA",
        "frequency": "annual"
    },
    {
        "name": "ENA por Subsistema",
        "folder": "ena_subsistema_di",
        "file_prefix": "ENA_DIARIO_SUBSISTEMA",
        "frequency": "annual"
    },
    {
        "name": "Intercambio Nacional",
        "folder": "intercambio_nacional_ho",
        "file_prefix": "INTERCAMBIO_NACIONAL",
        "frequency": "annual"
    },
]
# --- FIM DAS CONFIGURAÇÕES ---


def download_file(url, save_path):
    """
    Baixa um arquivo de uma URL e o salva, mostrando uma barra de progresso.
    Não baixa se o arquivo já existir.
    """
    if os.path.exists(save_path):
        print(f"-> Arquivo já existe: {os.path.basename(save_path)}")
        return

    try:
        response = requests.get(url, stream=True)
        
        if response.status_code == 200:
            total_size = int(response.headers.get('content-length', 0))
            block_size = 1024  # 1 Kilobyte
            
            with open(save_path, 'wb') as f, tqdm(
                desc=os.path.basename(save_path),
                total=total_size,
                unit='iB',
                unit_scale=True,
                unit_divisor=1024,
            ) as bar:
                for data in response.iter_content(block_size):
                    bar.update(len(data))
                    f.write(data)
            print(f"-> Download concluído: {os.path.basename(save_path)}")
        elif response.status_code == 404:
            print(f"-> AVISO: Arquivo não encontrado (404): {url}")
        else:
            print(f"-> ERRO: Status {response.status_code} ao tentar baixar: {url}")

    except requests.exceptions.RequestException as e:
        print(f"-> ERRO de conexão: {e}")


def main():
    """
    Função principal que orquestra a geração de URLs e o download.
    """
    # Garante que a pasta de destino exista
    os.makedirs(DESTINATION_FOLDER, exist_ok=True)
    
    # Gera o intervalo de datas mês a mês
    date_range = pd.date_range(
        start=f"{START_YEAR}-{START_MONTH}-01",
        end=f"{END_YEAR}-{END_MONTH}-01",
        freq='MS' # MS = Month Start
    )

    downloaded_annuals = set() # Para evitar downloads repetidos de arquivos anuais

    for date in date_range:
        year = date.year
        month = f"{date.month:02d}" # Formata o mês com zero à esquerda (ex: 09)

        print(f"\n--- Verificando arquivos para {year}-{month} ---")

        for dataset in DATASETS:
            folder = dataset["folder"]
            prefix = dataset["file_prefix"]
            
            if dataset["frequency"] == "monthly":
                filename = f"{prefix}_{year}_{month}.csv"
                url = f"{BASE_URL}{folder}/{filename}"
                save_path = os.path.join(DESTINATION_FOLDER, filename)
                download_file(url, save_path)
            
            elif dataset["frequency"] == "annual":
                # Lógica para baixar arquivos anuais apenas uma vez
                if year not in downloaded_annuals:
                    filename = f"{prefix}_{year}.csv"
                    url = f"{BASE_URL}{folder}/{filename}"
                    save_path = os.path.join(DESTINATION_FOLDER, filename)
                    download_file(url, save_path)
    
    # Adiciona o ano à lista de já baixados
    downloaded_annuals.add(year)

if __name__ == "__main__":
    main()