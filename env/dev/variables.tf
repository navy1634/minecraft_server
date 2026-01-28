variable "ssh_ip" {
  description = "SSH ホストのグローバルIP"
  type        = list(string)
  sensitive   = true
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

variable "slack_bot_token" {
  description = "Slack Bot Token for Lambda"
  type        = string
  sensitive   = true
}

variable "discord_webhook" {
  description = "Discord Webhook URL for Notifications"
  type        = string
  sensitive   = true
}
