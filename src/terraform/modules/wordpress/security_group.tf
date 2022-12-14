resource "aws_security_group" "example_alb" {
  name   = "${var.common["env_abbr"]}-${var.common["name"]}-alb-sg"
  vpc_id = var.aws_vpc["example"].id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-alb-sg"
    env  = var.common["env"]
  }
}


resource "aws_security_group" "example_ecs" {
  name   = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-sg"
  vpc_id = var.aws_vpc["example"].id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.example_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-sg"
    env  = var.common["env"]
  }
}

resource "aws_security_group" "example_blue_green" {
  name   = "${var.common["env_abbr"]}-${var.common["name"]}-blue-green-sg"
  vpc_id = var.aws_vpc["example"].id

  ingress {
    from_port   = 50001
    to_port     = 50001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.common["env_abbr"]}-${var.common["name"]}-blue-green-sg"
    description = "For ECS & CodeDeploy Blue/Green deployment listner."
    env         = var.common["env"]
  }
}

resource "aws_security_group" "example_efs" {
  name   = "${var.common["env_abbr"]}-${var.common["name"]}-efs-sg"
  vpc_id = var.aws_vpc["example"].id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.common["env_abbr"]}-${var.common["name"]}-efs-sg"
    description = "For EFS."
    env         = var.common["env"]
  }
}
