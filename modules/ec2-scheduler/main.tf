# 停止スケジュール
resource "aws_cloudwatch_event_rule" "ec2_stop_schedule" {
  name                = "ec2-scheduler-stop-rule"
  description         = "Stop EC2 instance at ${var.stop_schedule_hour_utc}:00 UTC (JST ${(var.stop_schedule_hour_utc + 9) % 24}:00) daily"
  schedule_expression = "cron(0 ${var.stop_schedule_hour_utc} * * ? *)"
  state               = "ENABLED"
}

# 停止ターゲット
resource "aws_cloudwatch_event_target" "stop_lambda_target" {
  rule      = aws_cloudwatch_event_rule.ec2_stop_schedule.name
  target_id = "StopEC2Lambda"
  arn       = aws_lambda_function.stop_instance.arn
  role_arn  = aws_iam_role.eventbridge_role.arn
}

# 停止用Lambda関数のEventBridge実行許可
resource "aws_lambda_permission" "allow_eventbridge_stop" {
  statement_id  = "AllowExecutionFromEventBridgeStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_instance.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_stop_schedule.arn
}

# 起動スケジュール
resource "aws_cloudwatch_event_rule" "ec2_start_schedule" {
  name                = "ec2-scheduler-start-rule"
  description         = "Start EC2 instance at ${var.start_schedule_hour_utc}:00 UTC (JST ${(var.start_schedule_hour_utc + 9) % 24}:00) daily"
  schedule_expression = "cron(0 ${var.start_schedule_hour_utc} * * ? *)"
  state               = "ENABLED"
}

# 起動ターゲット
resource "aws_cloudwatch_event_target" "start_lambda_target" {
  rule      = aws_cloudwatch_event_rule.ec2_start_schedule.name
  target_id = "StartEC2Lambda"
  arn       = aws_lambda_function.start_instance.arn
  role_arn  = aws_iam_role.eventbridge_role.arn
}

# 起動用Lambda関数のEventBridge実行許可
resource "aws_lambda_permission" "allow_eventbridge_start" {
  statement_id  = "AllowExecutionFromEventBridgeStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_instance.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_start_schedule.arn
}
