output "instance_id" {
  description = "EC2インスタンスID"
  value       = aws_instance.server.id
}

output "elastic_ip" {
  description = "EC2インスタンスの固定パブリックIPアドレス"
  value       = aws_eip.server.public_ip
}

output "ssh_command" {
  description = "SSH接続コマンド"
  value       = "ssh -i ~/.ssh/keys/${var.ssh_key_name}.pem ec2-user@${aws_eip.server.public_ip}"
}