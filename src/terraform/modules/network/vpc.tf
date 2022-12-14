resource "aws_vpc" "example" {
  cidr_block           = var.network["vpc_cidr_block"]
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-vpc"
    env  = var.common["env"]
  }
}
