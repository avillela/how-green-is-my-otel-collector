#! /bin/bash

export GH_TOKEN="<your_gh_pat>"
export GH_USER="<your_gh_username>"

docker buildx create --use

echo $GH_TOKEN | docker login ghcr.io -u $GH_USER --password-stdin

docker buildx bake --push