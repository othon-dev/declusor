# Cloud Metadata Service Enumeration
# Usage: load recon/cloud-metadata.sh

print_header "Recon: Cloud Metadata"

# AWS / GCP / Azure common metadata IP
METADATA_IP="169.254.169.254"

# Timeout for curl
TIMEOUT=2

print_with_label "Checking for Cloud Metadata Service ($METADATA_IP)..."

if ping -c 1 -W 1 "$METADATA_IP" >/dev/null 2>&1; then
    print_success "Metadata service appears reachable!"
    
    # AWS
    print_with_label "Attempting AWS Metadata..."
    curl -s --max-time $TIMEOUT "http://$METADATA_IP/latest/meta-data/" | head -n 10 | print_with_label "AWS Metadata Root"
    
    print_with_label "Checking AWS IAM Credentials..."
    curl -s --max-time $TIMEOUT "http://$METADATA_IP/latest/meta-data/iam/security-credentials/" | while read role; do
        echo "Role: $role"
        curl -s --max-time $TIMEOUT "http://$METADATA_IP/latest/meta-data/iam/security-credentials/$role"
    done

    # GCP
    print_with_label "Attempting GCP Metadata..."
    curl -s --max-time $TIMEOUT -H "Metadata-Flavor: Google" "http://$METADATA_IP/computeMetadata/v1/instance/service-accounts/default/token" | print_with_label "GCP Token"

    # Azure
    print_with_label "Attempting Azure Metadata..."
    curl -s --max-time $TIMEOUT -H "Metadata: true" "http://$METADATA_IP/metadata/instance?api-version=2021-02-01" | print_with_label "Azure Instance Metadata"

else
    print_error "Metadata service ($METADATA_IP) not reachable."
fi
