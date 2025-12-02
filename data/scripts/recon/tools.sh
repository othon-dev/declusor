# Tools Enumeration
# Usage: load enum/tools.sh

# list useful tools
( for tool in nc netcat ncat telnet socat gcc nmap wget curl tcpdump ftp; do which "$tool"; done ) 2> /dev/null | print_with_label 'useful tools'