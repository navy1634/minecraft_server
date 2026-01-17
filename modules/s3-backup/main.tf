# S3バケット - マインクラフトワールドデータ保存用
resource "aws_s3_bucket" "minecraft_backup" {
  bucket = var.bucket_name

  tags = {
    Name = "Minecraft Backup"
  }
}

# バージョニングを有効化
resource "aws_s3_bucket_versioning" "minecraft_backup" {
  bucket = aws_s3_bucket.minecraft_backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ライフサイクルポリシー
resource "aws_s3_bucket_lifecycle_configuration" "minecraft_backup" {
  bucket = aws_s3_bucket.minecraft_backup.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    filter {
      prefix = "backups/"
    }

    # 10日以上前のバージョンを削除
    noncurrent_version_expiration {
      noncurrent_days = 10
    }
  }
}

# サーバーサイド暗号化
resource "aws_s3_bucket_server_side_encryption_configuration" "minecraft_backup" {
  bucket = aws_s3_bucket.minecraft_backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
