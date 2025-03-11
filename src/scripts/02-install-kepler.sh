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

# echo "*********** Installing kube-prometheus-stack *********** "
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm install prometheus prometheus-community/kube-prometheus-stack   \
#   --namespace prometheus --create-namespace \
#   --set alertmanager.enabled=false \
#   --wait


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

echo "*********** Deploying Grafana *********** "
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana \
  --namespace grafana \
  --create-namespace

# kubectl wait pod --namespace prometheus -l "release=prometheus" --for=condition=Ready --timeout=2m
# PROMETHEUS_SERVER=$(kubectl get svc -l app=kube-prometheus-stack-prometheus -n prometheus -o jsonpath="{.items[0].metadata.name}")

# Get grafana password
kubectl wait pod --namespace grafana -l "app.kubernetes.io/name=grafana" --for=condition=Ready --timeout=2m
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# echo "*********** Adding Kepler dashboard to Grafana *********** "
GF_POD=$(
    kubectl get pod \
        -n grafana \
        -l app.kubernetes.io/name=grafana \
        -o jsonpath="{.items[0].metadata.name}"
)
echo "## Grafana pod name is ${GF_POD}"
kubectl cp src/kepler/kepler_dashboard.json grafana/$GF_POD:/etc/grafana/provisioning/dashboards/kepler_dashboard.json
kubectl rollout restart -n grafana deployment --selector=app.kubernetes.io/name=grafana 
# GF_POD=$(
#     kubectl get pod \
#         -n prometheus \
#         -l app.kubernetes.io/name=grafana \
#         -o jsonpath="{.items[0].metadata.name}"
# )
# kubectl cp src/kepler/kepler_dashboard.json prometheus/$GF_POD:/tmp/dashboards/kepler_dashboard.json