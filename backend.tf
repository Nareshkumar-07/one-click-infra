terraform {
  backend "s3" {
    bucket         = "one-click-infra-tfstate-bucket"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "one-click-infra-tf-lock"
  }
}
