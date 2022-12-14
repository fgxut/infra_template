resource "aws_ecr_repository" "example" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}"
    env  = var.common["env"]
  }
}

resource "aws_ecr_lifecycle_policy" "example" {
  repository = aws_ecr_repository.example.name

  policy = templatefile("${path.module}/ecr/lifecycle_policy.json", {
    RESOURCE_NAME = aws_ecr_repository.example.name
    DAYS          = var.wordpress["ecr_image_expire_days"]
  })
}
