variable "cluster_name" {
  type        = string
  description = "The name of the cluster."
  default     = "lab"
}

variable "cluster_config_path" {
  type        = string
  description = "Cluster's kubeconfig location"
  default     = "~/.kube/config"
}

variable "kubernetes_namespace" {
  type        = string
  description = "Kubernetes namespace"
  default     = "hextris"
}
