output "bucket_name" {
  value       = aws_s3_bucket.minecraft_backup.id
  description = "S3バケット名"
}

output "bucket_arn" {
  value       = aws_s3_bucket.minecraft_backup.arn
  description = "S3バケットのARN"
}
