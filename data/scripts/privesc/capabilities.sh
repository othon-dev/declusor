# Enumerating File Capabilities
# Usage: load privesc/capabilities.sh

print_header "PrivEsc: File Capabilities"

if command_exists getcap; then
    print_with_label "Searching for files with capabilities..."
    # Recursive search, hiding errors
    getcap -r / 2>/dev/null | print_with_label "Capabilities Found"
else
    print_error "'getcap' command not found."
fi

# Explanation of dangerous capabilities
print_with_label "Interesting Capabilities to look for:"

echo " - cap_setuid+ep (Like SUID)"
echo " - cap_net_bind_service+ep (Bind low ports)"
echo " - cap_net_raw+ep (Packet sniffing)"
echo " - cap_dac_read_search+ep (Read any file)"
