FROM scratch
COPY bin/kube-version /kube-version
ENTRYPOINT ["/kube-version"]
