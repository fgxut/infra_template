data "aws_db_instance" "example" {
  db_instance_identifier = "${var.common["env_abbr"]}-${var.common["name"]}-rds"
}
