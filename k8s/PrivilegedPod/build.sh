#!/bin/bash

set -e

eval $(minikube docker-env)
minikube addons enable ingress

echo "============="
echo "Deploy web..."
echo "============="

cd web
docker build --platform linux/arm64 -t duncansnyk/web:1.0.0 .
docker push duncansnyk/web:1.0.0
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
cd ..

echo "==============="
echo "Deploy payment..."
echo "==============="

cd payment
docker build --platform linux/arm64 -t duncansnyk/payment:1.0.0 .
docker push duncansnyk/payment:1.0.0 
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
cd ..

kubectl apply -f ingress.yaml
