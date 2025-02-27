#resource "aws_security_group" "lb" {
#  name        = "cb-load-balancer-security-group"
#  description = "controls access to the ALB"
#  vpc_id      = aws_vpc.vpc[0].id
#
#  ingress {
#    protocol    = "tcp"
#    from_port   = 5000
#    to_port     = 5000
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    protocol    = "-1"
#    from_port   = 0
#    to_port     = 0
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}

resource "aws_security_group" "lb" {
  count = 1
  name = "Sg-for-lb"
  vpc_id = aws_vpc.vpc[0].id
  description ="some-desc"
  tags = {
    Name = "Some-lb-tag"
  }
}

resource "aws_vpc_security_group_ingress_rule" "lb" {
  count = 1
  security_group_id = aws_security_group.lb[count.index].id
  tags = {
    Name = "lb-sg-ing-tag"
  }

  from_port = 5000
  to_port = 5000
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
  description = "lb-sg-ing-desc"
}

resource "aws_vpc_security_group_egress_rule" "for_lb" {
  count = 1
  security_group_id = aws_security_group.lb[count.index].id
  tags = {
    Name = "lb-sg-eg-tag"
  }

  from_port = 0
  to_port = 0
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
  description = "lb-sg-eg-desc"
}

#resource "aws_security_group" "ecs" {
#  name        = "cb-ecs-tasks-security-group"
#  description = "allow inbound access from the ALB only"
#  vpc_id      = aws_vpc.vpc[0].id
#
#  ingress {
#    protocol        = "tcp"
#    from_port       = 5000
#    to_port         = 5000
#    security_groups = [aws_security_group.lb.id]
#  }
#
#  egress {
#    protocol    = "-1"
#    from_port   = 0
#    to_port     = 0
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}

resource "aws_security_group" "ecs" {
  count = 1
  name = "Sg-for-ECS"
  vpc_id = aws_vpc.vpc[0].id
  description = "ecs-sg-desc"
  tags = {
    Name = "ecs-sg-tag"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs" {
  count = 1
  security_group_id = aws_security_group.ecs[count.index].id

  from_port = 5000
  to_port = 5000
  ip_protocol = "tcp"
  description = "ecs-sg-ing-desc"
  referenced_security_group_id = aws_security_group.lb[count.index].id

  tags = {
    Name = "ecs-sg-ing-tag"
  }
}

resource "aws_vpc_security_group_egress_rule" "ecs" {
  count = 1
  security_group_id = aws_security_group.ecs[count.index].id

  from_port = 0
  to_port = 0
  ip_protocol = "-1"
  description = "ecs-sg-eg-desc"
  referenced_security_group_id = aws_security_group.lb[count.index].id

  tags = {
    Name = "ecs-sg-eg-tag"
  }
}


resource "aws_security_group" "for_rds" {
  count       = var.rds_sg_cnt
  name        = "${var.rds_sg_name}-${count.index}"
  vpc_id      = aws_vpc.vpc[0].id
  description = var.rds_sg_desc
  tags = {
    Name = var.rds_sg_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "for_rds" {
  count             = var.rds_sg_ing_cnt
  security_group_id = aws_security_group.for_rds[count.index].id
  tags = {
    Name = var.rds_sg_ing_tag
  }

  from_port   = var.rds_ing_port
  to_port     = var.rds_ing_port
  ip_protocol = var.rds_ing_proto
  cidr_ipv4   = var.default_gateway
  description = var.rds_sg_ing_desc
}

resource "aws_vpc_security_group_egress_rule" "for_rds" {
  count             = var.rds_sg_eg_cnt
  security_group_id = aws_security_group.for_rds[count.index].id
  tags = {
    Name = var.rds_sg_eg_tag
  }

  #from_port = 0
  #to_port = 0
  ip_protocol = var.rds_eg_proto
  cidr_ipv4   = var.default_gateway
  description = var.rds_eg_desc
}
