resource "aws_db_subnet_group" "example" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}-db-subnet-group"
  subnet_ids = [
    var.aws_subnet["example_private"][0].id,
    var.aws_subnet["example_private"][1].id,
    var.aws_subnet["example_private"][2].id
  ]

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-db-subnet-group"
    env  = var.common["env"]
  }
}
