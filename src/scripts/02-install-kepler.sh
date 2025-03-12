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

# Install modified PodMonitor. This way, we don't have to do Kepler scrape configs in the Collector's Target Allocator config
kubectl wait pod --namespace kepler -l "app.kubernetes.io/name=kepler" --for=condition=Ready --timeout=2m
kubectl apply -f src/k8s/00-kepler-servicemonitor.yaml

# Reference:
# https://grafana.com/docs/grafana/latest/setup-grafana/installation/kubernetes/
echo "*********** Deploying Grafana *********** "
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana \
  --namespace grafana \
  --create-namespace

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
kubectl cp src/kepler/grafana_kepler_dashboard.json grafana/$GF_POD:/etc/grafana/provisioning/dashboards/grafana_kepler_dashboard.json
kubectl rollout restart -n grafana deployment --selector=app.kubernetes.io/name=grafana 
