# 起動用Lambda関数のアーカイブ
data "archive_file" "start_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../scripts/start_instance_lambda_function.py"
  output_path = "${path.module}/start_instance_lambda_function.zip"
}

# 停止用Lambda関数のアーカイブ（バックアップ付き）
data "archive_file" "stop_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../scripts/stop_instance_lambda_function.py"
  output_path = "${path.module}/stop_instance_lambda_function.zip"
}

# 停止用Lambda関数（バックアップ付き）
resource "aws_lambda_function" "stop_instance" {
  filename         = data.archive_file.stop_lambda_zip.output_path
  function_name    = "ec2-scheduler-stop"
  role             = aws_iam_role.lambda_role.arn
  handler          = "stop_instance_lambda_function.handler"
  runtime          = "python3.13"
  source_code_hash = data.archive_file.stop_lambda_zip.output_base64sha256

  environment {
    variables = {
      INSTANCE_ID = var.instance_id
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_iam_role_policy.lambda_ec2_policy
  ]
}

# 起動用Lambda関数
resource "aws_lambda_function" "start_instance" {
  filename         = data.archive_file.start_lambda_zip.output_path
  function_name    = "ec2-scheduler-start"
  role             = aws_iam_role.lambda_role.arn
  handler          = "start_instance_lambda_function.handler"
  runtime          = "python3.13"
  source_code_hash = data.archive_file.start_lambda_zip.output_base64sha256

  environment {
    variables = {
      INSTANCE_ID = var.instance_id
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_iam_role_policy.lambda_ec2_policy
  ]
}
