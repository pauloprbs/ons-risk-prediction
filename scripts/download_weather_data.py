import os
import sys
import warnings
from pathlib import Path
from typing import List, Optional, Tuple

import pandas as pd
import requests

# --- INTEGRAÇÃO COM A CONFIGURAÇÃO DO PROJETO ---
# Adiciona a pasta raiz ao path para que possamos encontrar o config.py
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
try:
    from config import START_YEAR, END_YEAR, END_MONTH
    print("Arquivo de configuração (config.py) lido com sucesso.")
except ImportError:
    print("ERRO: Arquivo config.py não encontrado. Usando datas padrão.")
    START_YEAR, END_YEAR, END_MONTH = 2022, 2025, 10
# ------------------------------------------------


def fetch_power_nasa(
    out_dir: Path,
    overwrite: bool = False,
    pontos: Optional[List[Tuple[float, float]]] = None,
    inicio: str = "2018-01-01",
    fim: Optional[str] = None,
) -> Optional[Path]:
    """Baixa meteorologia diária via NASA POWER e salva `clima_go_diario.csv`.

    Args:
      out_dir (Path): Diretório de saída.
      overwrite (bool): Se True, sobrescreve arquivo existente.
      pontos (list[tuple[float,float]]|None): Lista (lat,lon) para média espacial.
      inicio (str): Data inicial (YYYY-MM-DD).
      fim (str|None): Data final (YYYY-MM-DD); padrão = hoje.

    Returns:
      Path|None: Caminho do CSV gerado ou None se falhar.
    """
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / "clima_go_diario.csv"
    if out_path.exists() and not overwrite:
        print(f"Arquivo de clima já existe em: {out_path}")
        return out_path

    if pontos is None:
        # Grade de 4 pontos representativos sobre o estado de Goiás
        print("Usando pontos geográficos padrão para Goiás.")
        pontos = [(-16.7, -49.3), (-15.9, -48.2), (-18.0, -49.7), (-13.6, -46.9)]

    if fim is None:
        fim = pd.Timestamp.today().strftime("%Y-%m-%d")

    def baixa(lat: float, lon: float) -> Optional[pd.DataFrame]:
        """Função interna para baixar dados de um único ponto."""
        print(f"Buscando dados para o ponto (lat={lat}, lon={lon})...")
        base_url = "https://power.larc.nasa.gov/api/temporal/daily/point"
        params = {
            "parameters": "ALLSKY_SFC_SW_DWN,T2M,PRECTOTCORR",
            "community": "RE",
            "longitude": lon,
            "latitude": lat,
            "start": inicio.replace('-', ''),
            "end": fim.replace('-', ''),
            "format": "JSON"
        }
        try:
            r = requests.get(base_url, params=params, timeout=60)
            r.raise_for_status()
            j = r.json()["properties"]["parameter"]
            df = pd.DataFrame(
                {
                    "data": pd.to_datetime(pd.Series(j["ALLSKY_SFC_SW_DWN"]).index, format='%Y%m%d'),
                    "ghi": list(j["ALLSKY_SFC_SW_DWN"].values()),
                    "temp2m_c": list(j["T2M"].values()),
                    "precipitacao_mm": list(j["PRECTOTCORR"].values()),
                }
            )
            # A API da NASA retorna -999 para valores ausentes
            df.replace(-999, pd.NA, inplace=True)
            return df
        except requests.exceptions.RequestException as e:
            warnings.warn(f"Falha ao baixar dados do ponto ({lat}, {lon}). Erro: {e}")
            return None

    dfs = [df for ponto in pontos if (df := baixa(ponto[0], ponto[1])) is not None]

    if not dfs:
        warnings.warn("Nenhum dado meteorológico pôde ser baixado.")
        return None
    
    # Média dos dados de todos os pontos
    df_final = pd.concat(dfs).groupby('data').mean().reset_index()
    
    # Preenche possíveis valores ausentes com o valor do dia anterior
    df_final.ffill(inplace=True)

    df_final.to_csv(out_path, index=False)
    return out_path


if __name__ == "__main__":
    # --- BLOCO PRINCIPAL DE EXECUÇÃO ---

    # 1. Define o caminho de saída de forma robusta
    # Pega o caminho do script -> sobe um nível (para a raiz do projeto) -> entra em data/raw
    output_directory = Path(__file__).resolve().parent.parent / "data" / "raw"

    # 2. Define o período de tempo usando as datas do config.py
    start_date_str = f"{START_YEAR}-01-01"
    end_date_str = pd.Timestamp.today().strftime("%Y-%m-%d") # Sempre busca até a data de hoje

    print("--- Iniciando Download de Dados Meteorológicos da NASA POWER ---")
    print(f"Período: de {start_date_str} até hoje")
    print(f"Salvando em: {output_directory}")

    # 3. Chama a função de download
    resultado_path = fetch_power_nasa(
        out_dir=output_directory,
        inicio=start_date_str,
        fim=end_date_str,
        overwrite=True # Sobrescreve o arquivo para garantir que esteja sempre atualizado
    )

    if resultado_path:
        print(f"\n[SUCESSO] Dados de meteorologia salvos em: {resultado_path}")
    else:
        print("\n[FALHA] Não foi possível baixar os dados de meteorologia.")