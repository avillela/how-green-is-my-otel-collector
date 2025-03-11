# Errors

## RBAC

```
W0311 22:14:55.692810       1 reflector.go:539] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: failed to list *v1.Deployment: deployments.apps is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "deployments" in API group "apps" at the cluster scope
E0311 22:14:55.692869       1 reflector.go:147] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: Failed to watch *v1.Deployment: failed to list *v1.Deployment: deployments.apps is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "deployments" in API group "apps" at the cluster scope
W0311 22:14:55.827642       1 reflector.go:539] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: failed to list *v1.Namespace: namespaces is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "namespaces" in API group "" at the cluster scope
E0311 22:14:55.827690       1 reflector.go:147] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: Failed to watch *v1.Namespace: failed to list *v1.Namespace: namespaces is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "namespaces" in API group "" at the cluster scope
```

```
W0311 22:21:32.663915       1 reflector.go:539] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: failed to list *v1.Pod: pods is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "pods" in API group "" at the cluster scope
W0311 22:21:32.663956       1 reflector.go:539] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: failed to list *v1.Namespace: namespaces "kube-system" is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "namespaces" in API group "" at the cluster scope
E0311 22:21:32.664233       1 reflector.go:147] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: Failed to watch *v1.Namespace: failed to list *v1.Namespace: namespaces "kube-system" is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "namespaces" in API group "" at the cluster scope
E0311 22:21:32.664267       1 reflector.go:147] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: Failed to watch *v1.Pod: failed to list *v1.Pod: pods is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "pods" in API group "" at the cluster scope
W0311 22:21:33.593451       1 reflector.go:539] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: failed to list *v1.Pod: pods is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "pods" in API group "" at the cluster scope
E0311 22:21:33.593511       1 reflector.go:147] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: Failed to watch *v1.Pod: failed to list *v1.Pod: pods is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "pods" in API group "" at the cluster scope
W0311 22:21:34.217249       1 reflector.go:539] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: failed to list *v1.Namespace: namespaces "kube-system" is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "namespaces" in API group "" at the cluster scope
E0311 22:21:34.217319       1 reflector.go:147] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: Failed to watch *v1.Namespace: failed to list *v1.Namespace: namespaces "kube-system" is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "namespaces" in API group "" at the cluster scope
W0311 22:21:35.227141       1 reflector.go:539] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: failed to list *v1.Pod: pods is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "pods" in API group "" at the cluster scope
E0311 22:21:35.227194       1 reflector.go:147] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: Failed to watch *v1.Pod: failed to list *v1.Pod: pods is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "pods" in API group "" at the cluster scope
W0311 22:21:36.695885       1 reflector.go:539] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: failed to list *v1.Namespace: namespaces "kube-system" is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "namespaces" in API group "" at the cluster scope
E0311 22:21:36.696009       1 reflector.go:147] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: Failed to watch *v1.Namespace: failed to list *v1.Namespace: namespaces "kube-system" is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "namespaces" in API group "" at the cluster scope
W0311 22:21:38.875537       1 reflector.go:539] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: failed to list *v1.Pod: pods is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "pods" in API group "" at the cluster scope
E0311 22:21:38.875585       1 reflector.go:147] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: Failed to watch *v1.Pod: failed to list *v1.Pod: pods is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "pods" in API group "" at the cluster scope
W0311 22:21:42.540100       1 reflector.go:539] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: failed to list *v1.Namespace: namespaces "kube-system" is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "namespaces" in API group "" at the cluster scope
E0311 22:21:42.540157       1 reflector.go:147] k8s.io/client-go@v0.29.3/tools/cache/reflector.go:229: Failed to watch *v1.Namespace: failed to list *v1.Namespace: namespaces "kube-system" is forbidden: User "system:serviceaccount:opentelemetry:otelcontribcol" cannot list resource "namespaces" in API group "" at the cluster scope
```

## TargetAllocator

```
Error: cannot start pipelines: Get "http://otelcol-targetallocator:80/scrape_configs": dial tcp 34.118.227.31:80: i/o timeout                    │
│ 2025/03/11 21:47:37 collector server run finished with error: cannot start pipelines: Get "http://otelcol-targetallocator:80/scrape_configs": di │
│ al tcp 34.118.227.31:80: i/o timeout
```

## KubeletStatsReceiver

