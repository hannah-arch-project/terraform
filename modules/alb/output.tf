output "alb_arn" {
  value       = aws_lb.my_alb.arn
  description = "ARN of the ALB"
}

output "alb_dns_name" {
  value       = aws_lb.my_alb.dns_name
  description = "DNS name of the ALB"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb_sg.id
  description = "Security Group ID for the ALB"
}

output "target_group_arn" {
  value       = aws_lb_target_group.target_asg.arn
  description = "ARN of the ALB target group"
}