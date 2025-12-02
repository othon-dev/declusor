#!/bin/bash
# -----------------------------------------------------------------------------
# Searches for SSH private keys, configuration files, known_hosts, and active
# SSH agents.
# -----------------------------------------------------------------------------

# Private Keys
find / -name "id_rsa" -o -name "id_dsa" -o -name "id_ecdsa" -o -name "*.pem" 2>/dev/null

# SSH Configs
find / -name "ssh_config" -o -name "config" 2>/dev/null | grep ".ssh" | while read -r config; do
    echo "Found Config: $config"
    grep -E "Host |HostName|User|IdentityFile" "$config" | head -n 5
done

# Known Hosts
find / -name "known_hosts" 2>/dev/null | while read -r kh; do
    echo "Found known_hosts: $kh"
    cat "$kh" | awk '{print $1}' | cut -d, -f1 | sort -u
done

# SSH Agent
if [ -n "$SSH_AUTH_SOCK" ]; then
    echo "SSH Agent detected: $SSH_AUTH_SOCK"
    ssh-add -l 2>/dev/null
fi
