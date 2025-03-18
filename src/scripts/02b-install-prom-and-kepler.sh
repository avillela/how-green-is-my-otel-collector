#!/bin/bash

# References:
# -----------
# https://sustainable-computing.io/installation/kepler-helm/
#
# README: https://github.com/Observe-Resolve/observeresolve-keplermetric/blob/master/README.md
# https://github.com/Observe-Resolve/observeresolve-keplermetric/blob/master/deployment.sh
#
# README: https://github.com/henrikrexed/Sustainability-workshop/blob/master/README.md
# https://github.com/henrikrexed/Sustainability-workshop/blob/master/deployment.sh

# Kube Prometheus Stack kube-prometheus-stack-69.8.2

echo "*********** Installing kube-prometheus-stack *********** "
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack   \
  --namespace prometheus --create-namespace \
  --set alertmanager.enabled=false \
  --version "69.8.2"
  --wait


./src/scripts/02-install-kepler.sh

# Install Grafana Kepler dashboard
kubectl wait pod --namespace prometheus -l "release=prometheus" --for=condition=Ready --timeout=2m
PROMETHEUS_SERVER=$(kubectl get svc -l app=kube-prometheus-stack-prometheus -n prometheus -o jsonpath="{.items[0].metadata.name}")

echo "*********** Adding Kepler dashboard to Grafana *********** "
GF_POD=$(
    kubectl get pod \
        -n prometheus \
        -l app.kubernetes.io/name=grafana \
        -o jsonpath="{.items[0].metadata.name}"
)
kubectl cp src/kepler/grafana_kepler_dashboard.json prometheus/$GF_POD:/tmp/dashboards/grafana_kepler_dashboard.json