```
2025-03-11T21:51:29.940Z    error    kubeletstatsreceiver@v0.102.0/scraper.go:101    call to /stats/summary endpoint failed    {"kind": "receive │
│ github.com/open-telemetry/opentelemetry-collector-contrib/receiver/kubeletstatsreceiver.(*kubletScraper).scrape                                  │
│     github.com/open-telemetry/opentelemetry-collector-contrib/receiver/kubeletstatsreceiver@v0.102.0/scraper.go:101                              │
│ go.opentelemetry.io/collector/receiver/scraperhelper.ScrapeFunc.Scrape                                                                           │
│     go.opentelemetry.io/collector/receiver@v0.102.1/scraperhelper/scraper.go:20                                                                  │
│ go.opentelemetry.io/collector/receiver/scraperhelper.(*controller).scrapeMetricsAndReport                                                        │
│     go.opentelemetry.io/collector/receiver@v0.102.1/scraperhelper/scrapercontroller.go:194                                                       │
│ go.opentelemetry.io/collector/receiver/scraperhelper.(*controller).startScraping.func1                                                           │
│     go.opentelemetry.io/collector/receiver@v0.102.1/scraperhelper/scrapercontroller.go:169                                                       │
│ 2025-03-11T21:51:29.940Z    error    scraperhelper/scrapercontroller.go:197    Error scraping metrics    {"kind": "receiver", "name": "kubeletst │
│ go.opentelemetry.io/collector/receiver/scraperhelper.(*controller).scrapeMetricsAndReport                                                        │
│     go.opentelemetry.io/collector/receiver@v0.102.1/scraperhelper/scrapercontroller.go:197                                                       │
│ go.opentelemetry.io/collector/receiver/scraperhelper.(*controller).startScraping.func1                                                           │
│     go.opentelemetry.io/collector/receiver@v0.102.1/scraperhelper/scrapercontroller.go:169                                                       │
│ 2025-03-11T21:51:49.879Z    error    kubeletstatsreceiver@v0.102.0/scraper.go:101    call to /stats/summary endpoint failed    {"kind": "receive │
│ github.com/open-telemetry/opentelemetry-collector-contrib/receiver/kubeletstatsreceiver.(*kubletScraper).scrape                                  │
│     github.com/open-telemetry/opentelemetry-collector-contrib/receiver/kubeletstatsreceiver@v0.102.0/scraper.go:101                              │
│ go.opentelemetry.io/collector/receiver/scraperhelper.ScrapeFunc.Scrape                                                                           │
│     go.opentelemetry.io/collector/receiver@v0.102.1/scraperhelper/scraper.go:20                                                                  │
│ go.opentelemetry.io/collector/receiver/scraperhelper.(*controller).scrapeMetricsAndReport                                                        │
│     go.opentelemetry.io/collector/receiver@v0.102.1/scraperhelper/scrapercontroller.go:194                                                       │
│ go.opentelemetry.io/collector/receiver/scraperhelper.(*controller).startScraping.func1                                                           │
│     go.opentelemetry.io/collector/receiver@v0.102.1/scraperhelper/scrapercontroller.go:173                                                       │
│ 2025-03-11T21:51:49.879Z    error    scraperhelper/scrapercontroller.go:197    Error scraping metrics    {"kind": "receiver", "name": "kubeletst │
│ go.opentelemetry.io/collector/receiver/scraperhelper.(*controller).scrapeMetricsAndReport                                                        │
│     go.opentelemetry.io/collector/receiver@v0.102.1/scraperhelper/scrapercontroller.go:197                                                       │
│ go.opentelemetry.io/collector/receiver/scraperhelper.(*controller).startScraping.func1                                                           │
│     go.opentelemetry.io/collector/receiver@v0.102.1/scraperhelper/scrapercontroller.go:173                                                       │
│ 2025-03-11T21:51:58.878Z    error    prometheusreceiver@v0.102.0/metrics_receiver.go:154    Failed to retrieve job list    {"kind": "receiver",  │
│ github.com/open-telemetry/opentelemetry-collector-contrib/receiver/prometheusreceiver.(*pReceiver).syncTargetAllocator                           │
│     github.com/open-telemetry/opentelemetry-collector-contrib/receiver/prometheusreceiver@v0.102.0/metrics_receiver.go:154                       │
│ github.com/open-telemetry/opentelemetry-collector-contrib/receiver/prometheusreceiver.(*pReceiver).startTargetAllocator                          │
│     github.com/open-telemetry/opentelemetry-collector-contrib/receiver/prometheusreceiver@v0.102.0/metrics_receiver.go:123  
```