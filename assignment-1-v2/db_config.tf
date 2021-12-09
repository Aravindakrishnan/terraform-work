# db instance

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  identifier             = "aravind-db"
  engine                 = "mysql"
  engine_version         = "8.0.23"
  instance_class         = "db.t3.micro"
  name                   = "aravinddb"
  username               = var.DB_USERNAME
  password               = var.DB_PASSWORD
  port                   = "3306"
  db_subnet_group_name   = aws_db_subnet_group.aravind_subnet_group.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.aravind_db_sg.id]
}
