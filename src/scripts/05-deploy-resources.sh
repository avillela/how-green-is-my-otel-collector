#! /bin/bash

## Run: ./src/scripts/04-deploy-resources.sh --run-mode (dt | oss) --split-collectors (split | nosplit | nosplitocb)
echo "parsing arguments"
while [ $# -gt 0 ]; do
  case "$1" in
   --run-mode)
     RUN_MODE="$2"
    shift 2
     ;;
   --split-collectors)
     SPLIT_COLLECTORS="$2"
    shift 2
     ;;
  *)
    echo "Warning: skipping unsupported option: $1"
    shift
    ;;
  esac
done

echo "Checking arguments"
if [ -z "$RUN_MODE" ]; then
  echo "Error: Run mode not set! Must be one of (dt | oss) Exiting."
  exit 1
fi

if [ -z "$SPLIT_COLLECTORS" ]; then
  echo "Error: Split collectors not set! Must be one of (split | nosplit | nosplitocb) Exiting."
  exit 1
fi


echo "Run mode is: $RUN_MODE"
echo "Split collectors is: $SPLIT_COLLECTORS"

kubectl create ns opentelemetry

if [ "${RUN_MODE}" == "oss" ]; then
    SUFFIX=""

    if [ "${SPLIT_COLLECTORS}" != "nosplit" ]; then
        echo "Invalid combination. Can only run 'oss' option with 'nosplit'"
        exit 1
    fi

    echo "** Running in OSS mode (using Jaeger, Grafana, Prometheus) **"
elif [ "${RUN_MODE}" == "dt" ]; then
    SUFFIX="-${RUN_MODE}"
    printf "** Suffix is '%s' **\n" ${SUFFIX}
    kubectl apply -f src/k8s/00-secret${SUFFIX}.yaml
else
    echo "INVALID OPTION. Must be one of (dt | oss) Exiting."
    exit 1
fi

kubectl apply -f src/k8s/01-rbac.yaml
kubectl apply -f src/k8s/01-target-allocator-rbac.yaml

if [ "${SPLIT_COLLECTORS}" == "split" ]; then
    printf "** Running MULTIPLE OTel Collectors: [%s] **\n" ${SPLIT_COLLECTORS}

    kubectl apply -f src/k8s/02-otel-collector${SUFFIX}-k8s.yaml
    kubectl apply -f src/k8s/02-otel-collector${SUFFIX}-app.yaml
elif [ "${SPLIT_COLLECTORS}" == "nosplit" ]; then
    printf "** Running single OTel Collector:[%s] **\n" ${SPLIT_COLLECTORS}
    kubectl apply -f src/k8s/02-otel-collector${SUFFIX}.yaml
elif [ "${SPLIT_COLLECTORS}" == "nosplitocb" ]; then
    printf "** Running single OTel Collector:[%s] **\n" ${SPLIT_COLLECTORS}
    kubectl apply -f src/k8s/02-otel-collector${SUFFIX}-ocb.yaml
else
    echo "INVALID OPTION. Must be one of (split | nosplit | nosplitocb) Exiting."
    exit 1
fi

kubectl apply -f src/k8s/03-instrumentation.yaml
kubectl apply -f src/k8s/04-service-monitor.yaml
kubectl apply -f src/k8s/05-pod-monitor.yaml
kubectl apply -f src/k8s/06-python-client.yaml
kubectl apply -f src/k8s/07-python-server.yaml
kubectl apply -f src/k8s/08-python-prometheus-app.yaml
kubectl apply -f src/k8s/09-jaeger.yaml
