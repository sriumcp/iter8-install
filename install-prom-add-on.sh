#!/bin/bash

set -e

# Step 0: Export GIT_ACCOUNT and TAG
# GIT_ACCOUNT enables manual testing from a fork
export GIT_ACCOUNT="${GIT_ACCOUNT:-iter8-tools}"
export TAG="${TAG:-v0.4.4}"

# Step 1: Install Prometheus add-on
# This step assumes you have installed Iter8 using install.sh
echo "Installing Prometheus add-on"
kubectl apply -f https://raw.githubusercontent.com/${GIT_ACCOUNT}/iter8-install/${TAG}/prometheus-add-on/prometheus-operator/build.yaml
kubectl wait crd -l creator=iter8 --for condition=established --timeout=120s
kubectl apply -f https://raw.githubusercontent.com/${GIT_ACCOUNT}/iter8-install/${TAG}/prometheus-add-on/prometheus/build.yaml
kubectl apply -f https://raw.githubusercontent.com/${GIT_ACCOUNT}/iter8-install/${TAG}/prometheus-add-on/service-monitors/build.yaml

echo "Verifying Prometheus-addon installation"
kubectl wait --for condition=ready --timeout=300s pods --all -n iter8-system

set +e
