variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "account_id" {
  type        = string
  description = "ID de cuenta de AWS para asegurar que el nombre del bucket sea único globalmente"
}

variable "website_source_path" {
  description = "Ruta local al archivo index.html"
  type        = string
}