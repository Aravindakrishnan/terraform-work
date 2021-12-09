# instances
resource "aws_instance" "aravind_server" {
  count                       = length(aws_subnet.aravind_pubsubnet)
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.aravind_pubsubnet[count.index].id
  availability_zone           = var.azs[count.index]
  vpc_security_group_ids      = [aws_security_group.aravind_sg.id]
  user_data                   = file("./scripts/user_data${count.index + 1}.sh")
  tags = {
    Name = "aravind_terraform",
    author = "akrishnanh@presidio.com"
  }
}
