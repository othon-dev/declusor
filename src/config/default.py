from os.path import join, realpath
from sys import path

ROOT_DIR = realpath(path[0])
DATA_DIR = realpath(join(ROOT_DIR, "data"))

CLIENTS_DIR = realpath(join(ROOT_DIR, "clients"))
PAYLOAD_DIR = realpath(join(DATA_DIR, "payloads"))
LIBRARY_DIR = realpath(join(DATA_DIR, "lib"))

CLIENT = "bash.sh"

SRV_ACK = b"\xba\xdc\x00\xff\xee"
CLT_ACK = b"\x00"
