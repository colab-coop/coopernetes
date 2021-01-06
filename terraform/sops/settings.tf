terraform {
  required_version = ">= 0.12.9"

  backend "s3" {
    bucket    = "coopernetes-operations"
    key       = "terraform/sops.tfstate"
    region    = "us-east-1"
    profile   = "coopernetes"
    encrypt   = true
  }
}

provider "aws" {
  version = ">= 2.52.1"
  region  = "us-east-1"
  profile = "coopernetes"
}

provider "local" {
  version = ">= 1.4"
}

provider "null" {
  version = ">= 2.1"
}
