variable "region" {}
variable "profile" {}
variable "env" {}

variable "cluster_name" {
  default = "UNDEFINED"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

# TODO switch to random_pet
# resource "random_pet" "suffix" {}

locals {
  default_cluster_name = "coopernetes-${var.env}-${random_string.suffix.result}"
  cluster_name         = "${var.cluster_name == "UNDEFINED" ? local.default_cluster_name : var.cluster_name}"
  generated            = "${path.module}/generated"
}
