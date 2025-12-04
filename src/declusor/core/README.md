# Core Package

The **core** package contains the fundamental runtime components that power the application's execution. It provides the essential infrastructure for user interaction, command routing, session management, and I/O operations.

## Purpose

This package forms the operational backbone of the application:

- **User Interface**: Console handling for input/output operations with readline integration.
- **Command Routing**: Dynamic dispatch of user commands to appropriate controller handlers.
- **Session Management**: Asynchronous communication channels with remote targets.
- **Argument Parsing**: Custom parser implementations for processing command arguments.
- **Interactive Prompt**: The main event loop that drives user interaction.

## Design Principles

1. **Interface Compliance**: Core implementations adhere to contracts defined in the `interface` package.
2. **Asynchronous Architecture**: All I/O-bound operations are implemented asynchronously.
3. **Separation of Concerns**: Each component handles a distinct aspect of the runtime.
4. **Extensibility**: The router and session abstractions support future protocol extensions.
