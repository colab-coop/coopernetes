resource "aws_iam_user" "coopernetes-deploy-user" {
  name = "coopernetes-deploy-user"
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

resource "aws_iam_role" "coopernetes-worker" {
  name = "coopernetes-worker"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sts:AssumeRole"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
