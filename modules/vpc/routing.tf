## route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.training_space_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.training_space_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

## association
resource "aws_route_table_association" "subnet_private_a" {
  subnet_id      = aws_subnet.subnet_private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "subnet_private_c" {
  subnet_id      = aws_subnet.subnet_private_c.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "subnet_private_d" {
  subnet_id      = aws_subnet.subnet_private_d.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "subnet_public_a" {
  subnet_id      = aws_subnet.subnet_public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "subnet_public_c" {
  subnet_id      = aws_subnet.subnet_public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "subnet_public_d" {
  subnet_id      = aws_subnet.subnet_public_d.id
  route_table_id = aws_route_table.public.id
}
