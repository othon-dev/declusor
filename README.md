# `declusor`

This repository contains a versatile payload delivery handler implemented in Python and Bash. It is designed to manage the delivery of Bash script payloads to Linux machines.

## Installation

First, download the package and move to its directory:

```
$ git clone https://github.com/othonhugo/declusor.git
$ cd declusor/
```

Upgrade `pip` to the latest version:

```
$ pip install --upgrade pip
```

Install the package and its required dependencies:

```
$ pip install .
```

Execute the `declusor.py` script to verify it works correctly:

```
$ python3 ./declusor.py 
```

You are expecting a message like this:

```
usage: declusor [-h] host port
declusor: error: the following arguments are required: host, port
```

If desired, create a shortcut in the `/usr/local/bin` directory:

```
$ sudo ln -s $(readlink -f declusor.py) /usr/local/bin/declusor
$ chmod 700 declusor.py
```

Finally, verify that it's working properly:

```
$ declusor
usage: declusor [-h] host port
declusor: error: the following arguments are required: host, port
```

## Usage Instructions

`declusor` is designed to run as a server, waiting for a client connection. Provide the `host` and `port` parameters to create a service:

```
$ declusor 127.0.0.1 4444
```

After that, you will receive a Bash script to execute on the target host. Once executed, the target host will establish a connection with the `declusor` server.

Use the `help` command to see all available features:

```
[declusor] help
load    : Load and execute a payload file on the target host.
command : Execute a single command on the target host.
shell   : Open an interactive shell session with the target host.
upload  : Upload a file to the target host.
execute : Upload and execute a file on the target host.
help    : Display usage information for available commands.
exit    : Log out from the current terminal session
[declusor] 
```

Here is an example of usage:

```
[declusor] command
error: the following arguments are required: command
[declusor] command whoami
user
```

You can create and run your own Bash payloads on the target machine:

```
[declusor] load info/tools.sh

USEFUL TOOLS
------------
/usr/bin/gcc
/usr/bin/wget
/usr/bin/curl
```

## Customizing and Extending Payloads

To make the most of `declusor`, you should construct unique payloads or edit the available ones. To do this, check out the `data` directory, which contains `lib` and `payloads` folders.

- **lib**: Contains scripts that will be sent to the target immediately after the connection is established. These scripts are meant to be persisted in the target's memory. Once executed, the target will "remember" these subroutines, allowing them to be used in conjunction with your payloads.

- **payloads**: Contains scripts that are meant to be executed by the target, with their output sent back to your server (your prompt). The `load` command will automatically search for files and directories in this folder.

For instance, there is a function called `print_with_label` in the `lib/output.sh` file. Initially, the target will receive and execute this code, enabling it to remember the function. Subsequently, any payload can use this function without needing to import it.

```
whoami | print_with_label "whoami"
```

If that payload is located at `payloads/whoami.sh`, you can send it to the target and receive an output with the following command:

```
[declusor] load whoami.sh

WHOAMI
------
user
```