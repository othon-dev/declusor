# Software Enumeration
# Usage: load enum/software.sh

# check for common compilers and interpreters
( for tool in gcc g++ python python3 perl ruby php java go rustc node npm; do command -v "$tool"; done ) 2> /dev/null | print_with_label "compilers & interpreters"

# check for security tools
( for tool in nmap nc netcat ncat socat tcpdump wireshark tshark gdb strace ltrace; do command -v "$tool"; done ) 2> /dev/null | print_with_label "security tools"

# list installed packages (debian/ubuntu)
command -v dpkg >/dev/null 2>&1 && (dpkg -l | grep -E "^ii" | awk '{print $2, $3}' | head -n 20) 2> /dev/null | print_with_label "installed packages (top 20)"; fi

# list installed packages (redhat/centos)
command -v rpm >/dev/null 2>&1 && (rpm -qa | head -n 20) 2> /dev/null | print_with_label "installed packages (top 20)"
