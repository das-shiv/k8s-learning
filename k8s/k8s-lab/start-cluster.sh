#!/bin/bash
set -e

CLUSTER_NAME="k8s-cluster"

echo "🚀 Starting Docker service..."
sudo systemctl start docker

sleep 3

CONTAINERS=$(docker ps -a --filter "name=${CLUSTER_NAME}" -q)

if [ -z "$CONTAINERS" ]; then
  echo "❌ No containers found. Run create-cluster.sh"
  exit 1
fi

echo "▶️ Starting cluster..."
docker start $CONTAINERS

echo "⏳ Waiting for cluster..."
sleep 5

kubectl get nodes

echo "✅ Cluster started"