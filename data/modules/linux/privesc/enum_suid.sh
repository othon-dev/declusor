#!/bin/bash
# -----------------------------------------------------------------------------
# Enumerates SUID and SUID-root files.
# -----------------------------------------------------------------------------

# SUID Files
find / -perm -4000 -type f 2>/dev/null -printf '%M;%u:%g;%p\n' | column -t -s ';' 2>/dev/null

# SUID-root Files in /usr/bin and /usr/lib
find /usr/bin /usr/lib -perm /4000 -user root -printf '%M;%u:%g;%p\n' 2>/dev/null | column -t -s ';' 2>/dev/null
