resource "aws_ssm_parameter" "example_rds_password" {
  name        = "${var.common["env_abbr"]}-${var.common["name"]}-rds-password"
  value       = var.rds["aws_db_instance_instance_password"] # apply後にAWS CLIで新しいパスワードに更新する
  type        = "SecureString"
  description = "RDS Password"

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-rds-password"
    env  = var.common["env"]
  }
}
