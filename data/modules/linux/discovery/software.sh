#!/bin/bash
# -----------------------------------------------------------------------------
# Checks for installed compilers, interpreters, security tools, and packages.
# -----------------------------------------------------------------------------

# Common Compilers & Interpreters
for tool in gcc g++ python python3 perl ruby php java go rustc node npm; do
    command -v "$tool"
done 2>/dev/null

# Security Tools
for tool in nmap nc netcat ncat socat tcpdump wireshark tshark gdb strace ltrace; do
    command -v "$tool"
done 2>/dev/null

# Installed Packages (Debian/Ubuntu) - Top 20
if command -v dpkg >/dev/null 2>&1; then
    dpkg -l | grep -E "^ii" | awk '{print $2, $3}' | head -n 20
fi 2>/dev/null

# Installed Packages (RedHat/CentOS) - Top 20
if command -v rpm >/dev/null 2>&1; then
    rpm -qa | head -n 20
fi 2>/dev/null
