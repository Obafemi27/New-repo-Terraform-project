provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        ManagedBy   = "Terraform"
        Environment = var.environment
      },
      var.tags
    )
  }
}

module "ec2" {
  source = "../../modules/ec2"

  environment        = var.environment
  project_name       = var.project_name
  instance_type      = var.instance_type
  ami_id             = var.ami_id
  subnet_id          = var.subnet_id
  security_group_ids = var.security_group_ids
  tags               = var.tags
}