#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Deploying Kind cluster with Terraform..."

cd "${SCRIPT_DIR}/../terraform"

# Destroy any existing Terraform-managed resources (including the Kind cluster if managed by Terraform)
echo "Destroying existing Terraform-managed resources..."
terraform destroy --auto-approve || true

terraform init
terraform apply --auto-approve

# Get kubeconfig from Kind and save it to a temporary file
KIND_KUBECONFIG_PATH="${SCRIPT_DIR}/../terraform/gitops-cluster-config.yaml"
kind get kubeconfig --name gitops-cluster > "${KIND_KUBECONFIG_PATH}"

# Output the path to the kubeconfig for the parent script
echo "KIND_KUBECONFIG_PATH=${KIND_KUBECONFIG_PATH}"

# Set kubectl context to the Kind cluster
kubectl config use-context kind-gitops-cluster --kubeconfig="${KIND_KUBECONFIG_PATH}"

# Wait for the Kubernetes API server to be ready
kubectl wait --for=condition=available --timeout=300s --namespace=kube-system deployment/coredns --kubeconfig="${KIND_KUBECONFIG_PATH}"

echo "Kind cluster deployed."