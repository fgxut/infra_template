resource "aws_subnet" "example_public" {
  count = 3

  availability_zone = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(aws_vpc.example.cidr_block, 6, count.index)

  vpc_id                  = aws_vpc.example.id
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-public-subnet-${var.availability_zones[count.index]}"
    env  = var.common["env"]
  }
}

resource "aws_subnet" "example_private" {
  count = 3

  availability_zone = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(aws_vpc.example.cidr_block, 6, count.index + length(aws_subnet.example_public))

  vpc_id                  = aws_vpc.example.id
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-private-subnet-${var.availability_zones[count.index]}"
    env  = var.common["env"]
  }
}
