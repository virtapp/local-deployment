resource "kubernetes_deployment" "echoserver" {
  metadata {
    name = "echoserver-app-nginx"
    namespace = kubernetes_namespace.echoserver.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "echoserver-app-nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "echoserver-app-nginx"
          version = "1.4"
        }
      }

      spec {
        container {
          image = "gcr.io/google_containers/echoserver:1.4"
          name  = "echoserver"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
