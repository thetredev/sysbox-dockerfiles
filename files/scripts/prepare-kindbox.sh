#!/bin/bash

set -e

# pull kubernetes images via kubeadm
kubeadm config images pull

# pull additional images
docker image pull flannel/flannel:v0.25.4
docker image pull docker.io/weaveworks/weave-kube:2.8.1
docker image pull docker.io/weaveworks/weave-npc:2.8.1
docker image pull quay.io/tigera/operator:release-v1.35-amd64
