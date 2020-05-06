terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket  = "coopernetes-operations"
    key     = "terraform/staging/us-east-1/kubernetes.tfstate"
    region  = "us-east-1"
    profile = "coopernetes"
  }
}
