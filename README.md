# Reddit Clone App on Kubernetes with Istio ingressgateway
This project demonstrates how to deploy a Reddit clone app on Kubernetes with istio ingress gateway on a k8s cluster.


## Prerequisites
Before you begin, you should have the following tools installed on your local machine: 

- Docker
- K8s cluster ( Running )
- kubectl
- Git


## Installation
Follow these steps to install and run the Reddit clone app on your local machine:

1) Build the Docker image for the Reddit clone app: `docker build -t test-app:latest -f ./Dockerfile .`
2) Deploy the app to Kubernetes: `helm upgrade -f values.yml {release name} {package name or path} --version {fixed-version}`


## Test Ingress DNS for the app:
- Test Ingress by typing this command: `curl http://domain.com/test`


Pre Requisites :
- K8s Cluster is setup already or install minikube
- Install Helm


Installation Steps 
```sh
   helm repo add istio https://istio-release.storage.googleapis.com/charts
   helm install istio-base --namespace istio-system istio/base --version 1.18
   helm install istiod --namespace istio-system istio/istiod --version 1.18
   helm install istio-ingressgateway --namespace istio-system istio/gateway --version 1.18 -f aks-values.yaml
```


