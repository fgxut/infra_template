resource "aws_security_group" "example_rds" {
  name        = "${var.common["env_abbr"]}-${var.common["name"]}-rds-sg"
  description = "For ${var.common["env_abbr"]}-${var.common["name"]}-rds in RDS"
  vpc_id      = var.aws_vpc["example"].id

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [
      "${data.aws_security_group.example_bastion.id}",
      "${data.aws_security_group.example_ecs.id}"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-rds-sg"
    env  = var.common["env"]
  }
}
