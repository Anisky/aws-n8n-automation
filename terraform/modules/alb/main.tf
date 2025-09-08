resource "aws_lb" "n8n" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids
}



# --- Target Group for EC2 ---
resource "aws_lb_target_group" "n8n_tg" {
  name        = "n8n-tg"
  port        = 5678
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    port                = "5678"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# --- ALB Listener HTTP (Redirect to HTTPS) ---
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.n8n.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# --- ALB Listener HTTPS ---
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.n8n.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"
  certificate_arn   = var.cm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
    
  }
}
# --- Attach EC2 to Target Group ---
resource "aws_lb_target_group_attachment" "n8n_tg" {
  target_group_arn = var.target_group_arn
  target_id        = element(var.instance_ids, 0)
  port             = 5678
}

