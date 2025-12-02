#!/bin/bash
# -----------------------------------------------------------------------------
# Enumerates writable files, home directories, and sensitive configuration files.
# -----------------------------------------------------------------------------

# Writable Files (excluding current user)
# Format: Permissions;Owner:Group;Path
find / -writable ! -user $(whoami) -type f ! -path '/proc/*' ! -path '/sys/*' -printf '%M;%u:%g;%p\n' 2>/dev/null | column -t -s ';' 2>/dev/null

# Writable Directories (maxdepth 3, excluding common system dirs)
find / -maxdepth 3 -type d -writable 2>/dev/null -printf '%M;%u:%g;%p\n' | grep -vE "^/proc|^/sys|^/run|^/dev" | column -t -s ';' 2>/dev/null

# Home Directories
find /home -maxdepth 1 -printf '%M;%u:%g;%p\n' 2>/dev/null | column -t -s ';' 2>/dev/null

# User's Crontab
crontab -l 2>/dev/null

# Key Files (SSH keys, etc.)
find /home -type f \( -name authorized_keys -o -name '*id_dsa*' -o -name '*id_ecdsa*' -o -name '*id_ed25519*' -o -name '*id_rsa*' -o -name '*.key' -o -name '*.pub' \) -printf '%M;%u:%g;%p\n' 2>/dev/null | column -t -s ';' 2>/dev/null

# Sensitive Config Directories/Files in /etc
find /etc \( -type f -o -type d \) \( -name 'init*' -o -name 'cron*' -o -name 'anacrontab' -o -name 'sudoers' -o -name 'exports' \) -printf '%M;%u:%g;%p\n' 2>/dev/null | column -t -s ';' 2>/dev/null

# Cron Files
find /var/spool/cron /etc/cron* -type f -printf '%M;%u:%g;%p\n' 2>/dev/null | column -t -s ';' 2>/dev/null
