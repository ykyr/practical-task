variable "gcp_region" {
  description = "GCP region, e.g. europe-west2"
  default = "europe-west2"
}

variable "gcp_zone" {
  description = "GCP zone, e.g. europe-west2-b (which must be in gcp_region)"
  default = "europe-west2-a"
}

variable "gcp_additional_zones" {
  description = "List of additional GCP zones, e.g. europe-west2-c, europe-west2-b, (which must be in gcp_region)"
  type    = "list"
  default = ["europe-west2-b"]
}

variable "gcp_project" {
  description = "GCP project name"
  default = "devops-workshop-2510a27b"
}

variable "cluster_name" {
  description = "Name of the K8s cluster"
  default = "k8skiwi-cluster"
}

variable "initial_node_count" {
  description = "Number of worker VMs to initially create"
  default = 1
}

variable "master_username" {
  description = "Username for accessing the Kubernetes master endpoint"
  default = "admin"
}

variable "master_password" {
  description = "Password for accessing the Kubernetes master endpoint"
  default = "k8smasterk8smasterkiwi"
}

variable "node_labels" {
  description = "Label that describes environment type"
  type = "map"
  default = {
    "env" = "dev"
    "name" = "k8s-kiwi"
  }
}

variable "node_machine_type" {
  description = "GCE machine type"
  default = "n1-standard-1"
}

variable "node_disk_size" {
  description = "Node disk size in GB"
  default = "20"
}

variable "node_tags" {
  description = "List of tags to identify valid sources or targets for network firewalls"
  type    = "list"
  default = ["k8s-dev", "k8s-kiwi"]
}
