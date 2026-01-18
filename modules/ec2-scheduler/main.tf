# 停止スケジュール
resource "aws_scheduler_schedule" "ec2_stop_schedule" {
  name                         = "ec2-scheduler-stop-rule"
  description                  = "Stop EC2 instance at ${var.stop_schedule_hour_jst}:00 JST daily"
  schedule_expression          = "cron(0 ${var.stop_schedule_hour_jst} * * ? *)"
  state                        = "ENABLED"
  schedule_expression_timezone = "Asia/Tokyo"
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.stop_instance.arn
    role_arn = aws_iam_role.eventbridge_role.arn
    retry_policy {
      maximum_retry_attempts = 5
    }
  }
}

# 停止 Lambda 関数の実行許可
resource "aws_lambda_permission" "allow_eventbridge_stop" {
  statement_id  = "AllowExecutionFromEventBridgeStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_instance.function_name
  principal     = "scheduler.amazonaws.com"
  source_arn    = aws_scheduler_schedule.ec2_stop_schedule.arn
}

# 起動スケジュール
resource "aws_scheduler_schedule" "ec2_start_schedule" {
  name                         = "ec2-scheduler-start-rule"
  description                  = "Start EC2 instance at ${var.start_schedule_hour_jst}:00 JST daily"
  schedule_expression          = "cron(0 ${var.start_schedule_hour_jst} * * ? *)"
  state                        = "ENABLED"
  schedule_expression_timezone = "Asia/Tokyo"
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.start_instance.arn
    role_arn = aws_iam_role.eventbridge_role.arn
    retry_policy {
      maximum_retry_attempts = 5
    }
  }
}

# 起動 Lambda 関数の実行許可
resource "aws_lambda_permission" "allow_eventbridge_start" {
  statement_id  = "AllowExecutionFromEventBridgeStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_instance.function_name
  principal     = "scheduler.amazonaws.com"
  source_arn    = aws_scheduler_schedule.ec2_start_schedule.arn
}
