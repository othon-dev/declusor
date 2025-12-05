# Main Package

The **main** package contains the application entry points and service orchestration logic. It is responsible for bootstrapping the application and managing the high-level execution flow.

## Purpose

This package serves as the application's entry point and orchestrator:

- **Application Bootstrap**: Initializes all required components and establishes connections.
- **Service Lifecycle**: Manages the startup, execution, and shutdown sequences.
- **Dependency Injection**: Wires together core implementations and injects them where needed.
- **Component Wiring**: Connects controllers to the router and prepares the runtime environment.
- **Error Handling**: Provides top-level exception handling for unrecoverable errors.

## Design Principles

1. **Single Entry Point**: The application has one clearly defined starting point.
2. **Dependency on Core**: Main depends on core implementations, not the other way around.
3. **Graceful Degradation**: Errors during startup result in meaningful messages rather than stack traces.
4. **Clean Shutdown**: Resources are properly released during application termination.
5. **Minimal Logic**: Business logic resides in other packages; main handles only orchestration.
