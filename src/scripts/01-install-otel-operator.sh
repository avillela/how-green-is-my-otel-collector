#! /bin/bash

# Installs cert-manager and the OTel Operator
# Note that the OTel Operator needs cert-manager to be installed first.

echo "*********** Deploying Cert Manager (required for OpenTelemetry Operator) ***********"
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.yaml
kubectl wait pod -l app.kubernetes.io/component=webhook -n cert-manager --for=condition=Ready --timeout=2m

# Need to wait for cert-manager to finish before installing the operator
# Sometimes it takes a while for cert-manager pods to come up
echo "----- Let's take a 10-second nap while the cert-manager pods come up... -----"
sleep 10

echo "*********** Deploying the OpenTelemetry Operator ***********"
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.124.0/opentelemetry-operator.yaml
