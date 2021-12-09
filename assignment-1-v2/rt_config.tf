# public route-table

resource "aws_route_table" "aravind_public_rt" {
  vpc_id = aws_vpc.aravind_terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "aravind_public_rt"
  }
}

# private route-table

resource "aws_route_table" "aravind_private_rt" {
  vpc_id = aws_vpc.aravind_terraform_vpc.id
  tags = {
    Name = "aravind_private_rt"
  }
}

# publicRT - 2 public subnets association

resource "aws_route_table_association" "pub_rta" {
  count          = length(aws_subnet.aravind_pubsubnet)
  subnet_id      = aws_subnet.aravind_pubsubnet[count.index].id
  route_table_id = aws_route_table.aravind_public_rt.id
}

# privateRT - 2 private subnets association

resource "aws_route_table_association" "priv_rta" {
  count          = length(aws_subnet.aravind_privsubnet)
  subnet_id      = aws_subnet.aravind_privsubnet[count.index].id
  route_table_id = aws_route_table.aravind_private_rt.id
}

