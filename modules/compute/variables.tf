# Variables del módulo de compute
variable "environment" {
  description = "El entorno de despliegue (dev, prod)"
  type        = string
}

variable "instance_type" {
  description = "Tamaño de la instancia"
  type        = string
  default     = "t2.micro"
}