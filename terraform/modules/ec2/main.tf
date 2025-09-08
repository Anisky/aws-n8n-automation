resource "aws_instance" "n8n" {
  count                  = 3
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  user_data              = file("${path.root}/scripts/user_data.sh")

  tags = {
    Name = "${var.instance_name}-${count.index + 1}"
  }
}
