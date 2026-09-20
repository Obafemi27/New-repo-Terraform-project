variable "environment" {
  description = "Deployment environment name."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be either dev or prod."
  }
}

variable "project_name" {
  description = "Project name used in resource naming."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance."
  type        = string
}

variable "subnet_id" {
  description = "Optional subnet ID. Omit to use the account default VPC subnet."
  type        = string
  default     = null
  nullable    = true
}

variable "security_group_ids" {
  description = "Security groups to attach to the instance."
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Optional EC2 key pair name."
  type        = string
  default     = null
  nullable    = true
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for the EC2 instance."
  type        = map(string)
  default     = {}
}