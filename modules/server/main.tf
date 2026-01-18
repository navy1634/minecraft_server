resource "aws_instance" "server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true

  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  monitoring                  = true
  vpc_security_group_ids = [aws_security_group.ec2_ssh.id]
  subnet_id              = var.public_subnet_id
  key_name               = var.ssh_key_name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = true
    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }

  user_data = templatefile("${path.module}/../../scripts/shell/user_data.sh.tpl", {
    minecraft_service    = templatefile("${path.module}/../../scripts/shell/minecraft.service.tpl", { s3_backup_bucket_name = var.s3_backup_bucket_name })
    backup_world_script  = file("${path.module}/../../scripts/shell/backup-world.sh")
    ssm_parameter_name   = aws_ssm_parameter.cloudwatch_agent_config.name
  })

  tags = {
    Name = "${var.project_name}-server"
  }
}

# 固定パブリックIP
resource "aws_eip" "server" {
  instance = aws_instance.server.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-server"
  }
}
