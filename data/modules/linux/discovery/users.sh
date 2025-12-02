#!/bin/bash
# -----------------------------------------------------------------------------
# Enumerates user information, including current user details, logged-in users,
# and accounts with shell access.
# -----------------------------------------------------------------------------

# Current User Info
echo "User: $(whoami 2>/dev/null)"
id 2>/dev/null

# Last Logged In Users
lastlog 2>/dev/null | grep -vE '\*\*.*\*\*' | tail -n +2 | column -t 2>/dev/null

# Currently Logged In Users
w -hs 2>/dev/null

# Users with Login Shell
grep -E "/bin/bash|/bin/sh|/bin/zsh" /etc/passwd 2>/dev/null | cut -d: -f1

# Super User Accounts (sudo/wheel/root groups)
grep -Po '^sudo.+:\K.*$' /etc/group 2>/dev/null | tr ',' '\n'
grep -Po '^wheel.+:\K.*$' /etc/group 2>/dev/null | tr ',' '\n'
grep -Po '^root.+:\K.*$' /etc/group 2>/dev/null | tr ',' '\n'
