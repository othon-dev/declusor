#!/bin/bash
# -----------------------------------------------------------------------------
# Enumerates network configurations, connections, and routing tables.
# -----------------------------------------------------------------------------

# Network Addresses (Interface, Flags, IPs)
ip addr 2>/dev/null | grep -e 'link' -e 'inet' -e 'inet6' -e '[0-9]:' | cut -d ' ' -f 1,2,5,6

# DNS Nameservers
grep "^[^#;]" /etc/resolv.conf 2>/dev/null | grep nameserver

# ARP Table
(arp -a || ip neighbour) 2>/dev/null

# Routing Table
(route -n || ip route) 2>/dev/null

# Listening Services
(netstat -tunlp || ss -tunpl) 2>/dev/null | (column -t 2>/dev/null || cat)

# Active Connections
(netstat -antup || ss -antup) 2>/dev/null | grep ESTABLISHED | (column -t 2>/dev/null || cat)
