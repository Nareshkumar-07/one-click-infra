output "ec2_instance_id" {
  description = "The unique ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance (use this for SSH)"
  value       = aws_instance.main.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS hostname of the EC2 instance"
  value       = aws_instance.main.public_dns
}

output "s3_bucket_name" {
  description = "Name of the application S3 bucket"
  value       = aws_s3_bucket.app.id
}

output "s3_bucket_arn" {
  description = "ARN of the application S3 bucket"
  value       = aws_s3_bucket.app.arn
}

output "security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.main.id
}

output "ssh_command" {
  description = "Ready-to-use SSH command (requires a valid key_pair_name)"
  value       = var.key_pair_name != "" ? "ssh -i ~/.ssh/${var.key_pair_name}.pem ubuntu@${aws_instance.main.public_ip}" : "No key pair specified — add key_pair_name in terraform.tfvars"
}

output "environment" {
  description = "Active deployment environment"
  value       = var.environment
}

output "region" {
  description = "AWS region where resources were deployed"
  value       = var.aws_region
}
