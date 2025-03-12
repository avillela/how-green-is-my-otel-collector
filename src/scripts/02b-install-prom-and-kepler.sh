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

echo "*********** Installing kube-prometheus-stack *********** "
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack   \
  --namespace prometheus --create-namespace \
  --set alertmanager.enabled=false  --wait


echo "*********** Deploying Kepler *********** "
helm repo add kepler https://sustainable-computing-io.github.io/kepler-helm-chart
helm install kepler kepler/kepler \
    --namespace kepler \
    --create-namespace \
    --set serviceMonitor.enabled=true \
    --set serviceMonitor.labels.release=prometheus \
    --set canMount.usrSrc=false

# Install modified PodMonitor. This way, we don't have to do Kepler scrape configs in the Collector's Prometheus Receiver config
kubectl wait pod --namespace kepler -l "app.kubernetes.io/name=kepler" --for=condition=Ready --timeout=2m
kubectl apply -f src/k8s/00-kepler-servicemonitor.yaml

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
