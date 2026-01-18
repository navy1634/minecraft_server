# インスタンス起動 Lambda 関数
data "archive_file" "start_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../scripts/functions/start_instance_lambda_function.py"
  output_path = "${path.module}/../../scripts/functions/zip/start_instance_lambda_function.zip"
}

# インスタンス停止 Lambda 関数
data "archive_file" "stop_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../scripts/functions/stop_instance_lambda_function.py"
  output_path = "${path.module}/../../scripts/functions/zip/stop_instance_lambda_function.zip"
}

# インスタンス停止 Lambda 関数
resource "aws_lambda_function" "stop_instance" {
  filename         = data.archive_file.stop_lambda_zip.output_path
  function_name    = "ec2-scheduler-stop"
  role             = aws_iam_role.lambda_role.arn
  handler          = "stop_instance_lambda_function.handler"
  runtime          = "python3.13"
  source_code_hash = data.archive_file.stop_lambda_zip.output_base64sha256

  environment {
    variables = {
      INSTANCE_ID      = var.instance_id
      SLACK_CHANNEL_ID = var.slack_channel_id
      SLACK_BOT_TOKEN  = var.slack_bot_token
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_iam_role_policy.lambda_ec2_policy
  ]
}

# インスタンス起動 Lambda 関数
resource "aws_lambda_function" "start_instance" {
  filename         = data.archive_file.start_lambda_zip.output_path
  function_name    = "ec2-scheduler-start"
  role             = aws_iam_role.lambda_role.arn
  handler          = "start_instance_lambda_function.handler"
  runtime          = "python3.13"
  source_code_hash = data.archive_file.start_lambda_zip.output_base64sha256

  environment {
    variables = {
      INSTANCE_ID      = var.instance_id
      SLACK_CHANNEL_ID = var.slack_channel_id
      SLACK_BOT_TOKEN  = var.slack_bot_token
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_iam_role_policy.lambda_ec2_policy
  ]
}
