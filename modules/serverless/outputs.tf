output "api_endpoint" {
  description = "URL pública de la Lambda"
  value       = aws_lambda_function_url.api_url.function_url
}