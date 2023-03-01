###-devtron
resource "helm_release" "devtron" {
  name       = "devtron"
  repository = "https://helm.devtron.ai"
  chart      = "devtron-operator"
  version    = var.devtron_helm_version

  namespace        = var.devtron_namespace
  create_namespace = true

  values = [file("config/devtron-value.yaml")]

  timeout = 600000

  depends_on = [kind_cluster.default]

  set {
    name  = "components.devtron.service.type"
    value = "ClusterIP"
  }
}

resource "kubernetes_ingress" "ingress-route-devtron" {
  metadata {
    name = "ingress-route-devtron"
    namespace = "devtroncd"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/affinity" = "cookie"
      "nginx.ingress.kubernetes.io/session-cookie-expires" = "172800"
      "nginx.ingress.kubernetes.io/session-cookie-max-age" = "172800"
      "nginx.ingress.kubernetes.io/session-cookie-name" = "route"
    }
  }

  spec {
    rule {
      host = "app-dev.virtapp.io"

      http {
        path {
          path = "/"

          backend {
            service_name = "devtron-service"
            service_port = "80"
          }
        }
      }
     }
      tls {
      secret_name = "virtapp"
    }
  }
   depends_on = [helm_release.devtron]
}

