resource "kubernetes_secret" "this" {
  depends_on = [kind_cluster.default]
    metadata {
      name = "hextris-secret"
      namespace = var.kubernetes_namespace
    }

    data = {
        "tls.crt" = file("${path.module}/certs/server.crt")
        "tls.key" = file("${path.module}/certs/server.key")
    }

    type = "kubernetes.io/tls"
 }  
