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
  filename          = "${local.generated}/secrets.yaml"
  sensitive_content = <<-YAML
  # This is a secret configuration file needed by helmfile.
  # It contains all secret values created by terraform that are needed by helmfile.
  velero:
    access_key_id: CHANGE_ME
    secret_access_key: CHANGE_ME
YAML

  provisioner "local-exec" {
    command     = "helm secrets enc secrets.yaml"
    working_dir = local.generated
  }
}
