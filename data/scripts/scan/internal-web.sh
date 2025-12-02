# Internal Web Server Discovery
# Usage: load scan/internal_web.sh

print_header "Scan: Internal Web Servers"

# Get local subnet (same logic as network_sweep)
subnet=$(ip -o -f inet addr show | awk '/scope global/ {print $4}' | head -n 1 | cut -d/ -f1 | cut -d. -f1-3)

if [ -z "$subnet" ]; then
    print_error "Could not determine subnet."
else
    print_with_label "Scanning common web ports on $subnet.0/24..."
    
    # Common web ports
    PORTS="80 443 8000 8080 8443"
    
    for i in {1..254}; do
        target="$subnet.$i"
        for port in $PORTS; do
            # Timeout 1s, try to connect
            (timeout 1 bash -c "</dev/tcp/$target/$port" && echo "http://$target:$port OPEN") 2>/dev/null &
        done
    done
    wait
fi
