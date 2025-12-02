#!/bin/bash
# -----------------------------------------------------------------------------
# Searches for files with capabilities set, which can lead to privilege
# escalation.
# -----------------------------------------------------------------------------

if command -v getcap >/dev/null 2>&1; then
    getcap -r / 2>/dev/null
else
    echo "[-] 'getcap' command not found."
fi

# Interesting Capabilities Reference:
# - cap_setuid+ep (Like SUID)
# - cap_net_bind_service+ep (Bind low ports)
# - cap_net_raw+ep (Packet sniffing)
# - cap_dac_read_search+ep (Read any file)
