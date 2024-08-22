variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "kms_key_alias" {
  description = "Alias for KMS key"
  default     = "my-secure-key"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  default     = "generate_response"
}

variable "sagemaker_model_name" {
  description = "Name of the SageMaker model"
  default     = "text-generator-model"
}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  default     = "text-generator-api"
}

variable "aws_account_id" {
  description = "Name of the API Gateway"
  default     = "147397866377"
}
