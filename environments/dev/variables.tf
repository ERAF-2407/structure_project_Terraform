# Declaración de variables
variable "db_password_dev" {
  description = "Contraseña para la BD de desarrollo"
  type        = string
  sensitive   = true
}