
# 1. Empaquetamos el código fuente en un ZIP
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_code_path
  output_path = "${path.module}/lambda_function.zip"
}

# 2. Creamos el Rol de IAM (Permisos para que la Lambda se ejecute)
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda-execution-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# 3. Adjuntamos la política básica para que Lambda pueda escribir logs en CloudWatch (Punto 01:43:17)
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 4. Creamos la Función Lambda
resource "aws_lambda_function" "api" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = "${var.project_name}-api-${var.environment}"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs20.x"
}

# 5. Creamos una Function URL (Para llamarla desde internet)
resource "aws_lambda_function_url" "api_url" {
  function_name      = aws_lambda_function.api.function_name
  authorization_type = "NONE" # Acceso público para pruebas
}

# 6. Permiso explícito para invocar la URL públicamente
resource "aws_lambda_permission" "public_url_access" {
  statement_id           = "FunctionURLAllowPublicAccess"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.api.function_name
  principal              = "*" # Asterisco significa "cualquiera en internet"
  function_url_auth_type = "NONE"
}
