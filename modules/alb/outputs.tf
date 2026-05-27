output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}

output "tg_app1_arn" {
  value = aws_lb_target_group.tg_app1.arn
}

output "tg_ngnix_arn" {
  value = aws_lb_target_group.tg_ngnix.arn
}
