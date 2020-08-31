resource "aws_s3_bucket" "backups" {
  bucket = "${var.cluster_name}-backups"
  acl    = "private"
}

resource "aws_iam_user" "backup-bot" {
  name = "${var.cluster_name}-backup-bot"
}

resource "aws_iam_user_policy" "backup-bot" {
  name = "${var.cluster_name}-backup-bot"
  user = aws_iam_user.backup-bot.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "${aws_s3_bucket.backups.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.backups.arn}"
            ]
        }
    ]
}
EOF
}
