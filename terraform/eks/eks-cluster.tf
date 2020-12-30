locals {
  map_users = [
    {
      userarn  = aws_iam_user.coopernetes-deploy-user.arn
      username = "coopernetes-deploy-user"
      groups   = ["system:masters"]
    },
  ]
  map_roles = []
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.16"
  subnets         = module.vpc.private_subnets

  manage_aws_auth = true
  map_roles       = local.map_roles
  map_users       = local.map_users

  vpc_id = module.vpc.vpc_id

  node_groups = {
    t3-medium = {
      desired_capacity = 5
      max_capacity     = 10
      min_capacity     = 5

      instance_type = "t3.medium"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
