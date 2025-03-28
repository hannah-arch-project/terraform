resource "aws_s3_bucket" "backend-bucket" {
  bucket = var.backend_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "backend" {
  bucket = aws_s3_bucket.backend-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}