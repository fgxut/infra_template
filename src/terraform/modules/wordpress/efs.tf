resource "aws_efs_file_system" "example" {
  creation_token                  = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-efs"
  provisioned_throughput_in_mibps = "50"
  throughput_mode                 = "provisioned"

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-efs"
    env  = var.common["env"]
  }
}

resource "aws_efs_mount_target" "example_1a" {
  file_system_id = aws_efs_file_system.example.id
  subnet_id      = var.aws_subnet["example_public"][0].id
  security_groups = [
    aws_security_group.example_efs.id
  ]
}

resource "aws_efs_mount_target" "example_1c" {
  file_system_id = aws_efs_file_system.example.id
  subnet_id      = var.aws_subnet["example_public"][1].id
  security_groups = [
    aws_security_group.example_efs.id
  ]
}

resource "aws_efs_mount_target" "example_1d" {
  file_system_id = aws_efs_file_system.example.id
  subnet_id      = var.aws_subnet["example_public"][2].id
  security_groups = [
    aws_security_group.example_efs.id
  ]
}
