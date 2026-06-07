variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "パブリックサブネットID"
  type        = string
}

variable "instance_type" {
  description = "EC2インスタンスタイプ"
  type        = string
  default     = "t2.micro"
}

variable "ssh_key_name" {
  description = "EC2インスタンス用のSSHキー名"
  type        = string
}

variable "s3_backup_bucket_name" {
  description = "S3バックアップバケット名"
  type        = string
}

variable "ssh_ip" {
  description = "SSH ホストのグローバルIP"
  type        = list(string)
  sensitive   = true
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "slack_channel_id" {
  description = "Slack Channel ID for AWS Chatbot"
  type        = string
  sensitive   = true
}

variable "slack_team_id" {
  description = "Slack Team ID (Workspace ID)"
  type        = string
  sensitive   = true
}
