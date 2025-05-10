#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Constants
DEPLOYMENT_FILE="./kubernetes/deployment.yaml"

# Determine the environment based on the branch
if [[ "$GITHUB_REF" == "refs/heads/main" ]]; then
    ECR_IMAGE="$AWS_ACCOUNT_ID.dkr.ecr.eu-west-2.amazonaws.com/cicdapprepoprod:latest"
    echo "Deploying to production environment..."
else
    ECR_IMAGE="$AWS_ACCOUNT_ID.dkr.ecr.eu-west-2.amazonaws.com/cicdapprepodev:latest"
    echo "Deploying to dev environment..."
fi

# Check if the deployment file exists
if [[ ! -f "$DEPLOYMENT_FILE" ]]; then
    echo "Error: Deployment file $DEPLOYMENT_FILE does not exist."
    exit 1
fi

# Update the image in the deployment YAML file
sed -i.bak "s|image: \".*\"|image: \"$ECR_IMAGE\"|" "$DEPLOYMENT_FILE"

# Inform for the update
echo "Updated $DEPLOYMENT_FILE with image: $ECR_IMAGE"
