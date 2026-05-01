# Módulo de Cómputo (Instancias, Clústeres, etc.)

# 1. Buscamos dinámicamente la última imagen (AMI) de Ubuntu 22.04 en AWS
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # ID oficial de Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 2. Creamos el par de llaves en AWS usando tu llave pública local
resource "aws_key_pair" "deployer" {
  key_name   = "node-server-key-${var.environment}"
  public_key = file("~/.ssh/aws_ec2_node.pub")
}

# 3. Security Group (El Firewall de la instancia)
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg-${var.environment}"
  description = "Permitir trafico SSH y HTTP"

  # Regla de entrada para SSH (Punto "Conectar a la instancia")
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Nota DevSecOps: En un entorno real, aquí iría solo tu IP pública.
  }

  # Regla de entrada para HTTP (Para ver si Node.js levanta algo)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Reglas de salida (Permitir que la máquina salga a internet para descargar Node)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. La Instancia EC2
resource "aws_instance" "node_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type # Usaremos t2.micro que es Capa Gratuita
  key_name      = aws_key_pair.deployer.key_name
  
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # User Data: Script Bash para instalar Node.js 20.x automáticamente al arrancar
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y ca-certificates curl gnupg
              mkdir -p /etc/apt/keyrings
              curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
              echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
              apt-get update -y
              apt-get install nodejs -y
              EOF

  tags = {
    Name = "NodeServer-${var.environment}"
  }
}