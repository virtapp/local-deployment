data "external" "subnet" {
  program = ["/bin/bash", "-c", "docker network inspect -f '{{json .IPAM.Config}}' kind | jq .[0]"]
  depends_on = [
    kind_cluster.default
  ]
}
resource "helm_release" "metallb" {
  name             = "metallb"
  repository       = "https://metallb.github.io/metallb"
  chart            = "metallb"
  namespace        = "metallb"
  version          = "0.10.3"
  create_namespace = true
  values = [
    <<-EOF
  configInline:
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      # - ${cidrhost(data.external.subnet.result.Subnet, 150)}-${cidrhost(data.external.subnet.result.Subnet, 200)}
      - 172.18.255.1-172.18.255.250
  EOF
  ]
  depends_on = [
    kind_cluster.default
  ]
}
