terraform {
  backend "s3" {
    bucket = "amzn-s3-class-bucket2222"
    key    = "ec2/dev/terraform.tfstate"
    region = "us-east-1"
  }
}