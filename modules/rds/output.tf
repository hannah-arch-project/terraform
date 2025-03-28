output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.this.endpoint
}

output "rds_sg_id" {
  description = "RDS security group ID"
  value       = aws_security_group.this.id
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.this.db_name
}

output "db_username" {
  description = "Database master username"
  value       = aws_db_instance.this.username
}

output "db_password" {
  description = "Database master password"
  value       = aws_db_instance.this.password
  sensitive   = true
}