# 1. Get current AWS account ID
data "aws_caller_identity" "current" {}

# 2. Define the S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  # The bucket name must be globally unique across all AWS accounts
  bucket = "my-terraform-bucket-${data.aws_caller_identity.current.account_id}-2026" 

  tags = {
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# 3. Block Public Access (Best Practice)
resource "aws_s3_bucket_public_access_block" "my_bucket_privacy" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



# 4. Default VPC lookup
data "aws_vpc" "default" {
  default = true
}

# 5. Security Group for EC2 Instance
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-instance-sg"
  description = "Allow SSH and HTTP to EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-instance-sg"
  }
}

# 6. EC2 Instance
resource "aws_instance" "my_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  
 user_data = <<-EOF
              #!/bin/bash

              # Update system packages
              yum update -y

              # Install Docker
              yum install docker -y

              # Start Docker service
              systemctl start docker
              systemctl enable docker

              # Add ec2-user to docker group
              usermod -aG docker ec2-user

              # Pull Nginx Docker image
              docker pull nginx

              # Create custom nginx webpage
              mkdir -p /home/ec2-user/nginx-content

              echo "Hello from Terraform AWS Docker Nginx Project" > /home/ec2-user/nginx-content/index.html

              # Run Nginx container
              docker run -d \
              --name nginx-server \
              -p 80:80 \
              -v /home/ec2-user/nginx-content:/usr/share/nginx/html \
              nginx

              EOF
  tags = {
    Name = "terraform-ec2-instance"
  }
}

output "ec2_instance_id" {
  value = aws_instance.my_instance.id
}

output "ec2_instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}
