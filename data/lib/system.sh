# Check if running as root
function is_root() {
    if [ "$EUID" -ne 0 ]; then
        return 1
    fi

    return 0
}

# Check if commands exist
function command_exists() {
    local cmd

    for cmd in "$@"; do
        command -v "$cmd" >/dev/null 2>&1 || return 1
    done

    return 0
}
