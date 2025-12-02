# Declusor Scripts

The primary objective is to refactor the offensive security script collection within the `declusor` project. The goal is to decouple these scripts from the central `declusor` library (specifically `data/lib`), transforming them into standalone, highly portable, and professional-grade tools suitable for red teaming engagements.

## Core Principles

### 1. Independence & Portability

- **Zero External Dependencies**: Scripts must not rely on `data/lib` or other non-standard files. They should be self-contained.
- **Standard Tools**: Rely on standard system binaries (e.g., `bash`, `awk`, `sed`, `grep`, `python3`) commonly found on target systems.
- **Single File Execution**: Each script should function as a single, deployable unit.

### 2. Professionalism & Stealth

- **Silent Operation**: Remove verbose "status" messages (e.g., "[-] Enumerating users...", "[*] Checking network...").
- **Clean Output**: Scripts should output only the requested data or raw results, facilitating piping and chaining with other tools.
- **Documentation**: Use professional English comments within the code to explain logic, rather than printing it to `stdout`.

### 3. Code Quality

- **Language**: All code, comments, and variable names must be in English.
- **Structure**: Use functions to organize logic, even in simple scripts.
- **Robustness**: Implement standard error handling (e.g., `2>/dev/null` for noise reduction) without cluttering the output.
- **Top-Grade Standards**: Adhere to best practices for security scripting (e.g., quoting variables, avoiding dangerous `eval` usage where possible).

## Workflow

1.  **Analyze**: Review existing scripts in `data/scripts/`.
2.  **Decouple**: Identify dependencies on `data/lib` (e.g., `print_with_label`, `print_success`).
3.  **Refactor**: Rewrite the script to include necessary logic inline or simplify the output format to remove the need for the helper.
4.  **Verify**: Ensure the script runs independently and produces clean, useful output.
