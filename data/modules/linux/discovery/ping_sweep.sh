#!/bin/bash
# -----------------------------------------------------------------------------
# Performs a ping sweep on the local subnet to identify active hosts.
# -----------------------------------------------------------------------------

# Get local subnet
subnet=$(ip -o -f inet addr show | awk '/scope global/ {print $4}' | head -n 1 | cut -d/ -f1 | cut -d. -f1-3)

if [ -z "$subnet" ]; then
    echo "[-] Could not determine subnet."
else
    for i in {1..254}; do
        (ping -c 1 -W 1 $subnet.$i > /dev/null && echo "$subnet.$i is up") &
    done
    wait
fi
