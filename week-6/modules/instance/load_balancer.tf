resource "aws_lb" "lohika_lb" {
  name               = "lohika"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh_http.id]
  subnets            = local.public_subnet_ids
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lohika_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lohika_lb_tg.arn
  }
}

resource "aws_lb_target_group" "lohika_lb_tg" {
  name     = "lohika"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  health_check {
    path     = "/actuator/health"
    protocol = "HTTP"
  }
}
