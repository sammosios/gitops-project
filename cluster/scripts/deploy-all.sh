#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Starting full GitOps project deployment..."

# Deploy Kind Cluster and capture the kubeconfig path
"${SCRIPT_DIR}/01-deploy-kind-cluster.sh"
KIND_KUBECONFIG_PATH="${SCRIPT_DIR}/../terraform/gitops-cluster-config.yaml"
export KUBECONFIG="${KIND_KUBECONFIG_PATH}"

# Install Ingress Nginx
"${SCRIPT_DIR}/02-install-ingress-nginx.sh"

# Install ArgoCD
"${SCRIPT_DIR}/03-install-argocd.sh"

# Deploy ArgoCD Ingress
"${SCRIPT_DIR}/04-deploy-argocd-ingress.sh"

echo "All components deployed. Please ensure your /etc/hosts file has '127.0.0.1 argocd.local' and access ArgoCD at https://argocd.local"

# Retrieve initial admin password
echo "Initial ArgoCD admin password: "
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
