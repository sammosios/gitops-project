#!/bin/bash

set -e

echo "Deploying Kind cluster with Terraform..."

cd "$HOME/gitops-project/cluster/terraform"

# Destroy any existing Terraform-managed resources (including the Kind cluster if managed by Terraform)
terraform destroy --auto-approve || true

terraform init
terraform apply --auto-approve

# Get kubeconfig from Kind and save it to a temporary file
KIND_KUBECONFIG_PATH="/tmp/kind-kubeconfig-$(date +%s)"
kind get kubeconfig --name gitops-cluster > "${KIND_KUBECONFIG_PATH}"

# Output the path to the kubeconfig for the parent script
echo "KIND_KUBECONFIG_PATH=${KIND_KUBECONFIG_PATH}"

# Set kubectl context to the Kind cluster
kubectl config use-context kind-gitops-cluster --kubeconfig="${KIND_KUBECONFIG_PATH}"

# Wait for the Kubernetes API server to be ready
kubectl wait --for=condition=available --timeout=300s --namespace=kube-system deployment/coredns --kubeconfig="${KIND_KUBECONFIG_PATH}"

echo "Kind cluster deployed."