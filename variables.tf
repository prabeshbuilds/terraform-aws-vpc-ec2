variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t4g.micro"], var.instance_type)
    error_message = "instance_type must be a free-tier eligible micro instance (t2.micro, t3.micro, or t4g.micro)."
  }
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0152204c1a187337c"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name for SSH access"
  type        = string
  default     = "my-key"
}

