#!/bin/bash

# Get the LoadBalancer external IP
EXTERNAL_IP=$(kubectl get service selenium-hub -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Selenium Hub external IP: $EXTERNAL_IP"
echo

# Test connection using curl
echo "Testing direct access to the Selenium Hub..."
echo "curl http://$EXTERNAL_IP:4444/wd/hub/status"
curl -s http://$EXTERNAL_IP:4444/wd/hub/status
echo

# Test connection using wget
echo -e "\nTesting with wget..."
echo "wget -qO- http://$EXTERNAL_IP:4444/wd/hub/status"
wget -qO- http://$EXTERNAL_IP:4444/wd/hub/status
echo

# Test browser connection path
echo -e "\nBrowser UI should be available at: http://$EXTERNAL_IP:4444/ui"
echo "Use the above URL in your browser to view the Selenium Grid UI"

# Check if firewall might be blocking
echo -e "\nChecking for potential firewall issues..."
echo "kubectl run curl-test --rm -it --restart=Never --image=curlimages/curl -- curl http://$EXTERNAL_IP:4444/wd/hub/status"
echo "(Run this command to test access from within the cluster)"

# If WSL or Linux
if command -v nc &> /dev/null; then
  echo -e "\nTesting port connectivity..."
  echo "nc -zv $EXTERNAL_IP 4444"
  nc -zv $EXTERNAL_IP 4444 2>&1
fi
