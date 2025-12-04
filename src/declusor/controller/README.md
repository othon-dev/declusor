# Controller Package

The **controller** package contains the request handlers that process user commands and orchestrate the appropriate responses. Controllers act as the intermediary layer between user input and command execution.

## Purpose

This package implements the Application Layer of the system, providing:

- **Request Handling**: Each controller function responds to a specific user command.
- **Input Processing**: Controllers parse and validate command arguments before execution.
- **Command Orchestration**: Controllers instantiate and execute the appropriate commands.
- **Response Management**: Controllers handle output from remote sessions and present it to the user.

## Design Principles

1. **Thin Controllers**: Controllers delegate business logic to command objects and utilities.
2. **Consistent Signatures**: All controller functions share a common signature for uniform routing.
3. **Error Propagation**: Controllers allow domain exceptions to propagate for centralized handling.
4. **Asynchronous Execution**: All controllers are asynchronous to support non-blocking I/O operations.

## Expected Behavior

Controller functions within this package should:

- Accept session, router, and command line arguments
- Parse command arguments using standard parsing utilities
- Validate inputs before proceeding with execution
- Instantiate and execute the appropriate command objects
- Process and display output received from sessions
- Propagate exceptions for centralized error handling

## Controller Lifecycle

1. Receive invocation from the router with session context and user input
2. Parse and validate command arguments
3. Perform any necessary pre-execution validation (e.g., file existence)
4. Create and execute the appropriate command
5. Process session responses and present output to the user
6. Return control to the prompt for the next command
