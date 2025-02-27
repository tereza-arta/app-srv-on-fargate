resource "aws_alb" "alb" {
  name            = "cb-load-balancer"
  subnets         = aws_subnet.pub.*.id
  security_groups = [aws_security_group.lb[0].id]
}

resource "aws_alb_target_group" "this" {
  name        = "cb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc[0].id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_alb.alb.id
  port              = 5000
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.this.id
    type             = "forward"
  }
}
