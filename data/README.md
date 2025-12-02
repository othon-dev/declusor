# Declusor Script Collection

The scripts in this collection are designed to be **standalone**, **stealthy**, and **professional**. They do not rely on external libraries or custom helper functions, ensuring maximum portability and ease of use during red team engagements.

## Purpose

To establish a scalable, professional, and "future-proof" directory structure for the `data/` directory within the `declusor` project. This structure aims to support multi-platform capabilities, separate code from static assets, and align with industry-standard offensive security taxonomies (MITRE ATT&CK).

## Design Principles

### 1. Independence

- **Zero Dependencies**: Scripts run using standard system binaries (bash, awk, grep, find, etc.).
- **Single File**: Each script is a self-contained unit that can be uploaded and executed individually.

### 2. Raw & Pipeable Output

- **No Noise**: Status messages, banners, and decorative headers are removed from stdout.
- **Machine Readable**: Output is formatted to be easily parsed by other tools or piped into files.
- **Error Handling**: Errors are generally suppressed (`2>/dev/null`) to maintain operational stealth, unless critical for the operator.

### 3. Professional Standards

- **Standard Headers**: Every script includes a standardized header block describing its purpose.
- **Clean Code**: Logic is simplified and organized for readability and maintainability.

## Structure

The current structure organizes `data/` into functional zones:

```text
data/
├── assets/                 # Static, non-executable resources
│   ├── wordlists/          # Usernames, passwords, fuzzing lists
│   ├── binaries/           # Static binaries (e.g., nmap, socat, busybox)
│   └── templates/          # Configuration templates (e.g., malicious service files)
│
├── modules/                # Operational scripts and tools
│   ├── linux/              # Linux-specific implementations (Bash/Sh)
│   │   ├── collection/     # Data staging, archiving, looting
│   │   ├── cred_access/    # Credential harvesting
│   │   ├── discovery/      # System/Network enumeration
│   │   ├── evasion/        # Defense evasion, anti-forensics
│   │   ├── lateral/        # Lateral movement, pivoting
│   │   ├── persistence/    # Persistence mechanisms
│   │   └── privesc/        # Privilege escalation checks
│   │
│   ├── windows/            # Future expansion for PowerShell/Batch
│   │   └── ...
│   │
│   └── multi/              # Cross-platform scripts (Python, Go, etc.)
│
└── lib/                    # Shared internal libraries
```

## Benefits

1.  **Scalability**: Easily add `windows`, `macos`, or `cloud` directories without cluttering the root.
2.  **Clarity**: "Modules" implies a pluggable capability, fitting the agentic nature of `declusor`.
3.  **Standardization**: Categories like `discovery` and `cred_access` align with MITRE ATT&CK, making it intuitive for security practitioners.
4.  **Asset Management**: `assets/` provides a dedicated home for binary blobs and lists, keeping the code directories clean.
