resource "kubernetes_namespace" "echoserver" {
  metadata {
    annotations = {
    name = "echoserver"
  }
  name = "echoserver"
}
}
