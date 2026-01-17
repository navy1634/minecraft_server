## VPC
resource "aws_vpc" "training_space_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.vpc_name
  }
}

## subnet
resource "aws_subnet" "subnet_private_a" {
  vpc_id            = aws_vpc.training_space_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.vpc_name}-PrivateA"
  }
}

resource "aws_subnet" "subnet_private_c" {
  vpc_id            = aws_vpc.training_space_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.vpc_name}-PrivateC"
  }
}

resource "aws_subnet" "subnet_private_d" {
  vpc_id            = aws_vpc.training_space_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1d"

  tags = {
    Name = "${var.vpc_name}-PrivateD"
  }
}

resource "aws_subnet" "subnet_public_a" {
  vpc_id                  = aws_vpc.training_space_vpc.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-PublicA"
  }
}

resource "aws_subnet" "subnet_public_c" {
  vpc_id                  = aws_vpc.training_space_vpc.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-PublicC"
  }
}

resource "aws_subnet" "subnet_public_d" {
  vpc_id                  = aws_vpc.training_space_vpc.id
  cidr_block              = "10.0.13.0/24"
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-PublicD"
  }
}

## gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.training_space_vpc.id
  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

resource "aws_nat_gateway" "ngw" {
  subnet_id     = aws_subnet.subnet_public_a.id
  allocation_id = aws_eip.ngw.id
  tags = {
    Name = "${var.vpc_name}-NGW"
  }
}

resource "aws_eip" "ngw" {
  tags = {
    Name = "${var.vpc_name}-NGW"
  }
}
