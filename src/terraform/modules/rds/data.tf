data "aws_security_group" "example_bastion" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}-bastion-sg"
}

data "aws_security_group" "example_ecs" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-sg"
}
