terraform {
  backend "s3" {
    bucket  = "terraform-sandbox.tfstate"
    profile = "default"
    key     = "minecraft/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}
