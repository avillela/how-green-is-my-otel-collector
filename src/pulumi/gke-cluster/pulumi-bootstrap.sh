#!/bin/bash

# Reference
# https://www.pulumi.com/docs/iac/get-started/gcp/begin/
# https://www.pulumi.com/registry/packages/gcp/installation-configuration/ 

# gcloud setup
export GCP_PROJECT_NAME=$1
export GCP_REGION=$2
export GCP_ZONE=$3

if [ -z "${GCP_PROJECT_NAME}" ] || [ -z "${GCP_REGION}" ] || [ -z "${GCP_ZONE}" ]; then
    echo "One or more empty input variables. Usage: ./pulumi-bootstrap.sh <GCP_PROJECT_NAME> <GCP_REGION> <GCP_ZONE>"
    exit 1
fi

gcloud config set project ${GCP_PROJECT_NAME}
gcloud auth application-default login

# Python venv setup
pip install virtualenv
virtualenv venv
source  venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt

# Pulumi setup
pulumi new gcp-python \
    -n kepler-gke-cluster \
    -s dev \
    -d "Provision a GKE cluster" -y --force

pulumi stack init dev