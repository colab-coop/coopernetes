# SOPS configuration (https://github.com/mozilla/sops)
# for use with helm-secrets (https://github.com/zendesk/helm-secrets)

resource "aws_kms_key" "sops" {
  description = "KMS Key for sops with helm-secrets plugin"
}

resource "aws_kms_alias" "helm-secrets" {
  name          = "alias/helm-secrets"
  target_key_id = aws_kms_key.sops.key_id
}

resource "local_file" "sops" {
  filename = "${local.generated}/sops.yaml"
  content  = <<-YAML
  sops:
    kms:
      - arn: ${aws_kms_key.sops.arn}
        aws_profile: ${var.profile}
  creation_rules:
        # Finally, if the rules above have not matched, this one is a
        # catchall that will encrypt the file using kms
        # The absence of a path_regex means it will match everything
        - kms: ${aws_kms_key.sops.arn}
          aws_profile: ${var.profile}
YAML
}
