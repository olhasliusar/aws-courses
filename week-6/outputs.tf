output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.db.rds_endpoint
}

output "rds_port" {
  description = "Port of the RDS instance"
  value       = module.db.rds_port
}

output "load_balancer" {
  description = "Load balancer DNS"
  value       = module.instance.load_balancer
}

