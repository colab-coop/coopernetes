terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket  = "coopernetes-operations"
    key     = "terraform/staging/us-east-1/eks.tfstate"
    region  = "us-east-1"
    profile = "coopernetes"
  }
}

provider "aws" {
  version = ">= 2.28.1"
  region  = "us-east-1"
  profile = "coopernetes"
}

provider "random" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

