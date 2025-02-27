output "vpc_id" {
  value = aws_vpc.vpc[0].id
}

output "alb_hostname" {
  value = "${aws_alb.alb.dns_name}:3000"
}

output "priv_sub_id" {
  value = aws_subnet.priv.*.id
}

output "tg_id" {
  value = aws_alb_target_group.this.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs.id
}
