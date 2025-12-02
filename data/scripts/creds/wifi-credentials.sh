# Wifi Credentials Enumeration
# Usage: load creds/wifi-credentials.sh

print_header "Credentials: Wifi"

NM_PATH="/etc/NetworkManager/system-connections"

if [ -d "$NM_PATH" ]; then
    if [ -r "$NM_PATH" ]; then
        print_with_label "Reading NetworkManager Connections..."
        grep -rE '^psk=|^password=' "$NM_PATH" 2>/dev/null | print_with_label "Wifi Passwords"

    else
        if is_root; then
            print_with_label "Reading NetworkManager Connections (Root)..."
            grep -rE '^psk=|^password=' "$NM_PATH" 2>/dev/null | print_with_label "Wifi Passwords"
        else
            print_error "Cannot read $NM_PATH (Permission Denied). Try as root."
        fi
    fi
else
    print_warning "NetworkManager path not found: $NM_PATH"
fi

# WPA Supplicant
WPA_CONF="/etc/wpa_supplicant/wpa_supplicant.conf"

if [ -f "$WPA_CONF" ]; then
    if [ -r "$WPA_CONF" ]; then
        print_with_label "Reading wpa_supplicant.conf..."
        cat "$WPA_CONF" | grep -E "ssid|psk" | print_with_label "WPA Config"
    else
        print_error "Cannot read $WPA_CONF (Permission Denied)."
    fi
fi
