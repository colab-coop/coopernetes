terraform {
  required_version = ">= 0.12.9"

  backend "s3" {
    bucket  = "itme-operations"
    key     = "terraform/us-west-2/eks/thich-nhat-hanh.tfstate"
    region  = "us-west-2"
    profile = "itme"
  }
}

provider "aws" {
  version = ">= 2.52.1"
  region  = "us-west-2"
  profile = "itme"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

provider "random" {
  version = ">= 2.1"
}

provider "local" {
  version = ">= 1.4"
}

provider "null" {
  version = ">= 2.1"
}

provider "template" {
  version = ">= 2.1"
}

