resource "kubernetes_namespace" "hextris" {
  depends_on = [kind_cluster.default]
  metadata {
    annotations = {
      name = "lab"
    }

    labels = {
      mylabel = "hextris"
    }

    name = var.kubernetes_namespace
  }
}
