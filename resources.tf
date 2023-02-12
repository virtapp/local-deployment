
###-keycloak
resource "helm_release" "keycloak" {
  name       = "keycloak"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  create_namespace = true
  timeout = 300
  values = [
    file("config/keycloak-value.yaml")
  ]
  depends_on = [helm_release.argocd]
}


#deploy cert manager
resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.7.1"
  namespace        = "cert-manager"
  create_namespace = true
  timeout = 300
  #values = [file("cert-manager-values.yaml")]
  depends_on = [helm_release.argocd]
  set {
    name  = "installCRDs"
    value = "true"
  }

}
