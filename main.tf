terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-misha"
    key = "global/s3/terraform.state"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks-misha"
    encrypt = true
  }
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.terrafrom_state.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "terrafrom_state" {
  bucket = "terraform-up-and-running-state-misha"
  #prevent accidental deletion of this s3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.terrafrom_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

  # Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.terrafrom_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-up-and-running-locks-misha"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}