# Public

resource "aws_route_table" "example_public" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-public-rtb"
    env  = var.common["env"]
  }
}

resource "aws_route_table_association" "example_public" {
  count = 3

  subnet_id      = aws_subnet.example_public[count.index].id
  route_table_id = aws_route_table.example_public.id
}

resource "aws_route" "example_public" {
  route_table_id         = aws_route_table.example_public.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

# Private 

resource "aws_route_table" "example_private" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-private-rtb"
    env  = var.common["env"]
  }
}

resource "aws_route_table_association" "example_private" {
  count = 3

  subnet_id      = aws_subnet.example_private[count.index].id
  route_table_id = aws_route_table.example_private.id
}
