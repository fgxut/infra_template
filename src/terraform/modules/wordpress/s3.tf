resource "aws_s3_bucket" "example_ecs_logs" {
  bucket = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-logs-${var.common["account_id"]}"

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-logs-${var.common["account_id"]}"
    env  = var.common["env"]
  }
}

resource "aws_s3_bucket_policy" "example_ecs_logs" {
  bucket = aws_s3_bucket.example_ecs_logs.id
  policy = templatefile("${path.module}/bucket_policy/ecs_logs.json", {
    BUCKET_ID = aws_s3_bucket.example_ecs_logs.id
  })

  depends_on = [aws_s3_bucket.example_ecs_logs]
}

resource "aws_s3_bucket_public_access_block" "example_ecs_logs" {
  bucket                  = aws_s3_bucket.example_ecs_logs.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "example_ecs_logs" {
  bucket = aws_s3_bucket.example_ecs_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "example_ecs_logs" {
  bucket = aws_s3_bucket.example_ecs_logs.id
  rule {
    id     = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-logs-${var.common["account_id"]}"
    status = "Enabled"
    transition {
      days          = var.wordpress["log_storage_STANDARD_IA_transition_days"]
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = var.wordpress["log_storage_GLACIER_transition_days"]
      storage_class = "GLACIER"
    }
    transition {
      days          = var.wordpress["log_storage_DEEP_ARCHIVE_transition_days"]
      storage_class = "DEEP_ARCHIVE"
    }
    expiration {
      days = var.wordpress["log_storage_expiration_days"]
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example_ecs_logs" {
  bucket = aws_s3_bucket.example_ecs_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# サーバーアクセスログもあとで追加したい
# resource "aws_s3_bucket_logging" "example_ecs_logs" {
#   bucket        = aws_s3_bucket.example_ecs_logs.id
#   target_bucket = aws_s3_bucket.s3_access_logs.id
#   target_prefix = "${aws_s3_bucket.example_ecs_logs.id}/"
# }
