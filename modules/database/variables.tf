variable "environment" {
  type = string
}

variable "allowed_security_group_id" {
  description = "El ID del Security Group que puede conectarse a la BD"
  type        = string
}

variable "db_name" {
  type    = string
  default = "miappdb"
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  description = "Contraseña de la base de datos (No se hardcodea en main.tf)"
  type        = string
  sensitive   = true # Terraform ocultará esto en los logs
}