locals {
  map_users = [
    {
      userarn  = aws_iam_user.coopernetes-deploy-user.arn
      username = "coopernetes-deploy-user"
      groups   = ["system:masters"]
    },
  ]
  map_roles = [
    {
      rolearn  = "arn:aws:iam::395720434993:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_729dbe7623fb0433"
      username = "devops"
      groups   = ["system:masters"]
    },
  ]
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.15"
  subnets         = module.vpc.private_subnets

  manage_aws_auth = true
  map_roles       = local.map_roles
  map_users       = local.map_users

  tags = {
    Environment = var.env
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
