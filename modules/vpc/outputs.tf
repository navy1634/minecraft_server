output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.training_space_vpc.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.training_space_vpc.cidr_block
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value = [
    aws_subnet.subnet_private_a.id,
    aws_subnet.subnet_private_c.id,
    aws_subnet.subnet_private_d.id,
  ]
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.subnet_public_a.id,
    aws_subnet.subnet_public_c.id,
    aws_subnet.subnet_public_d.id,
  ]
}

output "public_subnet_cidr_blocks" {
  description = "Public subnet CIDR blocks"
  value = [
    aws_subnet.subnet_public_a.cidr_block,
    aws_subnet.subnet_public_c.cidr_block,
    aws_subnet.subnet_public_d.cidr_block,
  ]
}

output "private_subnet_cidr_blocks" {
  description = "Private subnet CIDR blocks"
  value = [
    aws_subnet.subnet_private_a.cidr_block,
    aws_subnet.subnet_private_c.cidr_block,
    aws_subnet.subnet_private_d.cidr_block,
  ]
}