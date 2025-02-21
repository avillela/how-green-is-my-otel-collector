# Python OTel App

This Python app is made up of a:
* Client
* Server
* Metrics-emitting app

The client requests the `/rolldice` endpoint at http://localhost:8082/rolldice. The endpoint is Python Flask server that rolls a virtual die and outputs a number between 1 and 6.

This app emits OTel traces via a combination of [code-based](https://opentelemetry.io/docs/concepts/instrumentation/code-based/) and [zero-code](https://opentelemetry.io/docs/concepts/instrumentation/zero-code/) instrumentation. 

The app also emits metrics, and some logs (code-based). The logs are emitted via Python logs auto-instrumentation and the logs bridge API.

![python client server app architecture](/images/otel-python-client-server-app.png)

The metrics-emitting app is independent of the client and server app. All it does is emitt Prometheus-style metrics which are ingested via the [OTel Collector](https://opentelemetry.io/docs/collector/), aided by the [Target Allocator](https://opentelemetry.io/docs/platforms/kubernetes/operator/target-allocator/).

![python prometheus metrics app](/images/otel-python-prometheus-app.png)

For more information, check out these articles:
* [Prometheus & OpenTelemetry: Better Together](https://adri-v.medium.com/prometheus-opentelemetry-better-together-41dc637f2292)
* [Dude, Where's My Error](https://adri-v.medium.com/dude-wheres-my-error-52dc52b25909)
* [Tips for Troubleshooting the Target Allocator](https://adri-v.medium.com/tips-for-troubleshooting-the-target-allocator-de9eca2b78b4)
* [Things You Might Not Have Known About the OpenTelemetry Operator](https://medium.com/dzerolabs/otel-operator-q-a-81d63addbf92)
