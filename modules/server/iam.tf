## IAM Role
resource "aws_iam_role" "ec2_role" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# IAM インスタンスプロファイル
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# S3 アップロード・ダウンロードポリシー
resource "aws_iam_role_policy" "s3_backup_policy" {
  name   = "${var.project_name}-s3-backup-policy"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.s3_backup_policy.json
}

data "aws_iam_policy_document" "s3_backup_policy" {
  statement {
    sid    = "S3BackupUploadDownload"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_backup_bucket_name}",
      "arn:aws:s3:::${var.s3_backup_bucket_name}/*"
    ]
  }
}

# CloudWatch Logs ポリシー
resource "aws_iam_role_policy" "cloudwatch_logs_policy" {
  name   = "${var.project_name}-cloudwatch-logs-policy"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.cloudwatch_logs_policy.json
}

data "aws_iam_policy_document" "cloudwatch_logs_policy" {
  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup"
    ]

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/ec2/${var.project_name}-server:*"
    ]
  }
}

# CloudWatch Metrics ポリシー
resource "aws_iam_role_policy" "cloudwatch_metrics_policy" {
  name   = "${var.project_name}-cloudwatch-metrics-policy"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.cloudwatch_metrics_policy.json
}

data "aws_iam_policy_document" "cloudwatch_metrics_policy" {
  statement {
    sid    = "CloudWatchMetrics"
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData"
    ]

    resources = ["*"]
  }
}

# SSM Parameter Store ポリシー
resource "aws_iam_role_policy" "ssm_parameter_policy" {
  name   = "${var.project_name}-ssm-parameter-policy"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.ssm_parameter_policy.json
}

data "aws_iam_policy_document" "ssm_parameter_policy" {
  statement {
    sid    = "SSMParameterAccess"
    effect = "Allow"

    actions = [
      "ssm:GetParameter"
    ]

    resources = [
      aws_ssm_parameter.cloudwatch_agent_config.arn
    ]
  }
}
