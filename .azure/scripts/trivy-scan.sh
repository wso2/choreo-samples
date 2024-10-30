#!/bin/bash

# Function to perform the Trivy scan
trivy_scan() {
  image=$1
  echo "[INFO] Scanning image: $image"
  
  # Run Trivy scan and output as a table with only critical vulnerabilities
  trivy image "$image" \
    --db-repository choreoanonymouspullable.azurecr.io/aquasecurity/trivy-db:2 \
    --java-db-repository choreoanonymouspullable.azurecr.io/aquasecurity/trivy-java-db:1 \
    --exit-code 1 --severity CRITICAL --no-progress --quiet --format table --scanners vuln
  
  scan_exit_code=$?

  # If Trivy finds critical vulnerabilities, display a more user-friendly error
  if [ $scan_exit_code -ne 0 ]; then
    echo ""
    echo "***********************************************************************************"
    echo "[ERROR] Critical vulnerabilities found in image: $image. Please address these issues."
    echo "***********************************************************************************"
    exit $scan_exit_code
  else
    echo "[SUCCESS] No critical vulnerabilities found in image: $image."
  fi
}

# Reading command line arguments
image=$1

# Running the Trivy scan function
trivy_scan "$image"
