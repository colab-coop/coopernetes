variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "env" {
  default = "test"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

variable "cluster_name" {
  default = "UNDEFINED"
}

locals {
  default_cluster_name = "coopernetes-${var.env}-${random_string.suffix.result}"
  cluster_name         = "${var.cluster_name == "UNDEFINED" ? local.default_cluster_name : var.cluster_name}"
}
