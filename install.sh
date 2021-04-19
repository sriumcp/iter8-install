#!/bin/bash

set -e

# Step 0: Export GIT_ACCOUNT and TAG
# GIT_ACCOUNT enables manual testing from a fork
export GIT_ACCOUNT="${GIT_ACCOUNT:-iter8-tools}"
export TAG="${TAG:-v0.3.0}"

# Step 1: Install Iter8
echo "Installing Iter8"
kubectl apply -f https://raw.githubusercontent.com/${GIT_ACCOUNT}/iter8-install/${TAG}/core/build.yaml
kubectl wait crd -l creator=iter8 --for condition=established --timeout=120s
kubectl apply -f https://raw.githubusercontent.com/${GIT_ACCOUNT}/iter8-install/${TAG}/metrics/build.yaml

echo "Verifying Iter8 installation"
kubectl wait --for condition=ready --timeout=300s pods --all -n iter8-system

set +e
