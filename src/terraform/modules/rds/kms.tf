resource "aws_kms_key" "example_rds" {
  description             = "For RDS"
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "example_rds" {
  name          = "alias/example-rds"
  target_key_id = aws_kms_key.example_rds.key_id
}
