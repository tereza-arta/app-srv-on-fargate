resource "aws_security_group" "lb" {
  name        = "cb-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.vpc[0].id

  ingress {
    protocol    = "tcp"
    from_port   = 5000
    to_port     = 5000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  name        = "cb-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.vpc[0].id

  ingress {
    protocol        = "tcp"
    from_port       = 5000
    to_port         = 5000
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
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
