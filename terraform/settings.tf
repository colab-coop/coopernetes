terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket = "coopernetes-operations"
    key    = "terraform/state/colab/staging/us_east_1.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  version = ">= 2.28.1"
  region  = "us-east-2"
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

