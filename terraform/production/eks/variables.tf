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

# TODO switch to random_pet
resource "random_pet" "suffix" {}

locals {
  default_cluster_name = "coopernetes-${var.env}-${random_pet.suffix.result}"
  cluster_name         = "${var.cluster_name == "UNDEFINED" ? local.default_cluster_name : var.cluster_name}"
  generated            = "${path.module}/generated"
}
