resource "aws_db_option_group" "example" {
  name                 = "${var.common["env_abbr"]}-${var.common["name"]}-db-option-group-5-7"
  engine_name          = "mysql"
  major_engine_version = "5.7"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-db-option-group-5-7"
    env  = var.common["env"]
  }
}
