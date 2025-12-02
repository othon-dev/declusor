# Simple Ping Sweep
# Usage: load enum/network_sweep.sh

print_header "Network Sweep"

# get the first non-loopback interface's subnet
subnet=$(ip -o -f inet addr show | awk '/scope global/ {print $4}' | head -n 1 | cut -d/ -f1 | cut -d. -f1-3)

if [ -z "$subnet" ]; then
    print_error "Could not determine subnet."
else
    print_with_label "Scanning subnet $subnet.0/24..."

    for i in {1..254}; do
        (ping -c 1 -W 1 $subnet.$i > /dev/null && echo "$subnet.$i is up") &
    done
    
    wait
fi
