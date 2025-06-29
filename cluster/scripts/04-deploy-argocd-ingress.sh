#!/bin/bash

set -e

echo "Deploying ArgoCD Ingress..."

# Apply the ArgoCD Ingress manifest
kubectl apply -f "$HOME/gitops-project/cluster/manifests/argocd-ingress.yaml"

echo "ArgoCD Ingress deployed."