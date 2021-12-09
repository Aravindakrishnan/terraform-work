#public-subnet-1

resource "aws_subnet" "aravind_pubsubnet" {
  count             = length(var.pubsubnet_cidr)
  vpc_id            = aws_vpc.aravind_terraform_vpc.id
  cidr_block        = var.pubsubnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "aravind_pubsubnet"
    author = "akrishnanh@presidio.com"
  }
}

#private-subnet-1

resource "aws_subnet" "aravind_privsubnet" {
  count             = length(var.privsubnet_cidr)
  vpc_id            = aws_vpc.aravind_terraform_vpc.id
  cidr_block        = var.privsubnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "aravind_privsubnet"
    author = "akrishnanh@presidio.com"
  }
}

# private subnet group for db 

resource "aws_db_subnet_group" "aravind_subnet_group" {
  name       = "aravind-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.aravind_privsubnet : subnet.id]
  tags = {
    Name = "aravind_subnet_group"
    author = "akrishnanh@presidio.com"
  }
}