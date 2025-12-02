#!/bin/bash
# -----------------------------------------------------------------------------
# Checks for the presence of useful networking and development tools on the
# system.
# -----------------------------------------------------------------------------

# Useful Tools
for tool in nc netcat ncat telnet socat gcc nmap wget curl tcpdump ftp; do
    which "$tool"
done 2>/dev/null
