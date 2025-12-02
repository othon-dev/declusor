#!/bin/bash
# -----------------------------------------------------------------------------
# Checks for common EDR/AV processes, kernel modules, and configuration files.
# -----------------------------------------------------------------------------

EDR_KEYWORDS="carbon|crowdstrike|cylance|sentinel|defender|symantec|mcafee|kaspersky|sophos|trendmicro|eset|bitdefender|fireeye|tanium|cb-defense|falcon|elastic"

# Running Processes
ps -aux 2>/dev/null | grep -iE "$EDR_KEYWORDS" | grep -v grep

# Loaded Kernel Modules
lsmod 2>/dev/null | grep -iE "$EDR_KEYWORDS"

# Configuration Files
find /etc /opt /usr/local -maxdepth 2 -name "*agent*" -o -name "*sensor*" 2>/dev/null | grep -iE "$EDR_KEYWORDS"
