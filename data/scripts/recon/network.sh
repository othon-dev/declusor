# Network Enumeration
# Usage: load enum/network.sh

# list network addresses
(ip addr | grep -e 'link' -e 'inet' -e 'inet6' -e '[0-9]:' | cut -d ' ' -f 1,2,5,6) 2> /dev/null | print_with_label 'network addresses'

# list DNS nameservers
(grep "^[^#;]" /etc/resolv.conf | grep nameserver) 2> /dev/null | print_with_label 'DNS nameservers'

# list ARP table
(arp -a || ip neighbour) 2> /dev/null | print_with_label 'ARP table'

# list routing table
(route -n || ip route) 2> /dev/null | print_with_label 'routing table'

# display listening services
(netstat -tunlp || ss -tunpl) 2> /dev/null | column -t | print_with_label 'listening services'

# display active connections
(netstat -antup || ss -antup) 2> /dev/null | grep ESTABLISHED | column -t | print_with_label 'active connections'
