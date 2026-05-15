# ── General ─────────────────────────────────────────────────

variable "aws_region" {
  description = "AWS region where all resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Short name used to prefix/tag all resources"
  type        = string
  default     = "one-click-infra"
}

variable "environment" {
  description = "Deployment environment: dev | staging | prod"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "owner" {
  description = "Team or individual that owns these resources (for billing/tagging)"
  type        = string
  default     = "devops-team"
}

# ── EC2 ─────────────────────────────────────────────────────

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro" # free-tier eligible
}

variable "ami_id" {
  description = "Amazon Machine Image ID (Ubuntu 22.04 LTS in ap-south-1)"
  type        = string
  default     = "ami-0f58b397bc5c1f2e8" # Ubuntu 22.04 LTS — ap-south-1
}

variable "key_pair_name" {
  description = "Name of an existing EC2 Key Pair for SSH access (leave empty to skip)"
  type        = string
  default     = ""
}

# ── S3 ──────────────────────────────────────────────────────

variable "s3_bucket_prefix" {
  description = "Prefix for the application S3 bucket name (a random suffix is appended)"
  type        = string
  default     = "app-bucket"
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning for the application bucket"
  type        = bool
  default     = true
}

# ── Remote Backend ───────────────────────────────────────────
variable "backend_bucket_name" {
  description = "S3 bucket used to store Terraform state (must exist before terraform init)"
  type        = string
  default     = "one-click-infra-tfstate-bucket"
}

variable "backend_dynamodb_table" {
  description = "DynamoDB table for Terraform state locking (must exist before terraform init)"
  type        = string
  default     = "one-click-infra-tf-lock"
}
