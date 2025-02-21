# Use Pulumi Python SDK to Create a Kubernetes Cluster in Google Cloud

1- Google Cloud authentication

Log into Google Cloud and set the project name

```bash
gcloud auth login
gcloud config set project <your_project_name>
gcloud auth application-default login
```

2- Navigate to the Pulumi directory

```bash
cd src/pulumi/gke-cluster
```

3- Initialize Pulumi

This example assumes that your stack is located in [app.pulumi.com](https://app.pulumi.com). As a pre-requisite, you'll get set up an account [here](https://app.pulumi.com/). The service is free for personal use.

Create a new Pulumi project under your account. This is done one-time only. This will overwrite everything in this directiory, which is fine, because we haven't made any changes to the code.

```bash
pulumi new https://github.com/avillela/how-green-is-my-otel-collector \
    -n kepler-gke-cluster \
    -s dev \
    -d "Provision a GKE cluster" -y --force
```

Initialize and select the `dev` stack.

```bash
pulumi stack select dev
```

Fully-qualified stackname: https://app.pulumi.com/<your_pulumi_username>/kepler-gke-cluster/dev

4- Provision infrastructure

```bash
# Preview changes
pulumi preview

# Run plan
pulumi up -y
```

To destroy your infrastructure, run:

```bash
pulumi destroy -y
```

