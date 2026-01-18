variable "instance_id" {
  description = "EC2インスタンスID"
  type        = string
}

variable "region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "stop_schedule_hour_jst" {
  description = "EC2停止時間（JST時）。0-23の整数で指定。デフォルト: 3 (JST 03:00)"
  type        = number
  default     = 3
}

variable "start_schedule_hour_jst" {
  description = "EC2起動時間（JST時）。0-23の整数で指定。デフォルト: 21 (JST 21:00)"
  type        = number
  default     = 21
}

variable "slack_webhook_url" {
  description = "Slack Webhook URL for notifications"
  type        = string
  sensitive   = true
}
