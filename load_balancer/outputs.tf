#loadbalancing/outputs.tf 

output "elb" {
  value = aws_lb.wk21_lb.id
}

output "alb_tg" {
  value = aws_lb_target_group.wk21_tg.arn
}

output "alb_dns" {
  value = aws_lb.wk21_lb.dns_name
}