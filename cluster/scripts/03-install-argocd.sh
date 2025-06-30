#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Installing ArgoCD..."

# Apply the ArgoCD manifest
kubectl apply -n argocd -f "${SCRIPT_DIR}/../manifests/argocd/install.yaml" 

# Wait for the argocd-server deployment to be created
until kubectl get deployment argocd-server -n argocd &> /dev/null; do
  echo "Waiting for argocd-server deployment to be created..."
  sleep 5
done

# Wait for the argocd-server deployment to be available
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

echo "ArgoCD installed."