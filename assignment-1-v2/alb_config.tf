# ALB

resource "aws_alb" "aravind_alb" {
  name            = "aravind-alb"
  subnets         = [aws_subnet.aravind_pubsubnet[0].id, aws_subnet.aravind_pubsubnet[1].id]
  security_groups = [aws_security_group.aravind_sg.id]
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

# alb target group attachment

resource "aws_lb_target_group_attachment" "aravind_tga" {
  count            = length(aws_instance.aravind_server)
  target_group_arn = aws_alb_target_group.aravind_tg.arn
  target_id        = aws_instance.aravind_server[count.index].id
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