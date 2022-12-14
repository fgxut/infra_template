resource "aws_kinesis_firehose_delivery_stream" "example_ecs_logs" {
  name        = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-logs"
  destination = "s3"

  s3_configuration {
    role_arn        = aws_iam_role.example_firehose_ecs_logs.arn
    bucket_arn      = aws_s3_bucket.example_ecs_logs.arn
    buffer_size     = 5
    buffer_interval = 60

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/ecs/${var.common["env_abbr"]}-${var.common["name"]}"
      log_stream_name = "S3Delivery"
    }
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-logs"
    env  = var.common["env"]
  }
}
