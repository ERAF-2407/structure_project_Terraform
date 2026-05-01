output "website_endpoint" {
  description = "La URL del sitio web alojado en S3"
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
}
