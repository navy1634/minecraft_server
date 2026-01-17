variable "instance_id" {
  description = "EC2インスタンスID"
  type        = string
}

variable "region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "stop_schedule_hour_utc" {
  description = "EC2停止時間（UTC時）。0-23の整数で指定。デフォルト: 18 (JST 03:00)"
  type        = number
  default     = 18
}

variable "start_schedule_hour_utc" {
  description = "EC2起動時間（UTC時）。0-23の整数で指定。デフォルト: 12 (JST 21:00)"
  type        = number
  default     = 12
}

variable "slack_webhook_url" {
  description = "Slack Webhook URL for notifications"
  type        = string
  sensitive   = true
}
