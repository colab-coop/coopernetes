variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "env" {
  default = "test"
}

resource "random_pet" "suffix" {}

variable "cluster_name" {
  default = "UNDEFINED"
}

variable "worker_group_1" {
  default = {}
}

variable "worker_group_1_type" {}
variable "worker_group_1_count" {}
variable "worker_group_2_type" {}
variable "worker_group_2_count" {}

locals {
  default_cluster_name = "coopernetes-${var.env}-${random_pet.suffix.id}"
  cluster_name         = "${var.cluster_name == "UNDEFINED" ? local.default_cluster_name : var.cluster_name}"
}
