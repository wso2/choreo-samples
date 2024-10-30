#!/bin/bash

# Function to perform the Trivy scan
trivy_scan() {
  image=$1
  echo "[INFO] Scanning image: $image"
  
  if [[ "$push" == "true" ]]; then
    # If push is set to true, perform the scan with a specific configuration
    trivy image "$image" \
      --db-repository choreoanonymouspullable.azurecr.io/aquasecurity/trivy-db:2 \
      --java-db-repository choreoanonymouspullable.azurecr.io/aquasecurity/trivy-java-db:1 \
      --exit-code 1 --severity CRITICAL --no-progress --scanners vuln
  else
    # Echo the Trivy scan results to the console
    trivy image "$image" \
      --db-repository choreoanonymouspullable.azurecr.io/aquasecurity/trivy-db:2 \
      --java-db-repository choreoanonymouspullable.azurecr.io/aquasecurity/trivy-java-db:1 \
      --exit-code 1 --severity CRITICAL --no-progress --scanners vuln
  fi
}

# Reading command line arguments
image=$1
push=${2:-false}

# Running the Trivy scan function
trivy_scan "$image"
