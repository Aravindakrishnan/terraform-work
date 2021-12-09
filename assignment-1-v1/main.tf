terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 3.27"
    }
  }
  backend "s3" {
    bucket = "aravind-terraform-bucket"  
    key = "terraform.tfstate"
    region = "us-east-1"  
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# vpc

resource "aws_vpc" "aravind_terraform_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "aravind_terraform_vpc"
  }
}

# internet-gateway

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.aravind_terraform_vpc.id

  tags = {
    Name = "aravind_internet_gateway"
  }
}

resource "aws_security_group" "aravind_sg" {
  vpc_id = aws_vpc.aravind_terraform_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "aravind_sg"
  }
}

#public-subnet-1

resource "aws_subnet" "aravind_pubsubnet_1" {
  vpc_id            = aws_vpc.aravind_terraform_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "aravind_pubsubnet_1"
  }
}

#public-subnet-2

resource "aws_subnet" "aravind_pubsubnet_2" {
  vpc_id            = aws_vpc.aravind_terraform_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "aravind_pubsubnet_2"
  }
}

#private-subnet-1

resource "aws_subnet" "aravind_privsubnet_1" {
  vpc_id            = aws_vpc.aravind_terraform_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "aravind_privsubnet_1"
  }
}

#private-subnet-2

resource "aws_subnet" "aravind_privsubnet_2" {
  vpc_id            = aws_vpc.aravind_terraform_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "aravind_privsubnet_2"
  }
}

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

  route = []

  tags = {
    Name = "aravind_private_rt"
  }
}

# publicRT - 2 public subnets association

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.aravind_pubsubnet_1.id
  route_table_id = aws_route_table.aravind_public_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.aravind_pubsubnet_2.id
  route_table_id = aws_route_table.aravind_public_rt.id
}

# privateRT - 2 public subnets association

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.aravind_privsubnet_1.id
  route_table_id = aws_route_table.aravind_private_rt.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.aravind_privsubnet_2.id
  route_table_id = aws_route_table.aravind_private_rt.id
}
# instances

resource "aws_instance" "aravind_server_1" {
  ami                         = "ami-0ed9277fb7eb570c9"
  instance_type               = "t2.micro"
  key_name                    = "aravindakrishnan_keypair"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.aravind_pubsubnet_1.id
  availability_zone           = "us-east-1a"
  vpc_security_group_ids      = [aws_security_group.aravind_sg.id]
  user_data                   = file("./user_data1.sh")
  tags = {
    Name = "aravind_terraform_1"
  }
}

resource "aws_instance" "aravind_server_2" {
  ami                         = "ami-0ed9277fb7eb570c9"
  instance_type               = "t2.micro"
  key_name                    = "aravindakrishnan_keypair"
  associate_public_ip_address = true
  availability_zone           = "us-east-1b"
  subnet_id                   = aws_subnet.aravind_pubsubnet_2.id
  vpc_security_group_ids      = [aws_security_group.aravind_sg.id]
  user_data                   = file("./user_data2.sh")
  tags = {
    Name = "aravind_terraform_2"
  }
}


# ALB

resource "aws_alb" "aravind_alb" {
  name            = "aravind-alb"
  subnets         = ["${aws_subnet.aravind_pubsubnet_1.id}", "${aws_subnet.aravind_pubsubnet_2.id}"]
  security_groups = ["${aws_security_group.aravind_sg.id}"]
  tags = {
    Name = "aravind_terra_alb"
  }
}

# alb target group

resource "aws_alb_target_group" "aravind_tg" {
  name     = "aravind-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.aravind_terraform_vpc.id
}

# alb target group attachment 1

resource "aws_lb_target_group_attachment" "aravind_tga1" {
  target_group_arn = aws_alb_target_group.aravind_tg.arn
  target_id        = aws_instance.aravind_server_1.id
  port             = 80
}

# alb target group attachment 2

resource "aws_lb_target_group_attachment" "aravind_tga2" {
  target_group_arn = aws_alb_target_group.aravind_tg.arn
  target_id        = aws_instance.aravind_server_2.id
  port             = 80
}

# alb listener 

resource "aws_alb_listener" "aravind_alb_listener" {
  load_balancer_arn = aws_alb.aravind_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.aravind_tg.arn
    type             = "forward"
  }
}

# private subnet group for db 

resource "aws_db_subnet_group" "aravind_subnet_group" {
  name       = "aravind-db-subnet-group"
  subnet_ids = [aws_subnet.aravind_privsubnet_1.id, aws_subnet.aravind_privsubnet_2.id]
  tags = {
    Name = "aravind_subnet_group"
  }
}

# security group for db

resource "aws_security_group" "aravind_db_sg" {
  name   = "aravind-db-sg"
  vpc_id = aws_vpc.aravind_terraform_vpc.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.aravind_terraform_vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "aravind_db_sg"
  }
}

# db instance

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  identifier             = "aravind-db"
  engine                 = "mysql"
  engine_version         = "8.0.23"
  instance_class         = "db.t3.micro"
  name                   = "aravinddb"
  username               = "aravind"
  password               = "aravind4"
  port                   = "3306"
  db_subnet_group_name   = aws_db_subnet_group.aravind_subnet_group.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.aravind_db_sg.id]
}
