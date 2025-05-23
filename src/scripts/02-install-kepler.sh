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

# Kepler kepler-0.5.13 

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
    --set extraEnvVars.ENABLE_PROCESS_METRICS="true" \
    --version "0.5.13"

# Install modified ServiceMonitor. This way, we don't have to do Kepler scrape configs in the Collector's Prometheus Receiver config
kubectl wait pod --namespace kepler -l "app.kubernetes.io/name=kepler" --for=condition=Ready --timeout=2m
kubectl apply -f src/k8s/00-kepler-servicemonitor.yaml