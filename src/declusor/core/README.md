# Core Package

The **core** package contains the concrete implementations of the domain interfaces defined in the `interface` package. It provides the fundamental runtime components that power the application's execution.

## Purpose

This package forms the operational backbone of the application:

- **Interface Implementation**: Concrete implementations of all domain abstractions.
- **User Interface**: Console handling for input/output operations with readline integration.
- **Command Routing**: Dynamic dispatch of user commands to appropriate controller handlers.
- **Session Management**: Communication channels with remote targets using socket-based I/O.
- **Argument Parsing**: Custom parser implementations for processing command arguments.
- **Interactive Prompt**: The main event loop that drives user interaction.

## Design Principles

1. **Depends on Interface**: Core implementations depend on abstractions defined in the `interface` package.
2. **Interface Compliance**: All implementations adhere to contracts defined in the domain layer.
3. **Synchronous Architecture**: All I/O-bound operations use blocking sockets with configurable timeouts.
4. **Separation of Concerns**: Each component handles a distinct aspect of the runtime.
5. **Extensibility**: The router and session abstractions support future protocol extensions.
