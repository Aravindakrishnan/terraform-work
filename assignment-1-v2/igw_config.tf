resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.aravind_terraform_vpc.id

  tags = {
    Name = "aravind_internet_gateway"
  }
}