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

echo "🛑 Stopping cluster containers..."

CONTAINERS=$(docker ps --filter "name=$CLUSTER_NAME" -q)

if [ -n "$CONTAINERS" ]; then
  docker stop $CONTAINERS
  echo "✅ Cluster stopped (state preserved)"
else
  echo "⚠️ No running containers found"
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
