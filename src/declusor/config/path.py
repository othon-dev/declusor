from pathlib import Path

ROOT_DIR = Path(__file__).resolve()

for _ in range(4):
    ROOT_DIR = ROOT_DIR.parent

DATA_DIR = ROOT_DIR / "data"

CLIENTS_DIR = DATA_DIR / "clients"
SCRIPTS_DIR = DATA_DIR / "scripts"
LIBRARY_DIR = DATA_DIR / "lib"
