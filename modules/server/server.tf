resource "aws_instance" "server" {
  ami                         = "ami-0a85e8e68d29c380f"
  instance_type               = var.instance_type
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  vpc_security_group_ids = [aws_security_group.ec2_ssh.id]
  subnet_id              = var.public_subnet_id
  key_name               = var.ssh_key_name

  user_data = templatefile("${path.module}/../../scripts/user_data.sh.tpl", {
    minecraft_service    = templatefile("${path.module}/../../scripts/minecraft.service.tpl", { s3_backup_bucket_name = var.s3_backup_bucket_name })
    backup_world_script  = file("${path.module}/../../scripts/backup-world.sh")
  })

  tags = {
    Name = "${var.project_name}-server"
  }
}

# 固定パブリックIP
resource "aws_eip" "server" {
  instance = aws_instance.server.id
  domain   = "vpc"

  depends_on = [aws_instance.server]
}
