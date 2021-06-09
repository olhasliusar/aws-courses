output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.pgsql.endpoint
}

output "rds_port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.pgsql.port
}
