#!/bin/bash
set -e

CLUSTER_NAME="k8s-cluster"

echo "Creating Kubernetes cluster..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

kind create cluster --name $CLUSTER_NAME --config "$SCRIPT_DIR/kind-cluster.yaml"

echo ""
echo "✅ Cluster created successfully"
echo ""

kubectl cluster-info --context kind-$CLUSTER_NAME

echo ""
echo "Cluster nodes:"
kubectl get nodes