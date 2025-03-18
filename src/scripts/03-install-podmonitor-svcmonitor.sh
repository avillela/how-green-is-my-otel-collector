#! /bin/bash

## Installs PodMonitor and ServiceMonitor ONLY

echo "*********** Deploying PodMonitor and ServiceMonitor ***********"
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.80.1/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.80.1/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
