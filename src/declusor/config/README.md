# Configuration Package

The **config** package provides the centralized configuration, constants, enumeration types, and exception definitions used throughout the application. It serves as the foundation for consistent behavior and error handling across all components.

## Purpose

This package establishes the core parameters and types that govern application behavior:

- **Application Settings**: Centralized configuration values including paths, timeouts, and protocol constants.
- **Path Management**: Base directory definitions for locating data files, scripts, and resources.
- **Exception Hierarchy**: A structured set of domain-specific exceptions enabling granular error handling.
- **Enumeration Types**: Type-safe enumerations for categorical values used across the application.

## Design Principles

1. **Centralization**: All configuration values are defined in a single location for maintainability.
2. **Immutability**: Configuration values are treated as constants and should not be modified at runtime.
3. **Type Safety**: Enumerations and typed exceptions prevent invalid states and improve code clarity.
4. **Semantic Exceptions**: Each exception type conveys specific meaning about the error condition.

## Relationship to Other Packages

- **Used by**: All other packages within the application
- **Dependencies**: Standard library only (no external dependencies)
