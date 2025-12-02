#!/bin/bash
# -----------------------------------------------------------------------------
# Checks for basic privilege escalation vectors including kernel version,
# writable system files, sudo rights, and dangerous group memberships.
# -----------------------------------------------------------------------------

# Kernel Version
kernel=$(uname -r)
echo "Kernel Version: $kernel"

# Writable /etc/passwd
if [ -w /etc/passwd ]; then
    echo "[!] CRITICAL: /etc/passwd is writable!"
fi

# Writable /etc/shadow
if [ -w /etc/shadow ]; then
    echo "[!] CRITICAL: /etc/shadow is writable!"
fi

# Sudo rights (non-interactive)
sudo -l -n 2>/dev/null 

# Sudo NOPASSWD Permissions (Specific check)
sudo -l 2>/dev/null | grep 'NOPASSWD' | awk '{$1=$1;print}'

# Docker socket
if [ -w /var/run/docker.sock ]; then
    echo "[!] CRITICAL: Docker socket is writable! (Root via Docker)"
fi

# LXD Group
if id | grep -q "lxd"; then
    echo "[!] User is in 'lxd' group! (Root via LXD)"
fi

# Docker Group
if id | grep -q "docker"; then
    echo "[!] User is in 'docker' group! (Root via Docker)"
fi
