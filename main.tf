provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "sagemaker_execution_role" {
  name = "sagemaker_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "sagemaker_s3_access_policy" {
  name = "sagemaker_s3_access_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::train-bucket-udi-meetup/sagemaker/pytorch-gpt2/*",
          "arn:aws:s3:::train-bucket-udi-meetup"
        ]
      }
    ]
  })
}


resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })

  # Permissões para invocar o SageMaker
  inline_policy {
    name = "sagemaker-invoke"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Action   = "sagemaker:InvokeEndpoint"
        Effect   = "Allow"
        Resource = "*"  # Altere para especificar seu endpoint
      }]
    })
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["sagemaker:InvokeEndpoint", "kms:Decrypt"],
        Effect   = "Allow",
        Resource = "*"
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "sagemaker_policy_attachment" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = aws_iam_policy.sagemaker_s3_access_policy.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

