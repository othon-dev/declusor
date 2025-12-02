# Basic Privilege Escalation Suggestions
# Usage: load privesc/suggest.sh

print_header "PrivEsc Suggestions"

# 1. Kernel Version
kernel=$(uname -r)
print_with_label "Kernel Version: $kernel"
# Very basic heuristic
if [[ "$kernel" == *"2.6"* ]]; then
    print_warning "Old Kernel (2.6.x) - DirtyCOW potential?"
elif [[ "$kernel" == *"3."* ]]; then
    print_warning "Old Kernel (3.x) - Many exploits exist."
fi

# 2. Writable /etc/passwd
if [ -w /etc/passwd ]; then
    print_success "CRITICAL: /etc/passwd is writable!"
fi

# 3. Writable /etc/shadow
if [ -w /etc/shadow ]; then
    print_success "CRITICAL: /etc/shadow is writable!"
fi

# 4. Sudo rights
print_with_label "Checking sudo -l (may prompt for password)..."
sudo -l -n 2>/dev/null 

# 5. Docker socket
if [ -w /var/run/docker.sock ]; then
    print_success "CRITICAL: Docker socket is writable! (Root via Docker)"
fi

# 6. LXD Group
if id | grep -q "lxd"; then
    print_success "User is in 'lxd' group! (Root via LXD)"
fi

# 7. Docker Group
if id | grep -q "docker"; then
    print_success "User is in 'docker' group! (Root via Docker)"
fi
