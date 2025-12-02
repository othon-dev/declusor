# Check for Common EDR/AV Processes and Drivers
# Usage: load evasion/check_edr.sh

print_header "EDR/AV Reconnaissance"

# List of common EDR/AV keywords
EDR_KEYWORDS="carbon|crowdstrike|cylance|sentinel|defender|symantec|mcafee|kaspersky|sophos|trendmicro|eset|bitdefender|fireeye|tanium|cb-defense|falcon|elastic"

print_with_label "Checking running processes for EDR/AV..."
( ps -aux | grep -iE "$EDR_KEYWORDS" | grep -v grep ) 2> /dev/null | print_with_label "Detected EDR Processes"

print_with_label "Checking loaded kernel modules for EDR/AV..."
( lsmod | grep -iE "$EDR_KEYWORDS" ) 2> /dev/null | print_with_label "Detected EDR Kernel Modules"

print_with_label "Checking for EDR/AV configuration files..."
( find /etc /opt /usr/local -maxdepth 2 -name "*agent*" -o -name "*sensor*" 2>/dev/null | grep -iE "$EDR_KEYWORDS" ) 2> /dev/null | print_with_label "Potential EDR Config Files"
