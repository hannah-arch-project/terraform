resource "aws_lb" "my_alb" {
    name               = "aws-alb-myalb"
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_sg.id]
    subnets            = var.subnet_ids
}

resource "aws_security_group" "alb_sg" {
    name        = "aws-sg-albsg"
    description = "Allow inbound traffic to the ALB"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "TCP"
        # cidr_blocks = var.sg_allow_comm_list
        cidr_blocks = [ "0.0.0.0/0" ]
        description = ""
        self        = true
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "TCP"
        # cidr_blocks = var.sg_allow_comm_list
        cidr_blocks = [ "0.0.0.0/0" ]
        description = ""
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb_target_group" "target_asg" {
    name     = "aws-tg-albtg"
    port     = var.port
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        path = var.hc_path
        healthy_threshold   = var.hc_healthy_threshold
        unhealthy_threshold = var.hc_unhealthy_threshold
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 15
        timeout             = 3
  }
}

# resource "aws_lb_target_group_attachment" "target-group-attachment" {
#   count = length(var.instance_ids)
#   target_group_arn = aws_lb_target_group.target_asg.arn
#   target_id        = var.instance_ids[count.index]
#   port             = var.port
  
#   availability_zone = var.availability_zone
  
#   depends_on =[aws_lb_target_group.target_asg]
# }

resource "aws_lb_listener" "lb-listener-443" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_asg.arn
  }
  depends_on =[aws_lb_target_group.target_asg]
}

resource "aws_lb_listener" "lb-listener-80" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
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


resource "aws_lb_listener_rule" "alb_listener_rule" {
    listener_arn = aws_lb_listener.lb-listener-80.arn
    priority = 100

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.target_asg.arn
    }

    condition {
        path_pattern {
            values = ["*"]
        }
    }
}