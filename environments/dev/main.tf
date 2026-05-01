# environments/dev/main.tf

# Obtenemos la info de tu cuenta para usarla en el nombre del bucket
data "aws_caller_identity" "current" {}

module "compute" {
  source = "../../modules/compute"

  environment   = "dev"
  instance_type = "t3.micro" # Capa gratuita
}

module "database" {
  source = "../../modules/database"

  environment = "dev"
  # Conectamos la BD con el firewall de la EC2:
  allowed_security_group_id = module.compute.security_group_id

  db_name     = "cursoaws"
  db_username = "admin"
  db_password = var.db_password_dev # Usaremos una variable para proteger la clave
}

# --- NUEVO MODULO DE STORAGE ---
module "storage" {
  source = "../../modules/storage"

  environment  = "dev"
  project_name = "cursoaws"
  account_id   = data.aws_caller_identity.current.account_id

  # Indicamos la ruta al archivo que creamos:
  website_source_path = "../../website_content/index.html"
}
