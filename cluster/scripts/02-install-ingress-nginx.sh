#!/bin/bash

set -e

echo "Installing Nginx Ingress Controller..."

# Apply the manifest
kubectl apply -f "$HOME/gitops-project/cluster/manifests/ingress-nginx/deploy.yaml"

# Wait for the deployment to be available
kubectl wait --namespace ingress-nginx --for=condition=available deployment/ingress-nginx-controller --timeout=300s

# Label the Kind node
NODE_NAME=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
kubectl label node "${NODE_NAME}" ingress-ready=true --overwrite

echo "Nginx Ingress Controller installed and node labeled."