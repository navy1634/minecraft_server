# SNS トピック
resource "aws_sns_topic" "cloudwatch_alarms" {
  name = "${var.project_name}-cloudwatch-alarms"

  tags = {
    Name = "${var.project_name}-alarms"
  }
}

# AWS Chatbot Slack Channel Configuration
resource "aws_chatbot_slack_channel_configuration" "cloudwatch_alarms" {
  slack_channel_id   = var.slack_channel_id
  iam_role_arn       = aws_iam_role.chatbot_role.arn
  slack_team_id      = var.slack_team_id
  configuration_name = "${var.project_name}-cloudwatch-alarms"
  sns_topic_arns     = [aws_sns_topic.cloudwatch_alarms.arn]
  logging_level      = "INFO"

  depends_on = [aws_iam_role_policy.chatbot_policy]
}

# IAM Role for AWS Chatbot
resource "aws_iam_role" "chatbot_role" {
  name = "${var.project_name}-chatbot-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "chatbot.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for AWS Chatbot
resource "aws_iam_role_policy" "chatbot_policy" {
  name = "${var.project_name}-chatbot-policy"
  role = aws_iam_role.chatbot_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:Describe*",
          "ec2:Describe*"
        ]
        Resource = "*"
      }
    ]
  })
}

# CPU 使用率が高い場合のアラーム
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  datapoints_to_alarm                   = 2
  extended_statistic                    = "p90"
  threshold           = "80"
  alarm_description   = "アラーム: EC2 CPU 使用率が 80% 以上"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]

  dimensions = {
    InstanceId = aws_instance.server.id
  }
}

# ディスク空き容量が低い場合のアラーム
resource "aws_cloudwatch_metric_alarm" "disk_space_low" {
  alarm_name          = "${var.project_name}-disk-space-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DiskSpaceUtilization"
  namespace           = "CWAgent"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"
  alarm_description   = "アラーム: ディスク空き容量が 20% 以下"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]
  datapoints_to_alarm                   = 2
  dimensions = {
          "device"     = "nvme0n1p1"
          "fstype"     = "xfs"
          "host"       = "ip-10-0-11-102.ap-northeast-1.compute.internal"
          "path"       = "/"
           }
}

# メモリ使用率が高い場合のアラーム
resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "${var.project_name}-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "CWAgent"
  datapoints_to_alarm                   = 2
  extended_statistic                    = "p90"
  period              = "120"
  threshold           = "80"
  alarm_description   = "アラーム: EC2 メモリ使用率が 80% 以上"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]

  dimensions = {
    host = "ip-10-0-11-102.ap-northeast-1.compute.internal"
  }
}

# CloudWatch ログイングループ
resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "/aws/ec2/${var.project_name}-server"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-logs"
  }
}

# CloudWatch Agent 用パラメータストア設定
resource "aws_ssm_parameter" "cloudwatch_agent_config" {
  name        = "/cloudwatch-agent-config/${var.project_name}-server"
  description = "CloudWatch Agent configuration for Minecraft server"
  type        = "String"
  value = jsonencode({
    "metrics" : {
      "namespace" : "CWAgent",
      "metrics_collected" : {
        "mem" : {
          "measurement" : [
            {
              "name" : "mem_used_percent",
              "rename" : "MemoryUtilization",
              "unit" : "Percent"
            }
          ],
          "metrics_collection_interval" : 60
        },
        "disk" : {
          "measurement" : [
            {
              "name" : "used_percent",
              "rename" : "DiskSpaceUtilization",
              "unit" : "Percent"
            }
          ],
          "metrics_collection_interval" : 60,
          "resources" : [
            "/"
          ]
        }
      }
    },
    "logs" : {
      "logs_collected" : {
        "files" : {
          "collect_list" : [
            {
              "file_path" : "/var/log/minecraft/server.log",
              "log_group_name" : aws_cloudwatch_log_group.ec2_logs.name,
              "log_stream_name" : "minecraft-server"
            }
          ]
        }
      }
    }
  })

  tags = {
    Name = "${var.project_name}-cloudwatch-config"
  }
}
