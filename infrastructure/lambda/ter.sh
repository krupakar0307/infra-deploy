#!/bin/bash
set -euo pipefail

# terrafrm action and environment are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <init|plan|apply|destroy> <environment>"
    exit 1
fi

ACTION=$1
ENVIRONMENT=$2
REGION="us-east-1"
FOLDER_NAME=$(basename "$PWD")  # Module name as folder name
BUCKET="expense-tracker-llm-s3-backend"
STATE_KEY="${FOLDER_NAME}/terraform.tfstate"  # No ENVIRONMENT here, workspace handles s3 path!

# generate backend.tf file
cat > backend.tf <<EOT
terraform {
  backend "s3" {
    bucket = "${BUCKET}"
    key     = "${STATE_KEY}"
    region  = "${REGION}"
    encrypt = "true"
    use_lockfile = "true"
  }
}
EOT

# cleanup of backend.tf on exit
trap 'rm -f backend.tf' EXIT

# Initialize Terraform
if [ "$ACTION" == "init" ]; then
    terraform init -reconfigure 

    # if workspace exists and select it
    if ! terraform workspace list | grep -wq "$ENVIRONMENT"; then
        terraform workspace new "$ENVIRONMENT"
    fi
    terraform workspace select "$ENVIRONMENT"

elif [ "$ACTION" == "plan" ]; then
    terraform workspace select "$ENVIRONMENT"
    terraform plan

elif [ "$ACTION" == "apply" ]; then
    terraform workspace select "$ENVIRONMENT"
    terraform apply -auto-approve

elif [ "$ACTION" == "destroy" ]; then
    terraform workspace select "$ENVIRONMENT"
    terraform plan -destroy
    sleep 50
    terraform destroy -auto-approve

else
    echo "Invalid action. Use: init, plan, apply, or destroy."
    exit 1
fi
