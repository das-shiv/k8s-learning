#!/bin/bash
set -e

CLUSTER_NAME="k8s-cluster"

echo "Deleting Kubernetes cluster..."

kind delete cluster --name $CLUSTER_NAME

echo "✅ Cluster deleted"