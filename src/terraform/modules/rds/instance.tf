resource "aws_db_instance" "example" {
  identifier                   = "${var.common["env_abbr"]}-${var.common["name"]}-rds"
  engine                       = var.rds["aws_db_instance_engine"]
  engine_version               = var.rds["aws_db_instance_engine_version"]
  instance_class               = var.rds["aws_db_instance_instance_class"]
  storage_type                 = "gp2"
  allocated_storage            = var.rds["aws_db_instance_instance_allocated_storage"]
  max_allocated_storage        = var.rds["aws_db_instance_instance_max_allocated_storage"]
  storage_encrypted            = true
  kms_key_id                   = aws_kms_key.example_rds.arn
  db_name                      = var.rds["aws_db_instance_instance_dbname"]
  username                     = var.rds["aws_db_instance_instance_username"]
  password                     = var.rds["aws_db_instance_instance_password"] # apply後にAWS CLIで新しいパスワードに更新する
  port                         = 3306
  publicly_accessible          = false
  vpc_security_group_ids       = [aws_security_group.example_rds.id]
  db_subnet_group_name         = aws_db_subnet_group.example.name
  option_group_name            = aws_db_option_group.example.name
  parameter_group_name         = aws_db_parameter_group.example.name
  multi_az                     = true
  auto_minor_version_upgrade   = false
  apply_immediately            = false
  deletion_protection          = false # 本当はtrueのほうが良いが、簡単に削除できるようにするため
  skip_final_snapshot          = true  # 本当はfalseのほうが良いが、削除後にスナップショットが残らないようにするため
  maintenance_window           = var.rds["aws_db_instance_instance_maintenance_window"]
  backup_window                = var.rds["aws_db_instance_instance_backup_window"]
  backup_retention_period      = var.rds["aws_db_instance_instance_backup_retention_period"]
  performance_insights_enabled = false # インスタンスクラスがdb.t3.microだとtrueにできない
  # performance_insights_retention_period = var.rds["aws_db_instance_performance_insights_retention_period"]

  enabled_cloudwatch_logs_exports = [
    "audit",
    "error",
    "general",
    "slowquery"
  ]

  lifecycle {
    ignore_changes = [password]
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-rds"
    env  = var.common["env"]
  }
}
