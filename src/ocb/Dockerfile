# This Dockerfile was provided by OTel Operator maintainer Jacob Aronoff. It is magical. That is all.
FROM alpine:3.19 AS certs
RUN apk --update add ca-certificates

FROM golang:1.23.6 AS build-stage
WORKDIR /usr/bin/otelcol

COPY ./builder-config.yaml manifest.yaml
COPY ./otelcol-config.yaml config.yaml

RUN --mount=type=cache,target=/root/.cache/go-build GO111MODULE=on go install go.opentelemetry.io/collector/cmd/builder@v0.102.1
RUN mkdir -p ./_build/col && chmod +x ./_build/col
RUN --mount=type=cache,target=/root/.cache/go-build builder --config manifest.yaml

FROM gcr.io/distroless/base:latest

ARG USER_UID=10001
USER ${USER_UID}


COPY --from=build-stage /usr/bin/otelcol/config.yaml /etc/otelcol-contrib/config.yaml
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --chmod=755 --from=build-stage /usr/bin/otelcol/_build/col /otelcol

ENTRYPOINT ["/otelcol/otelcol-kepler-benchmark"]
CMD ["--config", "/etc/otelcol-contrib/config.yaml"]

# `4137` and `4318`: OTLP
# `12001`: remotettap
EXPOSE 4317 4318 12001 55680 55679