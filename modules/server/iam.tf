## IAM Role
resource "aws_iam_role" "training_ec2_role" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# IAMインスタンスプロファイル
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.training_ec2_role.name
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

# S3バケットへのアップロード権限
resource "aws_iam_role_policy" "s3_backup_policy" {
  name   = "${var.project_name}-s3-backup-policy"
  role   = aws_iam_role.training_ec2_role.id
  policy = data.aws_iam_policy_document.s3_backup_policy.json
}

data "aws_iam_policy_document" "s3_backup_policy" {
  statement {
    sid    = "S3BackupUpload"
    effect = "Allow"

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_backup_bucket_name}/*"
    ]
  }
}
