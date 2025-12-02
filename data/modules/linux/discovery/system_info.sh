#!/bin/bash
# -----------------------------------------------------------------------------
# Performs comprehensive system reconnaissance to gather details about the
# host, environment, processes, and storage.
# -----------------------------------------------------------------------------

# Basic System Info (Hostname, Kernel, Distro, Uptime)
hostname 2>/dev/null
uname -a 2>/dev/null
cat /etc/*release 2>/dev/null | head -n 1
uptime -p 2>/dev/null || uptime

# Environment Variables
env 2>/dev/null

# Running Processes (User, PID, Start Time, Command)
ps -aux 2>/dev/null | awk '{ printf "%-10s %-8s %-8s %s\n", $1, $2, $9, $11 }' | head -n 50

# PCI Buses & Devices
lspci 2>/dev/null

# Mounted Filesystems (excluding pseudo-filesystems)
mount 2>/dev/null | grep -vE "tmpfs|proc|sysfs|cgroup|devpts|mqueue|hugetlbfs|securityfs|debugfs"

# Disk Usage
df -h 2>/dev/null
