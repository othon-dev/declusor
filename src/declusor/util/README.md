# Utility Package

The **util** package provides a collection of stateless helper functions and utilities used throughout the application. These utilities perform common operations that are not specific to any single component.

> [!NOTE]
> This package provides cross-cutting concerns and is used throughout the application without creating circular dependencies.

## Purpose

This package offers reusable functionality across all layers of the application:

- **Data Encoding**: Functions for encoding and decoding data in various formats.
- **File Operations**: Utilities for loading, validating, and managing filesystem resources.
- **Network Helpers**: Functions for establishing and managing network connections.
- **Input Parsing**: Command argument parsing with type coercion and validation.
- **Security Validation**: Functions for validating file paths and extensions.
- **Client Formatting**: Utilities for preparing client scripts with variable substitution.

## Design Principles

1. **Statelessness**: All utility functions are pure and do not maintain state.
2. **Single Purpose**: Each function performs exactly one well-defined operation.
3. **Defensive Programming**: Functions validate inputs and provide clear error messages.
4. **Type Safety**: Functions use type hints and handle type conversions explicitly.
5. **Minimal Dependencies**: Depends only on `config` for exceptions and constants.

## Usage Guidelines

- Import utilities directly where needed rather than creating wrapper layers.
- Prefer composition of utilities over modification.
- Report errors through exceptions defined in the `config` package.
- Maintain backward compatibility when modifying utility signatures.
