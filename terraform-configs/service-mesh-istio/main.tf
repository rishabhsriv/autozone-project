provider "kubernetes" {
  config_context_cluster   = "minikube"
  config_path = "~/.kube/config"
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


resource "kubernetes_namespace" "istio_ns" {
  metadata {
    name = "istio-system"
  }
}

# Later on we should create a module for istio
# Need to check how we can use the istio version here
# Installing istio base
resource "helm_release" "istio-base" {
  name      = "istio-base"
  chart     = "./istio-config/istio/manifests/charts/base"
  namespace = "istio-system"
}

# Installing istiod
resource "helm_release" "istiod" {
  name      = "istiod"
  chart     = "./istio-config/istio/manifests/charts/istio-control/istio-discovery"
  namespace = "istio-system"

  depends_on = [
    helm_release.istio-base
  ]

}

# Installing istio-ingress
resource "helm_release" "istio-ingress" {
  name      = "istio-ingress"
  chart     = "./istio-config/istio/manifests/charts/gateways/istio-ingress"
  namespace = "istio-system"

  depends_on = [
    helm_release.istio-base,
    helm_release.istiod
  ]

}