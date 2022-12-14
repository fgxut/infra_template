resource "aws_iam_instance_profile" "example_bastion" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}-bastion-instance-profile"
  role = aws_iam_role.example_bastion.name
}

resource "aws_iam_role" "example_bastion" {
  name               = "${var.common["env_abbr"]}-${var.common["name"]}-bastion-role"
  assume_role_policy = file("${path.module}/assume_role_policy/ec2.json")

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-bastion-role"
    env  = var.common["env"]
  }
}

resource "aws_iam_policy" "example_bastion_ssm_start_ssh_session" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}-bastion-ssm-start-ssh-session-policy"

  policy = templatefile("${path.module}/iam_policy/ssm_start_ssh_session.json", {
    REGION      = var.common["region"]
    ACCOUNT_ID  = var.common["account_id"]
    INSTANCE_ID = aws_instance.example_bastion.id
  })

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-bastion-ssm-start-ssh-session-policy"
    env  = var.common["env"]
  }
}

resource "aws_iam_role_policy_attachment" "example_bastion_ssm_start_ssh_session" {
  role       = aws_iam_role.example_bastion.name
  policy_arn = aws_iam_policy.example_bastion_ssm_start_ssh_session.arn
}

resource "aws_iam_role_policy_attachment" "example_bastion_CloudWatchAgentServerPolicy" {
  role       = aws_iam_role.example_bastion.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "example_bastion_AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.example_bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
