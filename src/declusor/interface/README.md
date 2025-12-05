# Interface Package (Domain Layer)

The **interface** package defines the abstract contracts that establish the boundaries between system components. It contains the abstract base classes and protocols that all implementations must adhere to. This is the **domain layer** of the application.

> [!NOTE]
> This package sits at the foundation of the dependency hierarchy, providing shared types and configuration.

## Purpose

This package provides the architectural foundation for the application:

- **Contract Definition**: Abstract interfaces that specify required behaviors without implementation details.
- **Dependency Inversion**: Enables high-level modules to depend on abstractions rather than concrete implementations.
- **Type Safety**: Provides type hints for static analysis and IDE support.
- **Documentation**: Interface methods serve as authoritative documentation for expected behaviors.
- **Domain Modeling**: Defines the core domain concepts and their interactions.

## Design Principles

1. **Pure Abstractions**: Interfaces contain no implementation logic—only method signatures and docstrings.
2. **Single Responsibility**: Each interface defines the contract for exactly one concern.
3. **Minimal Surface**: Interfaces expose only the methods required by their consumers.
4. **Liskov Substitution**: Any implementation of an interface must be substitutable for another.
5. **Zero Dependencies**: This package has no dependencies on other application packages.

## Usage Guidelines

- Implementations reside in the `core` package and must inherit from these interfaces.
- Type hints throughout the codebase should reference interfaces rather than concrete types.
- New functionality should consider whether an interface abstraction is warranted.
- Controllers and commands should depend on interfaces, not implementations.
