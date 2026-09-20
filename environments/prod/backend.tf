terraform {
  backend "s3" {
    bucket = "amzn-s3-class-bucket3333"
    key    = "ec2/prod/terraform.tfstate"
    region = "us-east-1"
  }
}