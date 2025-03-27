resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.frontend_bucket_name
  force_destroy = true

  tags = merge({
    Name = "frontend-hosting"
  }, var.tags)
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = ["s3:GetObject"],
        Resource  = ["${aws_s3_bucket.frontend_bucket.arn}/*"]
      }
    ]
  })
}

resource "aws_s3_bucket" "backend_artifacts" {
  bucket = var.backend_bucket_name
  force_destroy = true

  tags = merge({
    Name = "backend-artifacts"
  }, var.tags)
}

resource "aws_s3_bucket_versioning" "backend_versioning" {
  bucket = aws_s3_bucket.backend_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}
