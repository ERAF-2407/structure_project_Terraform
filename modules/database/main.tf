# modules/database/main.tf

# 1. Buscamos la VPC por defecto de tu cuenta para alojar la BD
data "aws_vpc" "default" {
  default = true
}

# 2. Security Group para RDS: Solo permite tráfico desde la EC2
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group-${var.environment}"
  description = "Permitir trafico MySQL solo desde el servidor EC2"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "MySQL desde EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.allowed_security_group_id] # Aquí ocurre la magia de la conectividad
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. La Instancia de Base de Datos (MySQL - Capa Gratuita)
resource "aws_db_instance" "mysql" {
  identifier             = "app-database-${var.environment}"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro" # Capa gratuita para RDS
  allocated_storage      = 20            # 20 GB es el mínimo para capa gratuita
  
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false         # Seguridad: Nadie desde internet puede verla

  # IMPORTANTE PARA PRUEBAS: Permite destruir la BD sin crear un respaldo final
  skip_final_snapshot    = true          
}