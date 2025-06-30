#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Deploying ArgoCD Ingress..."

echo "Waiting for Nginx Ingress Controller to be available..."
kubectl wait --namespace ingress-nginx --for=condition=available deployment/ingress-nginx-controller --timeout=300s

echo "Waiting for Nginx Ingress Controller pod to be running..."
kubectl wait --namespace ingress-nginx \
  --for=condition=Ready pod -l app.kubernetes.io/component=controller --timeout=300s

# Apply the ArgoCD Ingress manifest
kubectl apply -f "${SCRIPT_DIR}/../manifests/argocd-ingress.yaml"

echo "ArgoCD Ingress deployed."