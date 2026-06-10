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
