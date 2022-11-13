provider "aws" {
  region = local.aws_region

  default_tags {
    tags = {
      Project = var.project_name
      Environment = var.environment
      Terraform-Managed = true
    }
  }
}