#!/bin/bash

# Check if environment and action are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Please provide action (init/plan/apply/destroy) and environment (dev/staging/prod)."
    exit 1
fi

# Variables for action and environment
ACTION=$1
ENVIRONMENT=$2
WORKSPACE=$(terraform workspace show)
FOLDER_NAME=$(basename "$PWD")  # Get the current directory name as folder/module name
BUCKET="krupakaryasa"
# Generate the state key using folder name and workspace
STATE_KEY="${ENVIRONMENT}/${FOLDER_NAME}/${WORKSPACE}/terraform.tfstate"

# Generate the backend.tf file
cat > backend.tf <<EOT
terraform {
  backend "s3" {
    bucket = "krupakaryasa"
    key     = "${STATE_KEY}"
    region  = "ap-south-1"
  }
}
EOT

# Run the Terraform init command to configure backend
if [ "$ACTION" == "init" ]; then
    terraform init -backend-config="bucket=${BUCKET}" -backend-config="key=${STATE_KEY}" -backend-config="region=ap-south-1" -reconfigure
    
elif [ "$ACTION" == "plan" ]; then
    terraform plan -var="environment=${ENVIRONMENT}"
    
elif [ "$ACTION" == "apply" ]; then
    terraform apply -auto-approve -var="environment=${ENVIRONMENT}"
    
elif [ "$ACTION" == "destroy" ]; then
    # Preview the resources to be destroyed without generating tfplan file
    echo "Previewing resources to be destroyed..."
    terraform plan -destroy -var="environment=${ENVIRONMENT}"
    # Check the exit code from terraform destroy command
    sleep 50
    # Automatically approve destruction without prompt
    echo "Destroying resources..."
    terraform destroy -auto-approve -var="environment=${ENVIRONMENT}"
    
else
    echo "Invalid action. Please provide init/plan/apply/destroy."
    exit 1
fi

# Clean up backend.tf file
rm backend.tf
