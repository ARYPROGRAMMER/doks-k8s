#!/bin/bash

echo "=== Checking Selenium Hub Pod Status ==="
kubectl get pods -l app=selenium-hub

echo -e "\n=== Checking Selenium Hub Service ==="
kubectl get service selenium-hub

echo -e "\n=== Checking Selenium Hub Endpoint ==="
kubectl get endpoints selenium-hub

echo -e "\n=== Selenium Hub Pod Logs ==="
kubectl logs $(kubectl get pods -l app=selenium-hub -o name) | tail -20

echo -e "\n=== Testing connection from within the cluster ==="
kubectl run curl-test --rm -it --restart=Never --image=curlimages/curl -- curl -v http://selenium-hub:4444/wd/hub/status

echo -e "\n=== Pod Events ==="
kubectl describe pod $(kubectl get pods -l app=selenium-hub -o name) | grep -A 10 Events:

echo -e "\n=== Checking Network Policies ==="
kubectl get networkpolicies

echo -e "\n=== Port-forward test ==="
echo "Run this command in a separate terminal to test local access:"
echo "kubectl port-forward service/selenium-hub 4444:4444"
echo "Then open http://localhost:4444/ui in your browser"

echo -e "\n=== Checking ALL Pod Statuses ==="
kubectl get pods

echo -e "\n=== Debugging Pending Pods ==="
for pod in $(kubectl get pods | grep Pending | awk '{print $1}'); do
  echo -e "\n--- Events for pending pod $pod ---"
  kubectl describe pod $pod | grep -A 15 Events:
done

echo -e "\n=== Debugging ImagePullBackOff Pods ==="
for pod in $(kubectl get pods | grep ImagePullBackOff | awk '{print $1}'); do
  echo -e "\n--- Events for ImagePullBackOff pod $pod ---"
  kubectl describe pod $pod | grep -A 15 Events:
done

echo -e "\n=== Node Resource Usage ==="
kubectl describe nodes | grep -A 10 "Allocated resources"
