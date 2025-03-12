#! /bin/bash

kubectl create ns opentelemetry

RUN_MODE=$1
SPLIT_COLLECTORS=$2

if [ -z "${RUN_MODE}" ] ; then
    echo "Run mode not set. Must be one of 'oss' or 'dt'"
    exit 1
fi

if [ -z "${SPLIT_COLLECTORS}" ] ; then
    echo "Split collectors not set. Must be one of 'split' or 'nosplit'"
    exit 1
fi


if [ ${RUN_MODE} == "oss" ]; then
    SUFFIX=""
    echo "** Running in OSS mode **"
else
    # Additional configuration for deploying to SaaS backends
    SUFFIX="-$1"
    printf "** Suffix is '%s' **\n" ${SUFFIX}
    kubectl apply -f src/k8s/00-secret${SUFFIX}.yaml
fi


kubectl apply -f src/k8s/01-rbac.yaml
kubectl apply -f src/k8s/01-target-allocator-rbac.yaml

if [ "${SPLIT_COLLECTORS}" == "split" ]; then
    printf "** Running MULTIPLE OTel Collectors: [%s] **\n" ${SPLIT_COLLECTORS}

    kubectl apply -f src/k8s/02-otel-collector${SUFFIX}-k8s.yaml
    kubectl apply -f src/k8s/02-otel-collector${SUFFIX}-app.yaml
    # kubectl apply -f src/k8s/02-otel-collector${SUFFIX}-traces.yaml
    # kubectl apply -f src/k8s/02-otel-collector${SUFFIX}-logs.yaml
    # kubectl apply -f src/k8s/02-otel-collector${SUFFIX}-metrics.yaml
else
    printf "** Running sinlge OTel Collector:[%s] **\n" ${SPLIT_COLLECTORS}
    kubectl apply -f src/k8s/02-otel-collector${SUFFIX}.yaml
fi

kubectl apply -f src/k8s/03-instrumentation.yaml
kubectl apply -f src/k8s/04-service-monitor.yaml
kubectl apply -f src/k8s/05-pod-monitor.yaml
kubectl apply -f src/k8s/06-python-client.yaml
kubectl apply -f src/k8s/07-python-server.yaml
kubectl apply -f src/k8s/08-python-prometheus-app.yaml
kubectl apply -f src/k8s/09-jaeger.yaml
