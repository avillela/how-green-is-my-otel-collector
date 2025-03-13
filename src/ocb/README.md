# OpenTelemetry Collector Builder (OCB) Notes

These are the instructions for building the OpenTelemetry Collector distribution used by this example.

[The OpenTelemetry Collector Builder (OCB)](https://opentelemetry.io/docs/collector/custom-collector/) is used to build custom OpenTelemetry Collector distributions. This ensures that your distribution only has the components that you need, and reduces needless bloat.

The instructions below show you how to build an OTel Collector which uses only the compoents required by the Collector in this repo.

> **NOTE:** The OCB tool has [already been installed](/.devcontainer/post-create.sh) as part of the DevContainer for this repo;


## Steps

### 1- Build the Collector binary

Use the OCB tool to build the Collector binary with the components that we need.

```bash
cd src/ocb
ocb --config builder-config.yaml
```

### 2- Build the Collector image

Build a Docker image of our newly-created Collector binary.

I could've run the builder directly in the Dockerfile, but I was lazy and decided to snag the one from the [OTel Collector repo](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/cmd/otelcontribcol/Dockerfile).

```bash
docker buildx bake --push -f docker-compose-collector.yaml
```

## References

* [Reverse-engineer a Docker image](https://stackoverflow.com/a/63050461)
* [OTel Collector Dockerfile](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/cmd/otelcontribcol/Dockerfile)
* [Go modules for Collector core](https://pkg.go.dev/go.opentelemetry.io/collector)
# [Go modules for Collector contrib](https://pkg.go.dev/github.com/open-telemetry/opentelemetry-collector-contrib)