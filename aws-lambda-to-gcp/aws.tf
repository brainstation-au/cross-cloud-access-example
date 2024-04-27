data "aws_ecr_authorization_token" "this" {}
resource "aws_ecr_repository" "this" {
  name = var.app_name
}

resource "aws_iam_role" "this" {
  name = "${var.app_name}-lambda"
  path = local.aws_iam_role_path
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
  ]
}

resource "aws_lambda_function" "this" {
  function_name = var.app_name
  role          = aws_iam_role.this.arn
  architectures = ["arm64"]
  description   = "This is an example lambda function"
  image_uri     = var.image_uri
  environment {
    variables = {
      foo = "bar"
    }
  }
  package_type = "Image"
  timeout      = 60
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 7
}