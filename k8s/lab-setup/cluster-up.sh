#!/bin/bash
set -e

CLUSTER_NAME="k8s-cluster"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/kind-cluster.yaml"
KUBECONFIG_FILE="$SCRIPT_DIR/kind-${CLUSTER_NAME}-kubeconfig"
KIND_CONTEXT="kind-$CLUSTER_NAME"

ensure_docker_running() {
  if ! docker info >/dev/null 2>&1; then
    echo "🔧 Starting Docker..."
    sudo service docker start
    sleep 3
  fi
}

ensure_docker_running

echo "✅ Docker is running"

if kind get clusters | grep -q "$CLUSTER_NAME"; then
  echo "🔍 Cluster exists. Starting containers..."

  CONTAINERS=$(docker ps -a --filter "name=$CLUSTER_NAME" -q)

  if [ -n "$CONTAINERS" ]; then
    docker start $CONTAINERS
    echo "✅ Cluster containers started"
  fi
else
  echo "🚀 Creating cluster..."
  kind create cluster --name $CLUSTER_NAME --config "$CONFIG_FILE"
fi

kind get kubeconfig --name "$CLUSTER_NAME" > "$KUBECONFIG_FILE"
KUBECTL="kubectl --kubeconfig=$KUBECONFIG_FILE"

echo ""

$KUBECTL config use-context "$KIND_CONTEXT"

$KUBECTL wait --for=condition=Ready nodes --all --timeout=60s

$KUBECTL get nodes