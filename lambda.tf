
resource "aws_lambda_function" "text_generator" {
  function_name = "text-generator-function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"  
  s3_bucket     = "train-bucket-udi-meetup"
  s3_key        = "lambda-functions/text-generator.zip"

  environment {
    variables = {
      SAGEMAKER_ENDPOINT_NAME = aws_sagemaker_model.text_generator.name
    }
  }
}