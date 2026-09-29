provider "kind" {}

resource "kind_cluster" "this" {
  for_each = var.clusters

  name           = each.key
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
    }
  }
}

provider "kubernetes" {
  alias = "cloud_a"
  config_path = kind_cluster.this["cloud-a"].kubeconfig_path
}

provider "kubernetes" {
  alias = "cloud_b"
  config_path = kind_cluster.this["cloud-b"].kubeconfig_path
}

resource "kubernetes_namespace" "app_cloud_a" {
  provider = kubernetes.cloud_a
  metadata {
    name = "app"
  }
  depends_on = [kind_cluster.this]
}

resource "kubernetes_namespace" "app_cloud_b" {
  provider = kubernetes.cloud_b
  metadata {
    name = "app"
  }
  depends_on = [kind_cluster.this]
}