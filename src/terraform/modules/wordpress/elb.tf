# ALB
resource "aws_lb" "example" {
  name               = "${var.common["env_abbr"]}-${var.common["name"]}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups = [
    aws_security_group.example_alb.id,
    aws_security_group.example_blue_green.id
  ]
  subnets = [
    var.aws_subnet["example_public"][0].id,
    var.aws_subnet["example_public"][1].id,
    var.aws_subnet["example_public"][2].id
  ]
  enable_deletion_protection = false # 本当はtrueのほうが良いが、簡単に削除できるようにするため
  drop_invalid_header_fields = true
  enable_waf_fail_open       = true
  desync_mitigation_mode     = "strictest"

  # access_logs {
  #   bucket  = var.aws_s3_bucket["elb_access_logs"].bucket
  #   prefix  = "${var.common["env_abbr"]}-${var.common["name"]}-alb"
  #   enabled = true
  # }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-alb"
    env  = var.common["env"]
  }
}

# Target Group
resource "aws_lb_target_group" "example_blue" {
  name        = "${var.common["env_abbr"]}-${var.common["name"]}-blue-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc["example"].id
  target_type = "ip"

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = "30"
    timeout             = "10"
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    matcher             = "200-302"
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-blue-tg"
    env  = var.common["env"]
  }
}

resource "aws_lb_target_group" "example_green" {
  name        = "${var.common["env_abbr"]}-${var.common["name"]}-green-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc["example"].id
  target_type = "ip"

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = "30"
    timeout             = "10"
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    matcher             = "200-302"
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-green-tg"
    env  = var.common["env"]
  }
}

# Listener
resource "aws_lb_listener" "example_http" {
  load_balancer_arn = aws_lb.example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example_blue.arn
  }

  # ECS Blue/Green deployment swaps target group
  lifecycle {
    ignore_changes = [default_action[0].target_group_arn]
  }
}
