data "aws_ecs_task_definition" "example" {
  task_definition = aws_ecs_task_definition.example.family
  depends_on      = [aws_ecs_task_definition.example]
}

data "aws_db_instance" "example" {
  db_instance_identifier = "${var.common["env_abbr"]}-${var.common["name"]}-rds"
}
