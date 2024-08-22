resource "aws_sagemaker_model" "text_generator" {
  name               = "text-generator-model"
  execution_role_arn = aws_iam_role.sagemaker_execution_role.arn

  primary_container {
    image             = "811284229777.dkr.ecr.us-east-1.amazonaws.com/blazingtext:latest"
    model_data_url    = "s3://train-bucket-udi-meetup/sagemaker/pytorch-gpt2/output/pytorch-training-2024-08-21-19-47-29-895/output/model.tar.gz"
    #environment = {
      #SAGEMAKER_CONTAINER_LOG_LEVEL = "20"
      #SAGEMAKER_PROGRAM             = "inference.py"
      #SAGEMAKER_REGION              = var.aws_region
      #HF_TASK          = "feature-extraction"
    #}
  }
}

resource "aws_sagemaker_endpoint_configuration" "text_generator_endpoint_config" {
  name = "text-generator-endpoint-config"

  production_variants {
    variant_name           = "AllTraffic"
    model_name             = aws_sagemaker_model.text_generator.name
    initial_instance_count = 1
    instance_type          = "ml.m5.large"
  }
}

resource "aws_sagemaker_endpoint" "text_generator_endpoint" {
  name              = "text-generator-x-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.text_generator_endpoint_config.name
}
