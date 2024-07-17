_FIND_PRINTF_PATTERN='%-12M %u:%-10g %p\n'
_FIND_PRINTF_SEPARATOR_PATTERN='%M;%u:%g;%p\n'

print_with_label() {
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