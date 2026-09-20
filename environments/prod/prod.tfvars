aws_region                  = "us-east-1"
environment                 = "prod"
project_name                = "app"
instance_type               = "t3.small"

# Set these to use existing networking or access configuration.
subnet_id          = "subnet-0e833b1e89aaf7417"
security_group_ids = ["sg-0fde88abd7a0b9f44"]

# Required: set an AMI ID that is available in the configured AWS Region.
ami_id = "ami-0b6d9d3d33ba97d99"

tags = {
  Application = "app"
  CostCenter  = "production"
}