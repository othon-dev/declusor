# Data Directory

The **data** directory contains the static resources and scripts that are deployed to or executed on remote targets. This directory serves as the repository for all payload content used by the application.

## Purpose

This directory provides the operational content for the application:

- **Client Scripts**: Connection scripts that initiate communication from target systems.
- **Library Scripts**: Foundational functions and utilities loaded onto targets upon connection.
- **Modules**: On-demand executable payloads organized by category for specific tasks.

## Structure

### `clients/`
Contains reverse shell client scripts that establish the initial connection from a target system back to the application. These scripts implement the communication protocol required for session establishment.

### `library/`
Contains utility functions that are automatically loaded onto the target upon successful connection. These functions provide the foundational capabilities that other payloads depend upon, such as file storage, data encoding, and script execution.

### `modules/`
Contains categorized payload scripts intended for on-demand execution. These scripts perform specific tasks and can be loaded dynamically based on operational requirements.

## Design Principles

1. **Minimal Dependencies**: Scripts rely only on utilities commonly available on target systems.
2. **Portability**: Scripts are written to function across different shell environments.
3. **Protocol Compliance**: All scripts implement the required acknowledgment protocol.
4. **Self-Contained**: Each script includes all necessary logic without external dependencies.

## Usage

- **Client** scripts are formatted at runtime with connection parameters
- **Library** scripts are transmitted automatically during session initialization
- **Module** scripts are sent on-demand via the load command

## Security Considerations

- Scripts in this directory may be transmitted to remote systems
- Content should be reviewed for unintended side effects
- Path validation prevents traversal outside designated directories
- File extension whitelisting restricts loadable file types

## Extensibility

New payloads can be added by:

1. Creating scripts in the appropriate subdirectory
2. Following the established protocol conventions
3. Using only the allowed file extensions
4. Testing functionality in controlled environments
