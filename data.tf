###---data

resource "helm_release" "postgresql-ha" {
  namespace        = "infra"
  create_namespace = true
  depends_on = [kind_cluster.default]

  name       = "postgresql-ha"
  chart = "${var.charts_path}/postgresql-ha/"
  
}
