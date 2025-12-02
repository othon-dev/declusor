# System Enumeration
# Usage: load enum/system.sh

# basic system info
( echo "Hostname: $(hostname)"; echo "Kernel: $(uname -a)"; echo "Distro: $(cat /etc/*release 2>/dev/null | head -n 1)"; echo "Uptime: $(uptime -p)"; ) 2> /dev/null | print_with_label 'system info'

# environment variables
( env ) 2> /dev/null | print_with_label 'environment variables'

# list running processes
( ps -aux | awk '{ printf "%s %s %s %s\n", $1, $2, $9, $11 }' | column -t ) 2> /dev/null | print_with_label 'running processes'

# list PCI buses and connected devices
( lspci ) 2> /dev/null | print_with_label 'PCI buses & devices'

# list mounted filesystems
( mount | grep -v "tmpfs" | grep -v "proc" | grep -v "sysfs" ) 2> /dev/null | print_with_label 'mounted filesystems'

# disk space
( df -h ) 2> /dev/null | print_with_label 'disk usage'
