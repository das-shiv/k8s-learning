#!/bin/bash

echo "Deleting Kubernetes cluster..."

kind delete cluster --name dev-cluster

echo "Cluster deleted"
