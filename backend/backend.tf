terraform {
    backend "s3" {
      bucket         = "hannah-terraform-state-bucket"
      key            = "stage/terraform.tfstate"
      region         = "ap-northeast-2"
      encrypt        = true
      dynamodb_table = "terraform-lock"
    }
}