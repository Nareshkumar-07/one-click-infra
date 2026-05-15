resource "aws_security_group" "main" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Security group for ${var.project_name} - managed by Terraform"

  # Allow SSH from anywhere (restrict to your IP in production!)
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ Restrict to your IP in prod: ["x.x.x.x/32"]
  }

  # Allow all outbound traffic (needed for package updates, etc.)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg"
  }
}

# ── 2. EC2 Instance ──────────────────────────────────────────
# A free-tier Ubuntu server in the region specified in provider.tf.

resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type

  # Attach the security group created above
  vpc_security_group_ids = [aws_security_group.main.id]

  # Attach key pair only if one is provided
  key_name = var.key_pair_name != "" ? var.key_pair_name : null

  # Startup script — installs basic tools on first boot
  user_data = <<-EOF
              #!/bin/bash
              set -e
              apt-get update -y
              apt-get install -y curl wget git unzip
              echo "✅ one-click-infra EC2 is ready!" > /tmp/startup.log
              EOF

  # Protect this instance from accidental terraform destroy in prod
  # Set to true when environment = "prod"
  disable_api_termination = var.environment == "prod" ? true : false

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2"
  }
}

# ── 3. S3 Bucket ─────────────────────────────────────────────
# Application storage bucket with versioning and encryption.

# random_id makes the bucket name globally unique
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "app" {
  # S3 bucket names must be globally unique across ALL AWS accounts
  bucket = "${var.project_name}-${var.s3_bucket_prefix}-${var.environment}-${random_id.bucket_suffix.hex}"

  # Prevent accidental deletion via terraform destroy
  lifecycle {
    prevent_destroy = false # Set to true in production!
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-app-bucket"
  }
}

# Enable versioning so you can recover deleted/overwritten objects
resource "aws_s3_bucket_versioning" "app" {
  bucket = aws_s3_bucket.app.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "app" {
  bucket = aws_s3_bucket.app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block ALL public access — never expose app data to the internet
resource "aws_s3_bucket_public_access_block" "app" {
  bucket = aws_s3_bucket.app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
