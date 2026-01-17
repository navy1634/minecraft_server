# variable "project_name" {
#   description = "Project name"
#   type        = string
# }

# variable "region" {
#   description = "AWS region"
#   type        = string
#   default     = "ap-northeast-1"
# }

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "training_space_vpc"
}
