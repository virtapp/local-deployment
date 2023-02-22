resource "kubernetes_service" "example" {
  metadata {
    name = "echoserver-svc"
    namespace = kubernetes_namespace.echoserver.metadata[0].name
  }
  spec {
    selector = {
      "app" = "echoserver-app-nginx"
    }
    port {
      name = "http-echoserver"
      port        = 80
      target_port = 8080
      protocol =  "TCP"
    }
  }
}
