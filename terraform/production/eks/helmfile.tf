resource "local_file" "env" {
  filename = "${local.generated}/env.yaml"
  content  = <<-YAML
  # This is a configuration file needed by helmfile.
  # It contains all non-secret values created by terraform that are needed by helmfile.
  cluster:
    name: ${local.cluster_name}
  region: ${var.region}
  velero:
    bucket: ${aws_s3_bucket.backups.id}
YAML
}

resource "local_file" "secrets" {
  depends_on = ["local_file.sops"]

  filename          = "${local.generated}/secrets.yaml"
  sensitive_content = <<-YAML
  # This is a secret configuration file needed by helmfile.
  # It contains all secret values created by terraform that are needed by helmfile.
  velero:
    aws_access_key_id: ${aws_iam_access_key.backup-bot.id}
    aws_secret_access_key: ${aws_iam_access_key.backup-bot.secret}
YAML

  provisioner "local-exec" {
    command     = "helm secrets enc secrets.yaml"
    working_dir = local.generated
  }
}
