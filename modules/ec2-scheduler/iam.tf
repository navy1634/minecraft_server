# Lambda実行用IAMロール
resource "aws_iam_role" "lambda_role" {
  name = "ec2-scheduler-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Lambda基本実行ポリシー
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# EC2制御 & バックアップ用ポリシー
resource "aws_iam_role_policy" "lambda_ec2_policy" {
  name = "ec2-scheduler-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "arn:aws:ec2:${var.region}:*:instance/*"
      }
    ]
  })
}

# EventBridge用IAMロール
resource "aws_iam_role" "eventbridge_role" {
  name = "ec2-scheduler-eventbridge-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })
}

# EventBridge → Lambda 実行ポリシー
resource "aws_iam_role_policy" "eventbridge_lambda_policy" {
  name = "ec2-scheduler-eventbridge-policy"
  role = aws_iam_role.eventbridge_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = [
          aws_lambda_function.stop_instance.arn,
          aws_lambda_function.start_instance.arn
        ]
      }
    ]
  })
}
