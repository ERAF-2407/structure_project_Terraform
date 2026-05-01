# Configuración del proveedor (AWS, etc.)

terraform {
  required_version = ">= 1.5.0" # Buena práctica: fijar una versión mínima de Terraform

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Usa la versión 5.x más reciente
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Terraform leerá automáticamente tu ~/.aws/credentials
  # Si en el futuro usas un perfil con otro nombre (ej. "produccion"), 
  # agregarías la línea: profile = "produccion"
}