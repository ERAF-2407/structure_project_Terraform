# modules/storage/main.tf

# 1. Creamos el Bucket
resource "aws_s3_bucket" "website" {
  bucket = "${var.project_name}-web-${var.environment}-${var.account_id}"
  
  # Forzamos la destrucción aunque el bucket tenga archivos (útil para pruebas)
  force_destroy = true 
}

# 2. Configuramos el Bucket para alojar un sitio web
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

# 3. Desactivamos el Bloqueo de Acceso Público
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. Política del Bucket: Permitir lectura pública de los objetos
resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.website.id
  
  # Esta política dice: "Permite a cualquiera (Principal: *) hacer s3:GetObject en este bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      },
    ]
  })

  # Terraform debe esperar a que el acceso público se desbloquee antes de aplicar esta política
  depends_on = [aws_s3_bucket_public_access_block.public_access]
}

# 5. Subir el archivo index.html
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website.id
  key    = "index.html" # El nombre que tendrá en S3

  # Ruta al archivo local. Usamos una variable para ser dinámicos.
  source = var.website_source_path 

  # Forzamos el Content-Type para que el navegador lo lea como HTML y no lo descargue
  content_type = "text/html" 

  # Importante: Dependemos de la política pública para evitar errores durante la subida
  depends_on = [aws_s3_bucket_policy.allow_public_read]
}