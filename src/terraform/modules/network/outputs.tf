output "aws_vpc" {
  value = {
    example = aws_vpc.example
  }
}

output "aws_subnet" {
  value = {
    example_public  = aws_subnet.example_public
    example_private = aws_subnet.example_private
  }
}
