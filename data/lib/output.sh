_FIND_PRINTF_PATTERN='%-12M %u:%-10g %p\n'
_FIND_PRINTF_SEPARATOR_PATTERN='%M;%u:%g;%p\n'

# Print success message (green)
function print_success() {
    echo -e "\033[0;32m[+] $1\033[0m"
}

# Print error message (red)
function print_error() {
    echo -e "\033[0;31m[-] $1\033[0m"
}

# Print warning message (yellow)
function print_warning() {
    echo -e "\033[0;33m[!] $1\033[0m"
}

# Print a section header
function print_header() {
    echo -e "\n\033[1;34m=== $1 ===\033[0m"
}

# Print a labeled block of text
function print_with_label() {
    title="$1"

    while IFS= read -r line; do
        if [ ${title+x} ]; then
            echo
            echo $title | tr '[:lower:]' '[:upper:]'
            echo $(head -c ${#title} < /dev/zero | tr '\0' '-')

            unset title
        fi

        echo "$line"
    done
}
