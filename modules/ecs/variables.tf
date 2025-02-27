variable "app_port" {
  type    = number
  default = 5000
}

variable "repo_url" {}

variable "env_1" {
  default = "PGUSER"
}

variable "env_2" {
  default = "PGPASSWORD"
}

variable "env_3" {
  default = "PGDATABASE"
}

variable "env_4" {
  default = "PGHOST"
}

variable "env_5" {
  default = "PGPORT"
}

variable "ecs_sg_id" {}
variable "priv_sub_id" {}
variable "tg_id" {}

variable "db_username" {}
variable "db_password" {}
variable "db_name" {}
variable "db_host" {}

variable "db_port" {
  default = "5432"
}
