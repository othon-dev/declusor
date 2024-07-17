def escape_single_quotes(value: str) -> str:
    return value.replace("\\", "\\\\").replace("'", "\\'")


def escape_double_quotes(value: str) -> str:
    return value.replace("\\", "\\\\").replace("'", '\\"')


def format_bash_function(
    function: str, *args: str, use_double_quotes: bool = False
) -> str:

    escaped_args = []

    for arg in args:
        if use_double_quotes:
            escaped_args.append('"{}"'.format(escape_double_quotes(arg)))
        else:
            escaped_args.append("'{}'".format(escape_single_quotes(arg)))

    return f"{function} {{}}".format(" ".join(escaped_args))
