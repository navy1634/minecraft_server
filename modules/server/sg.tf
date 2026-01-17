# EC2サーバー用セキュリティグループ
resource "aws_security_group" "ec2_ssh" {
  name        = "${var.project_name}-ec2-server"
  vpc_id      = var.vpc_id
  description = "Security group for EC2 server"

  # SSH接続許可
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [for ip in var.ssh_ip : "${ip}/32"]
  }

  # Minecraftサーバーポート許可
  ingress {
    description = "Minecraft Server"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 全ての出力トラフィック許可
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
