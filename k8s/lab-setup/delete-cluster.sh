#!/bin/bash
set -e

CLUSTER_NAME="k8s-cluster"

ensure_docker_running() {
  if ! docker info >/dev/null 2>&1; then
    echo "🔧 Starting Docker..."
    sudo service docker start
    sleep 3
  fi
}

ensure_docker_running

echo "💣 Destroying cluster..."

if kind get clusters | grep -q "$CLUSTER_NAME"; then
  kind delete cluster --name $CLUSTER_NAME
  echo "✅ Cluster deleted"
else
  echo "⚠️ Cluster not found"
fi

echo ""
echo "🛑 Stopping Docker..."
if sudo systemctl status docker.service >/dev/null 2>&1; then
  sudo systemctl stop docker.service >/dev/null 2>&1 || true
fi
if sudo systemctl status docker.socket >/dev/null 2>&1; then
  sudo systemctl stop docker.socket >/dev/null 2>&1 || true
fi

echo "✅ Docker stopped"