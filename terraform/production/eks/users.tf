locals {
  map_users = [
    {
      userarn  = aws_iam_user.coopernetes-deploy-user.arn
      username = "coopernetes-deploy-user"
      groups   = ["system:masters"]
    },
    {
      userarn  = data.aws_iam_user.jure.arn
      username = data.aws_iam_user.jure.user_name
      groups   = ["system:masters"]
    },
    {
      userarn  = data.aws_iam_user.ian.arn
      username = data.aws_iam_user.ian.user_name
      groups   = ["system:masters"]
    },
  ]
  map_roles = []
}

resource "aws_iam_user" "coopernetes-deploy-user" {
  name = "${local.cluster_name}-deploy-user"
}

resource "aws_iam_user_policy" "coopernetes-deploy-user" {
  name = "CoopernetesDeployUserPolicy"
  user = aws_iam_user.coopernetes-deploy-user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

data "aws_iam_user" "ian" {
  user_name = "ian"
}
data "aws_iam_user" "jure" {
  user_name = "jure"
}
