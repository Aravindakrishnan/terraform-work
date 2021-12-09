resource "aws_vpc" "aravind_terraform_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "aravind_terraform_vpc"
  }
}
