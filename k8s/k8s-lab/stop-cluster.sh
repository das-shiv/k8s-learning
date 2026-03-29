#!/bin/bash
set -e

CLUSTER_NAME="k8s-cluster"

CONTAINERS=$(docker ps --filter "name=${CLUSTER_NAME}" -q)

if [ -n "$CONTAINERS" ]; then
  echo "⏹️ Stopping cluster..."
  docker stop $CONTAINERS
fi

echo "🛑 Stopping Docker completely..."
sudo systemctl stop docker docker.socket

echo "✅ Cluster stopped"