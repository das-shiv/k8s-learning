#!/bin/bash

echo "Creating Kubernetes cluster..."

kind create cluster --config kind-cluster.yaml

echo ""
echo "Cluster created successfully"
echo ""

kubectl cluster-info --context kind-dev-cluster

echo ""
echo "Cluster nodes:"
kubectl get nodes
