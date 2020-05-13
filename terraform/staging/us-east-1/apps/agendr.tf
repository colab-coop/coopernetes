resource "aws_ecr_repository" "agendr" {
  name                 = "agendr"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
