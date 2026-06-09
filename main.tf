#####
# Terraform configuration for AWS resources
#####

resource "aws_VPC" "main"{
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main_vpc"
  }
}


# Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main_igw"
  }


# Public subnet
resource "aws_subnet" "public" {
  vpc_id           = aws_vpc.main.id
  cidr_block       = var.public_subnet_cidr
  availability_zone = var.az
  tags = {
    Name = "public_subnet"
  }
} 


# Private subnet
resource "aws subnet" "private" {
  vpc_id           = aws_vpc.main.id
  cidr_block       = var.private_subnet_cidr
  availability_zone = var.az
  tags = {
    Name = "private_subnet"
  }
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_rt"
  }
}


resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# private route table
resource "aws route table" "private"{
  vpc_id = aws_vpc.main.id
  rou te {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "private_rt"
  }

}



resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}


# Security group for EC2 instances

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_security_group"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0./0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2_sg"
  }

  resource "aws_instance" "web" {
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id     = aws_subnet.public.id
    security_groups = [aws_security_group.ec2_sg.name]
    tags = {
      Name = "web_instance"
    }
  }

    