resource "aws_security_group" "example_bastion" {
  name   = "${var.common["env_abbr"]}-${var.common["name"]}-bastion-sg"
  vpc_id = var.aws_vpc["example"].id

  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      security_groups  = []
      prefix_list_ids  = []
      ipv6_cidr_blocks = []
      self             = false
    }
  ]

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-bastion-sg"
    env  = var.common["env"]
  }
}
