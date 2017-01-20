# Kubelet Starter
A smart program that figures out the right version of kubelet to run on

(Original design docs [here](https://docs.google.com/document/d/1CeDd3ytwnHkFVDjkGBJk1OrFYxquRu4z5sujkK2owMA/edit#))

### Background

Today, the kubelet version is pre-seeded by cloud-config or ignition data, it means when an existing node reboots,
or a new node is added to an existing cluster, the kubelet will likely be started at an older version than the up-to-date cluster.

To address this, we create this program (`Kubelet Starter`) so that we can deploy a kubelet (so far it's a systemd service) without seeded knowledge of what version it should be running,
The program will be able to retrieve the version information from the Kubernetes API.

### Design

#### Lifecycle

`Kubelet Starter` is expected to run once on every boot, before pulling/running the kubelet.
After boot, it will found itself in one of the following scenarios:

**I am the first node in bootstrap**
This happens when the node doesn't have a local kubelet environment file at `/etc/kubernetes/kubelet.env`, which means the kubelet has never started before.
In this case, the `Kubelet Starter` will contact the API server to get the right kubelet version for running (see next section for more details).

**I am a new node that's joining an existing cluster**
This is similar to the above case, the only difference is the `Kubelet Starter` will contact the existing API server instead of a bootkube api-server.

**I am an existing node that's joining an existing cluster**
This happens when `/etc/kubernetes/kubelet.env` already exists, in which case the `Kubelet Starter` will do nothing and exit quietly.

#### How to Get the Right Version

TODO(yifan): Fill this.

#### How to Upgrade of Kubelet Starter Itself

We maintain and host docker images for `Kubelet Starter`, so users will always be using the latest stable version of the program.
Typically we will make a docker image for every stable version of the `Kubelet Starter`, and also tag the `latest` image to point to the most recent one.
(Caveat: This means the `Kubelet Starter` always needs to be backward-compatible to support old Kubernetes API).
