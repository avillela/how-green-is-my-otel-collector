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
  --set alertmanager.enabled=false \
  --wait


echo "*********** Deploying Kepler *********** "
helm repo add kepler https://sustainable-computing-io.github.io/kepler-helm-chart
# helm install kepler kepler/kepler \
#   --values src/kepler/values.yaml \
#   --namespace kepler \
#   --create-namespace
helm install kepler kepler/kepler \
    --namespace kepler \
    --create-namespace \
    --set serviceMonitor.enabled=true \
    --set serviceMonitor.labels.release=prometheus \
    --set canMount.usrSrc=false \
    --set extraEnvVars.ENABLE_PROCESS_METRICS="true"

kubectl wait pod --namespace prometheus -l "release=prometheus" --for=condition=Ready --timeout=2m
PROMETHEUS_SERVER=$(kubectl get svc -l app=kube-prometheus-stack-prometheus -n prometheus -o jsonpath="{.items[0].metadata.name}")

echo "*********** Adding Kepler dashboard to Grafana *********** "
GF_POD=$(
    kubectl get pod \
        -n prometheus \
        -l app.kubernetes.io/name=grafana \
        -o jsonpath="{.items[0].metadata.name}"
)
kubectl cp src/kepler/kepler_dashboard.json prometheus/$GF_POD:/tmp/dashboards/kepler_dashboard.json

