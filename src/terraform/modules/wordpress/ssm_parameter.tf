resource "aws_ssm_parameter" "example_wordpress_db_password" {
  name        = "${var.common["env_abbr"]}-${var.common["name"]}-wordpress-db-password"
  value       = var.wordpress["wordpress_db_password"] # apply後にAWS CLIで新しい値に更新する
  type        = "SecureString"
  description = "WORDPRESS_DB_PASSWORD"

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-wordpress-db-password"
    env  = var.common["env"]
  }
}
 