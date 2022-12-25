variable "common" {
  type = map(string)
  default = {
    account_id = "123456789123"
    profile    = "hoge"
    region     = "ap-northeast-1"
    env        = "production"
    env_abbr   = "prd"
    name       = "example"
  }
}

variable "network" {
  type = map(string)
  default = {
    vpc_cidr_block = "172.16.0.0/16"
  }
}

variable "rds" {
  type = map(string)
  default = {
    aws_db_instance_engine                                = "mysql"
    aws_db_instance_engine_version                        = "5.7.40"
    aws_db_instance_instance_class                        = "db.t3.micro"
    aws_db_instance_instance_allocated_storage            = 20
    aws_db_instance_instance_max_allocated_storage        = 20
    aws_db_instance_instance_dbname                       = "example"
    aws_db_instance_instance_username                     = "example"
    aws_db_instance_instance_password                     = "InitialPassword!"
    aws_db_instance_instance_maintenance_window           = "sun:20:10-sun:20:40"
    aws_db_instance_instance_backup_window                = "19:10-19:40"
    aws_db_instance_instance_backup_retention_period      = 1
    aws_db_instance_performance_insights_retention_period = 7
  }
}

variable "wordpress" {
  type = map(string)
  default = {
    # WordPress
    wordpress_db_password = "InitialPassword!"

    # ECS
    ## ECS task
    ecs_task_cpu    = 256
    ecs_task_memory = 512
    ## ECS service
    ecs_fargate_platform_version           = "1.4.0"
    ecs_desired_count                      = 2 # lifecycle ignore_changes is set
    ecs_deployment_minimum_healthy_percent = 100
    ecs_deployment_maximum_percent         = 200

    # ECR
    ecr_image_expire_days = 7

    # CloudWatch
    cloudwatch_log_group_ecs_retention_days = 1

    # S3
    log_storage_STANDARD_IA_transition_days  = 30
    log_storage_GLACIER_transition_days      = 90
    log_storage_DEEP_ARCHIVE_transition_days = 180
    log_storage_expiration_days              = 365
  }
}
