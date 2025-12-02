# Declusor C2 Protocol (DCP) Specification

The Declusor C2 Protocol (DCP) is a lightweight, robust, and extensible communication standard designed for offensive security operations. It addresses the limitations of simple raw-text protocols by introducing message framing, type definitions, and support for structured data, while maintaining ease of implementation across diverse languages (Python, Go, Perl, Ruby, Bash).

## Design Principles

- **Robustness**: Uses Length-Prefix framing to prevent stream desynchronization and handle binary data (e.g., file uploads) safely.
- **Stealth**: Avoids cleartext command signatures on the wire. Supports pluggable encryption/encoding layers.
- **Extensibility**: Type-Length-Value (TLV) structure allows adding new message types (e.g., file transfer, socks proxy) without breaking existing clients.
- **Compatibility**: Designed to be implementable even in restricted environments (e.g., pure Bash with standard tools).

## Transport Layer

- **Default**: TCP Sockets.
- **Future Support**: HTTP/S, DNS Tunneling, WebSocket.
- **Encoding**: All payloads should be at minimum XOR-encoded or Base64-encoded to avoid simple string signature detection by IDS/IPS.

## Message Format

Messages are structured as **Frames**. Each frame consists of a **Header** and a **Payload**.

### Frame Structure

```text
+----------------+----------------+----------------+----------------+
|  Length (4B)   |    Type (1B)   |   Payload (N Bytes) ...         |
+----------------+----------------+----------------+----------------+
```

- **Length**: 4-byte unsigned integer (Big Endian). Represents the size of the *Payload* only.
- **Type**: 1-byte identifier for the message function.
- **Payload**: Variable length data determined by *Length*.

### Message Types

| Hex  | Name          | Direction | Description |
| :--- | :---          | :---      | :--- |
| **0x01** | `AUTH_HELLO`  | C -> S    | Initial handshake. Contains metadata (OS, User, Arch, PID). |
| **0x02** | `AUTH_ACK`    | S -> C    | Server accepts connection. |
| **0x10** | `CMD_EXEC`    | S -> C    | Command to be executed by the client. |
| **0x11** | `CMD_STDOUT`  | C -> S    | Standard output from a command. |
| **0x12** | `CMD_STDERR`  | C -> S    | Standard error from a command. |
| **0x13** | `CMD_EXIT`    | C -> S    | Exit code of the executed command. |
| **0x20** | `HEARTBEAT`   | Bidirectional | Keep-alive signal. |
| **0x99** | `TERM_SESSION`| Bidirectional | Close connection. |

## Session Lifecycle

### Handshake

1.  **Client Connects** to Server.
2.  **Client Sends `AUTH_HELLO` (0x01)**:
    *   Payload: JSON or Key-Value string (e.g., `user=root&os=linux&arch=x64`).
3.  **Server Verifies** and sends **`AUTH_ACK` (0x02)**.
    *   Payload: Empty or Session Configuration (e.g., heartbeat interval).

### Command Execution Loop

1.  **Server Sends `CMD_EXEC` (0x10)**:
    *   Payload: Command string (e.g., `whoami`).
2.  **Client Executes** command.
3.  **Client Streams Output**:
    *   Sends **`CMD_STDOUT` (0x11)** frames as data becomes available.
    *   Sends **`CMD_STDERR` (0x12)** frames for errors.
4.  **Client Finishes**:
    *   Sends **`CMD_EXIT` (0x13)** with the numeric exit code (e.g., `0`).

### Heartbeat

*   If no traffic occurs for `N` seconds, Client sends **`HEARTBEAT` (0x20)**.
*   Server responds with **`HEARTBEAT` (0x20)**.

## Implementation Guidelines

### Binary Handling in High-Level Languages (Python, Ruby, Perl)

Use built-in `struct` or `pack` libraries to handle the 4-byte Big Endian length header.

*   *Python*: `struct.pack('>I', length)`
*   *Perl/Ruby*: `pack('N', length)`

### Binary Handling in Shell (Bash)

For pure shell implementations where binary manipulation is difficult, a **Text-Mode Fallback** can be negotiated, or tools like `od`, `xxd`, or `printf` can be used:

*   *Read Header*: `read -N 5 header`
*   *Parse Length*: `od` or `hexdump` conversion.
*   *Write Header*: `printf "\x00\x00\x00\x0C\x10"`

### Security Considerations

*   **Encryption**: It is recommended to wrap the TCP socket in TLS.
*   **Obfuscation**: If TLS is unavailable, implement a rolling XOR layer on the Payload to prevent static signature detection.
