resource "aws_lb" "app_lb" {
  name               = "${var.project_name}-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets

  enable_deletion_protection = true

  tags = {
    Name = "${var.project_name}-app-lb"
  }
}

resource "aws_lb_target_group" "tg_app1" {
  name        = "${var.project_name}-app1"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200-399"
    path                = "/status"
    timeout             = 5
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.project_name}-app1-tg"
  }
}

resource "aws_lb_target_group" "tg_ngnix" {
  name        = "${var.project_name}-nginx"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200-399"
    path                = "/"
    timeout             = 5
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.project_name}-nginx-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_app1.arn
  }
}

resource "aws_lb_listener_rule" "ngnix_routing" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_ngnix.arn
  }

  condition {
    path_pattern {
      values = ["/app2*"]
    }
  }
}
