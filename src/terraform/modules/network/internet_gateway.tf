resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-igw"
    env  = var.common["env"]
  }
}
