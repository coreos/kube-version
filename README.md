# Kube Version
A small program that figures out the current version of Kubernetes.

(Original design docs [here](https://docs.google.com/document/d/1CeDd3ytwnHkFVDjkGBJk1OrFYxquRu4z5sujkK2owMA/edit#))

### Background

Today, the kubelet version is pre-seeded by cloud-config and ignition data, it means when an existing node reboots,
or a new node is added to an existing cluster, the kubelet will likely be started at an older version than the up-to-date cluster.

To address this, we create this shim program so that we can deploy a kubelet service without seeded knowledge of what version it should be running,
The program will be able to retrieve the version information from the Kubernetes API.

### Design

The shim program takes a `kubeconfig` and requests the `/version` API endpoint to get the current Kubernetes server's version.

### Why not using kubectl?

- We can use kubectl, but even that we still need to maintain the container image for kubectl and bump it when new version comes out.
- The kubectl image is about twice as big as this shim program (70MB vs 30MB).
- The shell to extract the output of `kubectl version` seems a little bit fragile.

### Usage

```shell
./bin/kubernetes-versioner --kubeconfig=my_kubeconfig
v1.5.5+coreos.0
```

### Build

```shell
make
PUSH_IMAGE=true make image
```

The images are hosted on [quay.io/coreos/kube-verion](https://quay.io/repository/coreos/kube-version?tab=tags)
