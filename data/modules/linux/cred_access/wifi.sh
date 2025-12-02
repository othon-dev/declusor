#!/bin/bash
# -----------------------------------------------------------------------------
# Extracts Wi-Fi credentials from NetworkManager and wpa_supplicant
# configurations.
# -----------------------------------------------------------------------------

# NetworkManager Connections
NM_PATH="/etc/NetworkManager/system-connections"
if [ -d "$NM_PATH" ]; then
    grep -rE '^psk=|^password=' "$NM_PATH" 2>/dev/null
fi

# WPA Supplicant
WPA_CONF="/etc/wpa_supplicant/wpa_supplicant.conf"
if [ -f "$WPA_CONF" ]; then
    cat "$WPA_CONF" 2>/dev/null | grep -E "ssid|psk"
fi
