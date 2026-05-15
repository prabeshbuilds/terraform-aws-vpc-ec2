variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Canonical, Ubuntu, 24.04, amd64 noble image"
  default     = "ami-05cf1e9f73fbad2e2"
}

variable "instance_type" {
  description = "EC2 type"
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "Existing VPC ID (default VPC or custom)"
  default     = "vpc-0a90dabe70eb3e866"
}
