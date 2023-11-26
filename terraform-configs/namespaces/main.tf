provider "kubernetes" {
  config_context_cluster   = "minikube"
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "autozone-namespace" {
  metadata {
        name = "autozone-dev"
  }
}
