# Use Pulumi Python SDK to Create a Kubernetes Cluster in Google Cloud

1- gCloud authentication

Log into GCP

```bash
gcloud config set project <your_project_name>
gcloud auth application-default login
```

Make sure that the [Kubernetes Engine API is enabled](https://console.cloud.google.com/apis/api/container.googleapis.com) for your project.

Make sure that `gke-gcloud-auth-plugin` is enabled. To enable it, run:

```bash
sudo apt-get install google-cloud-cli-gke-gcloud-auth-plugin
gcloud auth login
```

2- Set up Python with Pulumi

```bash
cd src/pulumi/gke-cluster-example

# Set up virtualenv
pip install virtualenv
virtualenv venv
source  venv/bin/activate
python -m pip install --upgrade pip

# Install requirements Pulumi + GCP + GKE
pip install -r requirements.txt
```

3- Initialize Pulumi

This example assumes that you're using app.pulumi.com to store your stack. As a pre-requisite, you'll get set up [here](https://app.pulumi.com/). The service is free for personal use.

```bash
# One-time only
pulumi stack init dev
```

Additional commands

Fully-qualified stackname: https://app.pulumi.com/<user_id>/<project_name>/<stack_name>

```bash
# Select stack
pulumi stack select <stackname>

# Use delete stack
pulumi stack rm <stackname> -f

# List stacks
pulumi stack ls
```

4- Configure GCP project in Pulumi

This configuration is one-time only.

```bash
pulumi config set gcp:project <your_project_name>
pulumi config set gcp:region <region>
pulumi config set gcp:zone <zone>
```

Find compute zones and regions

```bash
gcloud compute zones list
```


5- Provision infrastructure

```bash
# When starting a new session
pulumi stack select <stackname>

# Run plan
pulumi up -y

# Preview changes
pulumi preview

# Destroy infrastructure
pulumi destroy

# Destroy the stack
pulumi stack rm
```

