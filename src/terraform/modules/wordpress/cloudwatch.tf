# NOTE: TerraformでFargateを作成した場合、タスク定義にあるCloudWatch Log groupは
#       自動的に作成されず、タスク起動エラーとなるため、Terraform側で作成が必要
resource "aws_cloudwatch_log_group" "example_ecs" {
  name              = "/aws/ecs/${var.common["env_abbr"]}-${var.common["name"]}"
  retention_in_days = var.wordpress["cloudwatch_log_group_ecs_retention_days"]

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-log-group"
    env  = var.common["env"]
  }
}

resource "aws_cloudwatch_log_subscription_filter" "example_ecs_logs" {
  name            = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-log-group"
  log_group_name  = "/aws/ecs/${var.common["env_abbr"]}-${var.common["name"]}"
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.example_ecs_logs.arn
  role_arn        = aws_iam_role.example_cwl_to_firehose_ecs_logs.arn
  distribution    = "ByLogStream"
}
