# Users Enumeration
# Usage: load enum/users.sh

# show current user info
( echo "User: $(whoami)"; id ) 2> /dev/null | print_with_label "current user"

# show current user's sudo nopasswd permissions
( sudo -l | grep 'NOPASSWD' | awk '{$1=$1;print}' ) 2> /dev/null | print_with_label "sudo nopasswd permissions"

# show last logged in users
( lastlog | grep -vE '\*\*.*\*\*' | cut -d $'\n' -f 2- ) | tail -n +2 | column -t | 2> /dev/null  print_with_label "last logged in users"

# show all users logged into the current system
( w -hs ) 2> /dev/null | print_with_label "users logged in"

# list all user accounts with login shell
( grep -E "/bin/bash|/bin/sh|/bin/zsh" /etc/passwd | cut -d: -f1 ) 2> /dev/null | print_with_label "users with shell"

# list all super user accounts
( grep -Po '^sudo.+:\K.*$' /etc/group grep -Po '^wheel.+:\K.*$' /etc/group grep -Po '^root.+:\K.*$' /etc/group ) 2> /dev/null | tr ',' '\n' | sort -u | print_with_label "super users"
