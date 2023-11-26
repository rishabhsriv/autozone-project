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

resource "null_resource" "provision_istio" {
  provisioner "local-exec" {
    command = "sh ../../../../modules/service-mesh/istio/setup.sh"
  }
}

# Installing istio base
resource "helm_release" "istio-base" {
  name      = "istio-base"
  chart     = "./istio-1.20.0/manifests/charts/base"
  namespace = "istio-system"

  depends_on = [
    null_resource.provision_istio
  ]

}

# Installing istiod
resource "helm_release" "istiod" {
  name      = "istiod"
  chart     = "./istio-1.20.0/manifests/charts/istio-control/istio-discovery"
  namespace = "istio-system"

  depends_on = [
    null_resource.provision_istio,
    helm_release.istio-base
  ]

}

# Installing istio-ingress
resource "helm_release" "istio-ingress" {
  name      = "istio-ingress"
  chart     = "./istio-1.20.0/manifests/charts/gateways/istio-ingress"
  namespace = "istio-system"

  depends_on = [
    null_resource.provision_istio,
    helm_release.istio-base,
    helm_release.istiod
  ]
}
