#!/bin/bash

# Delete the hub test pod
kubectl delete pod hub-test-pod

# Apply updated configurations
kubectl apply -f multi-container-deployment.yaml
kubectl apply -f selenium-hub-deployment.yaml
kubectl apply -f selenium-grid-deployment.yaml
kubectl apply -f selenium-services.yaml
kubectl apply -f selenium-network-policy.yaml

# Check status
echo -e "\nChecking status after applying configurations..."
kubectl get pods
kubectl get services
