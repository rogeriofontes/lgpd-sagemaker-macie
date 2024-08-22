resource "aws_kms_key" "my_kms_key" {
  description             = "KMS key for encrypting sensitive data"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.kms_key_alias}"
  target_key_id = aws_kms_key.my_kms_key.id
}

output "kms_key_id" {
  value = aws_kms_key.my_kms_key.arn
}
