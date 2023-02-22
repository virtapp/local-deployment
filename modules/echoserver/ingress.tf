resource "kubernetes_ingress" "example_ingress" {
  metadata {
    name = "example-ingress"
    namespace = kubernetes_namespace.echoserver.metadata[0].name
    annotations = {
        "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
        "nginx.ingress.kubernetes.io/rewrite-target" =  "/"
    }
  }
    spec {
        rule {
            http {
            path {
                backend {
                service_name = "echoserver-svc"
                service_port = 80
                }

                path = "/echo"
            }
            }
        }
        }
}
