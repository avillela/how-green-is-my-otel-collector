#! /bin/bash

kubectl create ns opentelemetry

if [ $# -eq 0 ]; then
    SUFFIX=""
    echo "** No arguments supplied **"
else
    # Additional configuration for deploying to SaaS backends
    SUFFIX="-$1"
    echo "** Suffix is '${SUFFIX}' **"
    kubectl apply -f src/k8s/00-secret${SUFFIX}.yaml
fi

kubectl apply -f src/k8s/01-rbac.yaml
kubectl apply -f src/k8s/01-target-allocator-rbac.yaml
kubectl apply -f src/k8s/02-otel-collector${SUFFIX}.yaml
kubectl apply -f src/k8s/03-instrumentation.yaml
kubectl apply -f src/k8s/04-service-monitor.yaml
kubectl apply -f src/k8s/05-pod-monitor.yaml
kubectl apply -f src/k8s/06-python-client.yaml
kubectl apply -f src/k8s/07-python-server.yaml
kubectl apply -f src/k8s/08-python-prometheus-app.yaml
kubectl apply -f src/k8s/09-jaeger.yaml
