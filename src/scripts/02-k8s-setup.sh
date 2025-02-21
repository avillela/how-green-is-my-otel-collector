#! /bin/bash

# Install just ServiceMonitor and PodMonitor
# NOTE: This GH issue put me on the right track: https://github.com/open-telemetry/opentelemetry-operator/issues/1811#issuecomment-1584128371
# kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.74.0/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
# kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.74.0/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml

echo "*********** Deploying Cert Manager (required for OpenTelemetry Operator) ***********"
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.yaml
kubectl wait pod -l app.kubernetes.io/component=webhook -n cert-manager --for=condition=Ready --timeout=2m

# Need to wait for cert-manager to finish before installing the operator
# Sometimes it takes a while for cert-manager pods to come up
echo "----- Let's take a 10-second nap while the cert-manager pods come up... -----"
sleep 10

echo "*********** Deploying the OpenTelemetry Operator ***********"
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.102.0/opentelemetry-operator.yaml

# Install Jaeger operator
# helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
# helm repo update
# helm install --namespace jaeger-operator --create-namespace jaeger-operator jaegertracing/jaeger-operator
