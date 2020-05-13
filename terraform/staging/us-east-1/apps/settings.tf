terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket  = "coopernetes-operations"
    key     = "terraform/staging/us-east-1/apps.tfstate"
    region  = "us-east-1"
    profile = "coopernetes"
  }
}

provider "aws" {
  version = ">= 2.28.1"
  region  = "us-east-1"
  profile = "coopernetes"
}
