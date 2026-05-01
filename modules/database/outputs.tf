output "db_endpoint" {
  description = "El endpoint de conexión a la base de datos"
  value       = aws_db_instance.mysql.endpoint
}