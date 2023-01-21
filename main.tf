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