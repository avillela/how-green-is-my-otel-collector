#! /bin/bash

## Intalls kube-green
## Note that kube-green requires cert-manager to be installed first.
## cert-manager is installed as part of src/scripts/01-install-otel-operator.sh

echo "*********** Deploying Kube-Green ***********"
helm repo add kube-green https://kube-green.github.io/helm-charts/
helm upgrade kube-green kube-green/kube-green \
    --namespace kube-green --create-namespace  \
    --set manager.metrics.secure=false --install \
    --version "0.7.0"