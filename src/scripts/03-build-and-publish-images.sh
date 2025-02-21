#! /bin/bash

GH_TOKEN=$1
GH_USERNAME=$2

if [ -z "${GH_TOKEN}" ] || [ -z "${GH_USERNAME}" ] ; then
    echo "One or more empty input variables. Usage: ./src/scripts/03-build-and-publish-images.sh <GH_TOKEN> <GH_USERNAME>"
    exit 1
fi

docker buildx create --use

echo $GH_TOKEN | docker login ghcr.io -u $GH_USERNAME --password-stdin

docker buildx bake --push