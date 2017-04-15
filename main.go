package main

import (
	"flag"
	"fmt"

	"github.com/golang/glog"

	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
)

var kubeconfig string

func init() {
	flag.StringVar(&kubeconfig, "kubeconfig", "", "Kubeconfig file")
}

func main() {
	flag.Parse()

	if kubeconfig == "" {
		glog.Fatalf("Missing --kubeconfig")
	}

	config, err := clientcmd.BuildConfigFromFlags("", kubeconfig)
	if err != nil {
		glog.Fatalf("Failed to build config: %v", err)
	}

	client := kubernetes.NewForConfigOrDie(config)
	version, err := client.ServerVersion()
	if err != nil {
		glog.Fatalf("Failed to get server version: %v", err)
	}

	fmt.Println(version.GitVersion)
}
