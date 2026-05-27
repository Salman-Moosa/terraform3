output "alb_dns_name" {
  description = "DNS name of the application load balancer."
  value       = module.alb.alb_dns_name
}

output "db_endpoint" {
  description = "RDS PostgreSQL endpoint."
  value       = module.rds.db_endpoint
  sensitive   = true
}
