# OpenTelemetry Collector Builder (OCB) Notes

These are the instructions for building the OpenTelemetry Collector distribution used by this example.

[The OpenTelemetry Collector Builder (OCB)](https://opentelemetry.io/docs/collector/custom-collector/) is used to build custom OpenTelemetry Collector distributions. This ensures that your distribution only has the components that you need, and reduces needless bloat.

The instructions below show you how to build an OTel Collector which uses only the compoents required by the Collector in this repo.

You do not need to run these steps unless you want to build a Collector image yourself using the OCB. The Docker image used by this repo is already available in GitHub Container Registry via:

```bash
docker pull ghcr.io/avillela/otelcol-kepler-benchmark-0.102.1:0.1.0
```

## Steps

### 1- Build the Collector image

Build the Docker image that builds a Collector image using the OCB, and push it to GitHub.

This approach ensures that it builds an arch-appropriate image.

> 🚨 **NOTE:** The amd64 build is finnicky on Podman.

```bash
GH_TOKEN=<your_github_token>
GH_USERNAME=<your_github_username>

echo $GH_TOKEN | docker login ghcr.io -u $GH_USERNAME --password-stdin
cd src/ocb

# Enable Docker multi-arch builds
docker run -it --rm --privileged tonistiigi/binfmt --install all
docker buildx create --name mybuilder --use

# Build using docker-compose-collector.yaml, as per the archs specified in that file
docker buildx bake --push -f docker-compose-collector.yaml
```

If you prefer to build using plain 'ole Docker:

```bash
# Build
docker build -t ghcr.io/${GH_USERNAME}/otelcol-kepler-benchmark-0.102.1:0.1.0 .

docker buildx build --push \
  -t ghcr.io/${avillela}/otelcol-kepler-benchmark-0.102.1:0.1.0 \
  --platform=linux/arm64,linux/amd64 .
```

PS: If you want to build the docker image without pushing to the Docker registry, run:

```bash
docker buildx build --platform=linux/amd64,linux/arm64 \
  -t test:0.1.0 \
  -f Dockerfile.v3 . \
  --load
```

### 2- Test

Make sure that the build actually worked

```bash
docker run -it --rm -p 4317:4317 -p 4318:4318 \
  ghcr.io/avillela/otelcol-kepler-benchmark-0.102.1:0.1.0
```

The image was built with a test config file, and the image will use this config file if none is provided.

## References

* [Reverse-engineer a Docker image](https://stackoverflow.com/a/63050461)
* [OTel Collector Dockerfile](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/cmd/otelcontribcol/Dockerfile)
* [Go modules for Collector core](https://pkg.go.dev/go.opentelemetry.io/collector)
* [Go modules for Collector contrib](https://pkg.go.dev/github.com/open-telemetry/opentelemetry-collector-contrib)
* [Multi-Archi Go + Docker stuff](https://gist.github.com/AverageMarcus/78fbcf45e72e09d9d5e75924f0db4573)
* [Medium article for multi arch stuff](https://archive.ph/m9lPH)
* [More Multi-Arch stuff](https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/)