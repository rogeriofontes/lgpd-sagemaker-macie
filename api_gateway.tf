# Definição da API
resource "aws_api_gateway_rest_api" "text_generator_api" {
  name = var.api_gateway_name
}

# Recurso da API
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.text_generator_api.id
  parent_id   = aws_api_gateway_rest_api.text_generator_api.root_resource_id
  path_part   = "generate"
}

# Método da API
resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.text_generator_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integração do método com a função Lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.text_generator_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                     = "AWS_PROXY"
  uri                      = aws_lambda_function.text_generator.invoke_arn
}

# Permissão para a API Gateway invocar a função Lambda
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.text_generator.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.text_generator_api.execution_arn}/*/*"
}

# Estágio da API
resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = "dev-new"
  rest_api_id   = aws_api_gateway_rest_api.text_generator_api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  description   = "Development stage"

  variables = {
    "example_key" = "example_value"
  }
}

# Deployment da API
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.text_generator_api.id
  stage_name  = "dev"

  # Garantir que o deployment seja feito sempre que houver alterações nos recursos
  depends_on = [
    aws_api_gateway_method.api_method,
    aws_api_gateway_integration.lambda_integration,
  ]
}


# Output do endpoint da API
output "api_endpoint" {
  value = "https://${aws_api_gateway_rest_api.text_generator_api.id}.execute-api.${var.aws_region}.amazonaws.com/dev/generate"
}
