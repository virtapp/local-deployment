provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kind_cluster_config_path)
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}