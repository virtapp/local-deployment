
###-keycloak
resource "helm_release" "keycloak" {
  name       = "keycloak"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  create_namespace = true
  timeout = 900
  values = [
    file("config/keycloak-value.yaml")
  ]
  depends_on = [helm_release.argocd]
}


###-kong
resource "helm_release" "kong" {
  name       = "kong"

  repository = "https://charts.konghq.com"
  chart      = "kong"
  create_namespace = true
  wait             = true
  set {
    name  = "ingressController.enabled"
    value = "true"
  }

  set {
    name  = "admin.enabled"
    value = "true"
  }

  set {
    name  = "admin.http.enabled"
    value = "true"
  }
  
  set {
    name  = "proxy.enabled"
    value = "true"
  }
  
  set {
    name  = "proxy.type"
    value = "ClusterIP"
  }

  set {
    name  = "ingressController.installCRDs"
    value = "false"
  }
  depends_on = [helm_release.argocd]
}


###-jenkins
resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  timeout = 900

  set_sensitive {
    name  = "controller.adminUser"
    value = "admin"
  }
  set_sensitive {
    name = "controller.adminPassword"
    value = "admin"
  }
  set_sensitive {
    name = "adminPassword"
    value = "admin"
  }
  depends_on = [helm_release.argocd]
}



