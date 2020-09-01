resource "local_file" "helmfile" {
  filename = "${path.module}/generated/helmfile.yaml"
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
