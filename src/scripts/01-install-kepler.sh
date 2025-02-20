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

###----------
### Version 1 - not sure if it worked
###----------

# Install Kepler
helm repo add kepler https://sustainable-computing-io.github.io/kepler-helm-chart
helm repo update
helm install kepler kepler/kepler --values src/kepler/values.yaml --namespace kepler --create-namespace

###----------
### Version 2 - seems to work
###----------

# Reference:
# https://sustainable-computing.io/installation/kepler-helm/

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack   \
  --namespace prometheus --create-namespace \
  --set alertmanager.enabled=false  --wait

# export POD_NAME=$(kubectl --namespace prometheus get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=prometheus" -oname)
# kubectl --namespace prometheus port-forward $POD_NAME 3000
# Grafana default username and password: admin/prom-operator

echo "Deploying Kepler"
helm repo add kepler https://sustainable-computing-io.github.io/kepler-helm-chart
helm install kepler kepler/kepler \
    --namespace kepler \
    --create-namespace \
    --set serviceMonitor.enabled=true \
    --set serviceMonitor.labels.release=prometheus \
    --set canMount.usrSrc=false

kubectl wait pod --namespace prometheus -l "release=prometheus" --for=condition=Ready --timeout=2m
PROMETHEUS_SERVER=$(kubectl get svc -l app=kube-prometheus-stack-prometheus -n prometheus -o jsonpath="{.items[0].metadata.name}")

echo "Add Kepler dashboard to Grafana"
GF_POD=$(
    kubectl get pod \
        -n prometheus \
        -l app.kubernetes.io/name=grafana \
        -o jsonpath="{.items[0].metadata.name}"
)
kubectl cp src/kepler/kepler_dashboard.json prometheus/$GF_POD:/tmp/dashboards/kepler_dashboard.json

###----------

# ZONE=europe-west3-a
# NAME=sustainabilty-workshop
# gcloud container clusters create ${NAME} --zone=${ZONE} --machine-type=e2-standard-8 --num-nodes=2


###----------
### Version 0 - crap
###----------


# Intall Kube Prometheus Stack (requires Prometheus Node Exporter)
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo update

# helm install prometheus prometheus-community/kube-prometheus-stack \
#     --namespace monitoring \
#     --create-namespace \
#     --wait

# # Add Kepler Helm repo & install Kepler
# helm repo add kepler https://sustainable-computing-io.github.io/kepler-helm-chart
# helm repo update

# helm install kepler kepler/kepler \
#     --namespace kepler \
#     --create-namespace \
#     --set serviceMonitor.enabled=true \
#     --set serviceMonitor.labels.release=prometheus \
