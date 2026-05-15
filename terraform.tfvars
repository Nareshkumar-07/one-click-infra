# General
aws_region   = "ap-south-1"
project_name = "one-click-infra"
environment  = "dev"
owner        = "devops-team"

# EC2
instance_type = "t3.micro"
ami_id        = "ami-0e35ddab05955cf57"
key_pair_name = ""                       

# S3
s3_bucket_prefix  = "app-bucket"
enable_versioning = true

# Remote Backend (informational — must match backend.tf)
backend_bucket_name    = "one-click-infra-tfstate-bucket"
backend_dynamodb_table = "one-click-infra-tf-lock"
