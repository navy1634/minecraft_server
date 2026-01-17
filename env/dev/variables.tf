variable "ssh_ip" {
  description = "SSH ホストのグローバルIP"
  type        = list(string)
  sensitive   = true
}

variable "slack_webhook_url" {
  description = "Slack Webhook URL for EC2 notifications"
  type        = string
  sensitive   = true
}
