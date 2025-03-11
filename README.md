# How Green is My OTel Collector?

This is the accompanying repository for the "How Green is My OTel Collector?" KubeCon EU 2025 talk by Adriana Villela and Nancy Chauhan.

This repository comes with a [Development (Dev) Container](https://containers.dev) [configuration file](.devcontainer/devcontainer.json), so that you can run the code locally using a Dev Container (e.g. via the [VSCode Dev Container plugn](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)), or on [GitHub Codespaces](https://code.visualstudio.com/docs/remote/codespaces).

The Dev Container configuration includes everything that you need in order to run this example:
* `gcloud` CLI
* `pulumi` CLI
* Python v3.11
* [Helm](https://helm.sh/)
* `kubectl`
* [K9s](https://k9scli.io/)

Ideally, you should run this example using a cloud-based provider, to get a realistic idea of power consumption of cloud-based resources. This is nothing, however, stopping you from running this locally.

This repo will show you examples for running this with a cloud-based provider.

## Setup

### 1- Create Kubernetes cluster

If you are using Google Cloud, follow the instructions [here](/src/pulumi/gke-cluster/README.md).


### 2- Install Kepler

The [following script](/src/scripts/01-install-kepler.sh) will install:

1. The [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) via Helm.

    It includes the [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator), Grafana dashboards, and more.

2. [Kepler](https://sustainable-computing.io) via Helm.

3. A [Grafana dashboard](/src/kepler/kepler_dashboard.json) for Kepler.

For more information, check out the [Kepler installation documentation](https://sustainable-computing.io/installation/kepler-helm/).

```bash
./src/scripts/01-install-kepler.sh
```

### 3- Access the Grafana Kepler dashboard

Open up a new terminal window to set up Kubernetes port-forwarding to access the Grafana dashboard.

```bash
export POD_NAME=$(kubectl --namespace prometheus get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=prometheus" -oname)
kubectl --namespace prometheus port-forward $POD_NAME 3000
```

Grafana will be available at http://localhost:3000. The default Grafana credentials are `admin/prom-operator`.

The dashboard will be accessible via `Dashboards > Kepler Exporter Dashboard`

![grafana-dashboards-list](/images/grafana-dashboards-list-kepler.png)

### 4- Deploy the OpenTelemetry Operator

This example runs a Python client and server app that have been instrumented with [OpenTelemetry](https://opentelemetry.io) via a combination of [code-based](https://opentelemetry.io/docs/concepts/instrumentation/code-based/) and [zero-code](https://opentelemetry.io/docs/concepts/instrumentation/zero-code/) instrumentation.

Instrumentation is sent to an [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/), which is deployed via the [OpenTelemetry Operator for Kubernetes](https://opentelemetry.io/docs/platforms/kubernetes/operator/).

Deploying the Operator:

```bash
./src/scripts/02-install-otel-operator.sh
```

### 5- Build and publish images to image registry (Optional)

If you would like to build container images of the example Python code yourself and deploy it to your own container registry, you are more than welcome to do so. Otherwise, feel free to skip this step and pull the images from my registry. 😁

The script in this section publishes the container images to the [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry).

Just make sure that you:

1. Replace `IMAGE_PREFIX` in [.env](/.env) with your own image registry information
2. Update `image` in [06-python-client.yaml](/src/k8s/06-python-client.yaml), [07-python-server.yaml](/src/k8s/07-python-app.yaml), and [08-python-app.yaml](/src/k8s/08-python-server.yaml) to reflect the correct image name.
3. Make the images public after publishing, otherwise you'll need to do [some additional configuration to pull images from a private registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).

Build and publish images:

```bash
GH_TOKEN="<your_github_access_token>"
GH_USERNAME="<your_github_username>"

./src/scripts/03-build-and-publish-images.sh $GH_TOKEN $GH_USERNAME
```

### 6- Deploy the Kubernetes resources

This will deploy the exmaple Python code (client and server app), plus a Python app that emits Prometheus-style metrics. It will also deploy an `OpenTelemetryCollector` resource, which deploys an OpenTelmetry Collector and Target Allocator.

Deploy the manifests:

```bash
./src/scripts/04-deploy-resources.sh
```

Tail OTel Collector logs:

```bash
kubectl logs -l app.kubernetes.io/component=opentelemetry-collector -n opentelemetry --follow
```

List metrics (mostly):

```bash
kubectl logs otelcol-collector-0 -n opentelemetry | grep "Name:" | sort | uniq
```

### 7- View the traces in Jaeger

First, open up a new terminal window, and set up port-forwrading.

```bash
kubectl port-forward svc/otel-jaeger-query -n opentelemetry 16686:16686
```

Jaeger will be available at http://localhost:16686.

![jager UI](/images/jaeger-ui.png)

### 8- View the OTel Collector energy consumption

Once the app has been running for a while, you'll be able to view the OTel Collector's energy consumption.

Go to Grafana at http://localhost:3000, and naviagate to `Dashboards > Kepler Exporter Dashboard`.

Next, select `otelcol-collector-0` from the `Pod` dropdown, to view the power consumption and carbon emissions of your Collector.

![otel collector kepler dashboard](/images/otel-collector-consumption.png)


## Nukify

Nukify resoruces from the Kubernetes cluster without nukifying the cluster itself.

```bash
# Uninstall Kepler
helm delete kepler --namespace kepler

# Uninstall Kube Prometheus Stack
helm delete prometheus --namespace prometheus

# Uninstall Grafana
helm delete grafana --namespace grafana
```

## Note from Henrik

# k8s transform processor configuration

Exammple [here](https://raw.githubusercontent.com/Dynatrace/snippets/master/technologies/open-telemetry/open-telemetry-demo-application-dashboard/otel-demo-helm-values.yaml)

Snippet:

```yaml
processors:
  transform:
    error_mode: ignore
    metric_statements:
      - context: resource
        statements:
            - set(attributes["k8s.container.name"], attributes["container_name"]) where attributes["container_name"] != nil
            - set(attributes["k8s.pod.name"], attributes["pod_name"]) where attributes["pod_name"] != nil
            - set(attributes["k8s.namespace.name"], attributes["container_namespace"]) where attributes["container_namespace"] != nil
```

The above allows us to re-use existing vars in Grafana (standardized semantics) -> need to ask Henrik again what this means

# Enable process metrics

This value in `values.yaml` collects metrics on individual processes, and as a result, increases metrics cardinality:
`ENABLE_PROCESS_METRICS: "true"`
https://github.com/Observe-Resolve/observeresolve-keplermetric/blob/0f64c162971740204fc932b6bcf604e1c6615b41/kepler/values.yaml#L61


More on Kepler configuration [here](https://sustainable-computing.io/usage/general_config/).

To reduce metrics cardinality, add [this scrape config](https://github.com/henrikrexed/Sustainability-workshop/blob/9408e93dcb6b2bd892f9e0c1e13c0eb9caaa507d/opentelemetry/openTelemetry-manifest_statefulset.yaml#L83-L86
) to Prometheus receiver

Dynatrace dashboard [here](https://github.com/Observe-Resolve/observeresolve-keplermetric/blob/master/dynatrace/Kepler%20Energy%20usage.json
). Try to create Grafana equivalent.

Bonus: Aether project gives you more specific metrics for cloud provider: 
- https://github.com/re-cinq/aether-kepler-source
- https://github.com/re-cinq/aether

Henrik's sustainability tips:
1. Measure - if you don't know wha tyou're measuring you can't improve
           - include energy consumption as main KPI on your CI/CD pipelines
2. Optimize - pick and choose right locaiton for workload
3. Profiling
4. Optimize on resource allocation
5. KubeGreen to shut down collectors on test envs

** Instead of doing big things, use smaller things (e.g smaller collectors instead of giant one)
** Some languages are more environmentally unfriendly than others (e.g. Python consumes a lot of energy). See stats [here](https://softjourn.com/insights/environmentally-friendly-programming-languages).


## Additional crap

This shows the energy calculation done by Keptn (maybe we can retool this for Grafana).

`(sum(kepler_container_joules_total{pod_name=~"{{.pod}}.*",container_namespace="{{.ns}}"})/sum(kepler_container_joules_total{container_namespace="{{.ns}}"}))*100'`


Reference repos from Henrik:
- https://github.com/henrikrexed/Sustainability-workshop/blob/master/deployment.sh
- https://github.com/Observe-Resolve/observeresolve-keplermetric/blob/master/deployment.sh



## Additional stuff:

kubectl create secret generic dynatrace  --from-literal=dynatrace_oltp_url="$DTURL" --from-literal=clustername="$CLUSTERNAME"  --from-literal=clusterid=$CLUSTERID  --from-literal=dt_api_token="$DTTOKEN"