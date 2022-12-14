resource "aws_db_parameter_group" "example" {
  name   = "${var.common["env_abbr"]}-${var.common["name"]}-parameter-group-mysql-5-7"
  family = "mysql5.7"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-parameter-group-mysql-5-7"
    env  = var.common["env"]
  }
}
