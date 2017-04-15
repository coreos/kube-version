#!/bin/bash
set -euo pipefail

IMAGE_REPO=${IMAGE_REPO:-quay.io/coreos/kube-version}

readonly REPO_ROOT=$(git rev-parse --show-toplevel)
readonly VERSION=${VERSION:-$(${REPO_ROOT}/build/git-version.sh)}

sudo rkt run --uuid-file-save=rkt.uuid \
    --volume tco,kind=host,source=${REPO_ROOT} \
    --mount volume=tco,target=/go/src/github.com/coreos-inc/kube-version \
    --insecure-options=image docker://golang:1.7.5 --exec /bin/bash -- -c \
    "cd /go/src/github.com/coreos-inc/kube-version && make clean all"

sudo rkt rm --uuid-file=rkt.uuid
rm -f rkt.uuid

cd ${REPO_ROOT} && docker build -t ${IMAGE_REPO}:${VERSION} .

if [[ ${PUSH_IMAGE:-false} == "true" ]]; then
    docker push ${IMAGE_REPO}:${VERSION}
fi
