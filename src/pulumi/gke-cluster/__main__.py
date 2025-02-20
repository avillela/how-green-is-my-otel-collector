# Reference
# https://github.com/pulumi/examples/blob/master/gcp-py-gke/__main__.py

import os
from pathlib import Path

from pulumi import Config, export, get_project, get_stack, Output, ResourceOptions
from pulumi_gcp.config import project, zone
from pulumi_gcp.container import Cluster, get_engine_versions, NodePool, ClusterNodeConfigArgs
from pulumi_kubernetes import Provider
from pulumi_kubernetes.apps.v1 import Deployment, DeploymentSpecArgs
from pulumi_kubernetes.core.v1 import (
    ContainerArgs,
    PodSpecArgs,
    PodTemplateSpecArgs,
    Service,
    ServicePortArgs,
    ServiceSpecArgs,
)
from pulumi_kubernetes.meta.v1 import LabelSelectorArgs, ObjectMetaArgs
from pulumi_random import RandomPassword

# Read in some configurable settings for our cluster:
config = Config(None)

NODE_COUNT = config.get_int("node_count")
NODE_MACHINE_TYPE = config.get("node_machine_type")
IMAGE_TYPE = config.get("image_type")
DISK_TYPE = config.get("disk_type")
DISK_SIZE_GB = config.get("disk_size_gb")

# Note: if you get an error re: unsupported GKE version, try specifying a different zone
ENGINE_VERSION = get_engine_versions().latest_master_version
CLUSTER_NAME = config.get("cluster_name")
NODE_POOL_NAME = f"{CLUSTER_NAME}-node-pool"


# Now, actually create the GKE cluster.
k8s_cluster = Cluster(
    resource_name=CLUSTER_NAME,
    deletion_protection=False,
    initial_node_count=NODE_COUNT,
    node_version=ENGINE_VERSION,
    remove_default_node_pool=False,
    location=zone,
    min_master_version=ENGINE_VERSION,
    node_config=ClusterNodeConfigArgs(
        machine_type=NODE_MACHINE_TYPE,
        image_type=IMAGE_TYPE,
        disk_type=DISK_TYPE,
        disk_size_gb=DISK_SIZE_GB,
        oauth_scopes=[
            "https://www.googleapis.com/auth/compute",
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
            "https://www.googleapis.com/auth/cloud-platform",
        ],
    ),
)

# node_pool = NodePool(
#     resource_name=NODE_POOL_NAME,
#     cluster=k8s_cluster.name,
#     initial_node_count=NODE_COUNT,
#     location=zone,
#     node_config=ClusterNodeConfigArgs(
#         machine_type=NODE_MACHINE_TYPE,
#         image_type=IMAGE_TYPE,
#         disk_type=DISK_TYPE,
#         disk_size_gb=DISK_SIZE_GB,
#         oauth_scopes=[
#             "https://www.googleapis.com/auth/cloud-platform",
#         ],
#     ),
# )

# Manufacture a GKE-style Kubeconfig. Note that this is slightly "different" because of the way GKE requires
# gcloud to be in the picture for cluster authentication (rather than using the client cert/key directly).
k8s_info = Output.all(k8s_cluster.name, k8s_cluster.endpoint, k8s_cluster.master_auth)
k8s_config = k8s_info.apply(
    lambda info: """apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: {0}
    server: https://{1}
  name: {2}
contexts:
- context:
    cluster: {2}
    user: {2}
  name: {2}
current-context: {2}
kind: Config
preferences: {{}}
users:
- name: {2}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: gke-gcloud-auth-plugin
      installHint: Install gke-gcloud-auth-plugin for use with kubectl by following
        https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
      provideClusterInfo: true
""".format(
        info[2]["cluster_ca_certificate"],
        info[1],
        "{0}_{1}_{2}".format(project, zone, info[0]),
    )
)

export("kubeconfig", k8s_config)

# Write kubeconfig to file
def write_kubeconfig(content):
    kubeconfig_path = Path(os.path.expanduser(f"~/.kube"))
    filename = Path(os.path.expanduser(f"~/.kube/config"))
    kubeconfig_path.mkdir(parents=True, exist_ok=True)    
    filename.touch(exist_ok=True)
    with open(filename, "w") as file:
        file.write(content)
        
k8s_config.apply(lambda content: write_kubeconfig(content))

# Make a Kubernetes provider instance that uses our cluster from above.
k8s_provider = Provider("gke_k8s", kubeconfig=k8s_config)

# Create a canary deployment to test that this cluster works.
labels = {"app": "canary-{0}-{1}".format(get_project(), get_stack())}
canary = Deployment(
    "canary",
    spec=DeploymentSpecArgs(
        selector=LabelSelectorArgs(match_labels=labels),
        replicas=1,
        template=PodTemplateSpecArgs(
            metadata=ObjectMetaArgs(labels=labels),
            spec=PodSpecArgs(containers=[ContainerArgs(name="nginx", image="nginx")]),
        ),
    ),
    opts=ResourceOptions(provider=k8s_provider),
)

ingress = Service(
    "ingress",
    spec=ServiceSpecArgs(
        type="LoadBalancer",
        selector=labels,
        ports=[ServicePortArgs(port=80)],
    ),
    opts=ResourceOptions(provider=k8s_provider),
)

# Finally, export the kubeconfig so that the client can easily access the cluster.
export("kubeconfig", k8s_config)
# Export the k8s ingress IP to access the canary deployment
export(
    "ingress_ip",
    ingress.status.apply(lambda status: status.load_balancer.ingress[0].ip),
)