# Filesystem Enumeration
# Usage: load enum/filesystem.sh

# list writable files 
( find / -writable ! -user $(whoami) -type f ! -path '/proc/*' ! -path '/sys/*' -printf "$_FIND_PRINTF_SEPARATOR_PATTERN" ) 2> /dev/null | column -t -s ';' 2> /dev/null | print_with_label "writable files"

# list writable directories in common locations
( find / -maxdepth 3 -type d -writable 2>/dev/null -printf "$_FIND_PRINTF_SEPARATOR_PATTERN"  | grep -vE "^/proc|^/sys|^/run|^/dev" ) 2> /dev/null | print_with_label "writable directories"

# list world writable files
# ( find / -type f -perm -0002 2>/dev/null -printf "$_FIND_PRINTF_SEPARATOR_PATTERN" | grep -vE "^/proc|^/sys|^/run|^/dev" ) 2> /dev/null | print_with_label "world writable files"

# list SUID files
( find / -perm -4000 -type f 2>/dev/null -printf "$_FIND_PRINTF_SEPARATOR_PATTERN" ) 2> /dev/null | print_with_label "SUID files"

# list SUID-root files in /usr/bin and /usr/lib
( find /usr/bin /usr/lib -perm /4000 -user root -printf "$_FIND_PRINTF_SEPARATOR_PATTERN" ) 2> /dev/null | column -t -s ';' 2> /dev/null | print_with_label "SUID-root bins/libs"

# list home directories
( find /home -maxdepth 1 -printf "$_FIND_PRINTF_SEPARATOR_PATTERN" ) 2> /dev/null | column -t -s ';' 2> /dev/null | print_with_label "home directories"

# list user's crontab
( crontab -l ) 2> /dev/null | column -t -s ';' 2> /dev/null | print_with_label "user's crontab"

# search for key files
( find /home -type f \( -name authorized_keys -o -name '*id_dsa*' -o -name '*id_ecdsa*' -o -name '*id_ed25519*' -o -name '*id_rsa*' -o -name '*.key' -o -name '*.pub' \) -printf "$_FIND_PRINTF_SEPARATOR_PATTERN" ) 2> /dev/null | column -t -s ';' 2> /dev/null | print_with_label "key files"

# list sensitive /etc directories
( find /etc \( -type f -o -type d \) \(-name 'init*'-o -name 'cron*'-o -name 'anacrontab'-o -name 'sudoers'-o -name 'exports'\) -printf "$_FIND_PRINTF_SEPARATOR_PATTERN" ) 2> /dev/null | column -t -s ';' 2> /dev/null | print_with_label "config directories"

# list cron files
( find /var/spool/cron /etc/cron* -type f -printf "$_FIND_PRINTF_SEPARATOR_PATTERN" ) 2> /dev/null | column -t -s ';' 2> /dev/null | print_with_label "cron files"
