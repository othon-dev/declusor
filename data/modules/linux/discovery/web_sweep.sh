#!/bin/bash
# -----------------------------------------------------------------------------
# Scans the local subnet for common web ports (80, 443, 8000, 8080, 8443).
# -----------------------------------------------------------------------------

# Get local subnet
subnet=$(ip -o -f inet addr show | awk '/scope global/ {print $4}' | head -n 1 | cut -d/ -f1 | cut -d. -f1-3)

if [ -z "$subnet" ]; then
    echo "[-] Could not determine subnet."
else
    # Common web ports
    PORTS="80 443 8000 8080 8443"
    
    for i in {1..254}; do
        target="$subnet.$i"
        for port in $PORTS; do
            # Timeout 1s, try to connect
            (timeout 1 bash -c "</dev/tcp/$target/$port" && echo "http://$target:$port OPEN") 2>/dev/null &
        done
    done
    wait
fi
