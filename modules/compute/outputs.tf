# Salidas del módulo de compute

# Exportamos la IP pública para saber a dónde conectarnos
output "public_ip" {
  description = "La IP publica de la instancia EC2"
  value       = aws_instance.node_server.public_ip
}

output "security_group_id" {
  description = "El ID del Security Group de la instancia"
  value       = aws_security_group.web_sg.id
}