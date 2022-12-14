# ECS
## 1)タスクロール
resource "aws_iam_role" "example_ecs_task_role" {
  name               = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-task-role"
  assume_role_policy = file("${path.module}/assume_role_policy/ecs_task.json")

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-task-role"
    env  = var.common["env"]
  }
}

resource "aws_iam_policy" "example_ecs_task_role_ssm_parameter" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-task-role-ssm-parameter-policy"

  policy = templatefile("${path.module}/iam_policy/ecs_task_role_ssm_parameter.json", {
    REGION     = var.common["region"]
    ACCOUNT_ID = var.common["account_id"]
  })

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-task-role-ssm-parameter-policy"
    env  = var.common["env"]
  }
}

resource "aws_iam_role_policy_attachment" "example_ecs_task_role_ssm_parameter" {
  role       = aws_iam_role.example_ecs_task_role.name
  policy_arn = aws_iam_policy.example_ecs_task_role_ssm_parameter.arn
}

resource "aws_iam_policy" "example_ecs_task_role_s3" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-task-role-s3-policy"

  policy = templatefile("${path.module}/iam_policy/ecs_task_role_s3.json", {
    ENV_ABBR   = var.common["env_abbr"]
    NAME       = var.common["name"]
    ACCOUNT_ID = var.common["account_id"]
  })

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-task-role-s3-policy"
    env  = var.common["env"]
  }
}

resource "aws_iam_role_policy_attachment" "example_ecs_task_role_s3" {
  role       = aws_iam_role.example_ecs_task_role.name
  policy_arn = aws_iam_policy.example_ecs_task_role_s3.arn
}

## 2)タスク実行ロール
resource "aws_iam_role" "example_ecs_task_execution_role" {
  name               = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-task-execution-role"
  assume_role_policy = file("${path.module}/assume_role_policy/ecs_task.json")

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-task-execution-role"
    env  = var.common["env"]
  }
}

resource "aws_iam_policy" "example_ecs_task_execution_role_ssm_parameter" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-task-execution-role-ssm-parameter-policy"

  policy = templatefile("${path.module}/iam_policy/ecs_task_execution_role_ssm_parameter.json", {
    REGION     = var.common["region"]
    ACCOUNT_ID = var.common["account_id"]
    ENV_ABBR   = var.common["env_abbr"]
    NAME       = var.common["name"]
  })

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-task-execution-role-ssm-parameter-policy"
    env  = var.common["env"]
  }
}

resource "aws_iam_role_policy_attachment" "example_ecs_task_execution_role_ssm_parameter" {
  role       = aws_iam_role.example_ecs_task_execution_role.name
  policy_arn = aws_iam_policy.example_ecs_task_execution_role_ssm_parameter.arn
}

resource "aws_iam_role_policy_attachment" "example_ecs_task_execution_role_policy" {
  role       = aws_iam_role.example_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Kinesis Firehose

resource "aws_iam_role" "example_firehose_ecs_logs" {
  name               = "${var.common["env_abbr"]}-${var.common["name"]}-firehose-ecs-logs-role"
  assume_role_policy = file("${path.module}/assume_role_policy/firehose.json")

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-firehose-ecs-logs-role"
    env  = var.common["env"]
  }
}

resource "aws_iam_policy" "example_firehose_ecs_logs" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}-firehose-ecs-logs-policy"

  policy = templatefile("${path.module}/iam_policy/firehose.json", {
    BUCKET_ID = aws_s3_bucket.example_ecs_logs.id
  })

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-firehose-ecs-logs-policy"
    env  = var.common["env"]
  }
}

resource "aws_iam_role_policy_attachment" "example_firehose_ecs_logs" {
  role       = aws_iam_role.example_firehose_ecs_logs.name
  policy_arn = aws_iam_policy.example_firehose_ecs_logs.arn
}

# CloudWatch Log

resource "aws_iam_role" "example_cwl_to_firehose_ecs_logs" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}-cwl-to-firehose-ecs-logs-role"
  assume_role_policy = templatefile("${path.module}/assume_role_policy/cloudwatch_log.json", {
    REGION = var.common["region"]
  })

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-cwl-to-firehose-ecs-logs-role"
    env  = var.common["env"]
  }
}

resource "aws_iam_policy" "example_cwl_to_firehose_ecs_logs" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}-cwl-to-firehose-ecs-logs-policy"

  policy = templatefile("${path.module}/iam_policy/cwl_to_firehose_ecs_logs.json", {
    REGION       = var.common["region"]
    ACCOUNT_ID   = var.common["account_id"]
    IAM_ROLE_ARN = aws_iam_role.example_cwl_to_firehose_ecs_logs.arn
  })

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-cwl-to-firehose-ecs-logs-policy"
    env  = var.common["env"]
  }
}

resource "aws_iam_role_policy_attachment" "example_cwl_to_firehose_ecs_logs" {
  role       = aws_iam_role.example_cwl_to_firehose_ecs_logs.name
  policy_arn = aws_iam_policy.example_cwl_to_firehose_ecs_logs.arn
}
