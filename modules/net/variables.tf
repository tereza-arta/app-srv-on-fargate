variable "default_gateway" {
  default = "0.0.0.0/0"
}

variable "rds_sg_cnt" {
  type    = number
  default = 1
}

variable "rds_sg_name" {
  default = "Sg-for-RDS"
}

variable "rds_sg_desc" {
  default = "Allow pg-db incoming traffic from backend"
}

variable "rds_sg_tag" {
  default = "RDS-sg-tag-value"
}

variable "rds_sg_ing_cnt" {
  type    = number
  default = 1
}

variable "rds_sg_ing_tag" {
  default = "RDS-sg-ing-tag-value"
}

variable "rds_ing_port" {
  type    = number
  default = 5432
}

variable "rds_ing_proto" {
  default = "tcp"
}

variable "rds_sg_ing_desc" {
  default = "Allow incoming traffic dirrected to 5432 port-number"
}

variable "rds_sg_eg_cnt" {
  type    = number
  default = 1
}

variable "rds_sg_eg_tag" {
  default = "RDS-sg-eg-tag-value"
}

variable "rds_eg_proto" {
  default = "-1"
}

variable "rds_eg_desc" {
  default = "Allow all outgoing traffic"
}
