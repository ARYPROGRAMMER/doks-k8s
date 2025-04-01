#!/bin/bash

echo "==== Setting up AntScrapperX with Selenium Grid ===="

# Apply core configurations
kubectl apply -f selenium-hub-deployment.yaml
kubectl apply -f selenium-services.yaml
kubectl apply -f selenium-grid-deployment.yaml
kubectl apply -f selenium-network-policy.yaml
kubectl apply -f multi-container-deployment.yaml

# Wait for deployments to be ready
echo "Waiting for Selenium Hub to be ready..."
kubectl wait --for=condition=available deployment/selenium-hub --timeout=120s

echo "Waiting for Chrome nodes to be ready..."
kubectl wait --for=condition=available deployment/selenium-chrome-node --timeout=120s

echo "Waiting for AntScrapperX to be ready..."
kubectl wait --for=condition=available deployment/antscrapperx-multi --timeout=120s

# Display status
echo -e "\n==== Status of deployments ===="
kubectl get deployments

echo -e "\n==== Status of pods ===="
kubectl get pods

echo -e "\n==== Selenium Hub service details ===="
kubectl get service selenium-hub

EXTERNAL_IP=$(kubectl get service selenium-hub -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo -e "\nSelenium Grid UI is available at: http://$EXTERNAL_IP:4444/ui"
echo "Selenium Hub endpoint is: http://$EXTERNAL_IP:4444/wd/hub"
