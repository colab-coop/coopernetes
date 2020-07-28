variable "region" {}

variable "env" {}

resource "random_pet" "suffix" {}

variable "cluster_name" {
  default = "UNDEFINED"
}

locals {
  default_cluster_name = "coopernetes-${var.env}-${random_pet.suffix.id}"
  cluster_name         = "${var.cluster_name == "UNDEFINED" ? local.default_cluster_name : var.cluster_name}"
}
