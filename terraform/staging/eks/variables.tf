variable "env" {}

variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "coopernetes"
}

variable "cluster_name" {
  default = "UNDEFINED"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  default_cluster_name = "coopernetes-${var.env}-${random_string.suffix.result}"
  cluster_name         = "${var.cluster_name == "UNDEFINED" ? local.default_cluster_name : var.cluster_name}"
  generated            = "${path.module}/generated"
}
