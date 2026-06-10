# Terraform AWS Project

This Terraform project is designed to provision AWS infrastructure, including an S3 bucket and the foundation for VPC, subnet, and EC2 resources.

## Project Overview

Current configuration provisions:
- AWS S3 bucket with public access blocking

This repository is organized for easy extension to create:
- AWS VPC
- Public and private subnets
- EC2 instances
- Additional AWS networking and compute resources

## Files

- `providers.tf` - AWS provider configuration and required provider version
- `variables.tf` - Terraform input variables (region)
- `main.tf` - AWS resource definitions
- `README.md` - Project documentation

## Prerequisites

- Terraform installed locally (`terraform` CLI)
- AWS credentials configured in your environment (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, optionally `AWS_SESSION_TOKEN`), or via `aws configure`

## Usage

1. Initialize Terraform

```bash
terraform init
```

2. Review the planned changes

```bash
terraform plan
```

3. Apply the configuration

```bash
terraform apply
```

4. Destroy the infrastructure when no longer needed

```bash
terraform destroy
```

## Configuration

This project uses a single variable defined in `variables.tf`:

- `region` - AWS region where resources are created (default: `us-east-1`)

If you extend the project with VPC, subnet, and EC2 resources, add the corresponding Terraform resources to `main.tf` and variables as needed.

## Notes

- S3 bucket names must be globally unique.
- The current S3 bucket name is constructed using the AWS account ID to reduce conflicts.
- Make sure your AWS account has permission to create the resources you configure.

