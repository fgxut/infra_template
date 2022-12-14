resource "aws_instance" "example_bastion" {
  ami                         = "ami-072bfb8ae2c884cc4"
  instance_type               = "t2.micro"
  key_name                    = "${var.common["env_abbr"]}-${var.common["name"]}-key" # 事前にAWS CLIで作成
  monitoring                  = true
  subnet_id                   = var.aws_subnet["example_public"][0].id
  ebs_optimized               = false
  iam_instance_profile        = aws_iam_instance_profile.example_bastion.name
  vpc_security_group_ids      = [aws_security_group.example_bastion.id]
  associate_public_ip_address = true
  disable_api_termination     = false

  user_data = templatefile("${path.module}/user_data.sh", {
    HOST_NAME = "${var.common["env_abbr"]}-${var.common["name"]}-bastion"
  })

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-bastion"
    env  = var.common["env"]
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    iops                  = 3000
    throughput            = 125
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name = "${var.common["env_abbr"]}-${var.common["name"]}-bastion-volume"
      env  = var.common["env"]
    }
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}
