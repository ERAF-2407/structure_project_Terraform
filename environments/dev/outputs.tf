# Salidas específicas del entorno DEV

output "server_public_ip" {
  description = "La IP publica de la instancia EC2 con Node.js"
  value       = module.compute.public_ip
}

output "database_endpoint" {
  description = "Endpoint de MySQL para conectarse desde la EC2"
  value       = module.database.db_endpoint
}

output "website_url" {
  description = "La URL del sitio web alojado en S3"
  value       = module.storage.website_endpoint
}

output "lambda_api_url" {
  description = "URL de la API Serverless"
  value       = module.serverless.api_endpoint
}