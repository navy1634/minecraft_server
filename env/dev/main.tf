locals {
  env = "dev"
  # environment = "development"
  project = "minecraft"
  region  = "ap-northeast-1"
}

# 現在のAWSアカウントIDを取得
data "aws_caller_identity" "current" {}

# VPC
module "vpc" {
  source   = "../../modules/vpc"
  vpc_name = "vpc-${local.project}-${local.env}"
}

# S3 Backup Bucket
module "s3_backup" {
  source      = "../../modules/s3-backup"
  bucket_name = "${local.project}-${local.env}-world-backup-${data.aws_caller_identity.current.account_id}"
}

# EC2
module "server" {
  source = "../../modules/server"

  project_name          = local.project
  vpc_id                = module.vpc.vpc_id
  public_subnet_id      = module.vpc.public_subnet_ids[0]
  ssh_key_name          = "minecraft"
  instance_type         = "t3.medium"
  s3_backup_bucket_name = module.s3_backup.bucket_name
  ssh_ip                = var.ssh_ip
}

# EC2 Scheduler
module "ec2_scheduler" {
  source = "../../modules/ec2-scheduler"

  instance_id             = module.server.instance_id
  region                  = local.region
  stop_schedule_hour_utc  = 18 # JST 03:00
  start_schedule_hour_utc = 12 # JST 21:00

  depends_on = [module.server]
}
