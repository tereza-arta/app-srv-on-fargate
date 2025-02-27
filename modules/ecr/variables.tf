variable "ecr_cnt" {
  type        = number
  default     = 1
  description = "Count of ecr repos for app components"
}

#variable "repo_name" {}


variable "index" {
  type    = number
  default = 0
}

variable "mutability" {
  default = "MUTABLE"
}

variable "df_context" {}

variable "tf_data_dkr_pack" {
  type        = bool
  default     = true
  description = "Create terraform_data resource prepared for docker-build/push to ECR or not"
}

variable "build_arg" {
  type    = bool
  default = false
}

#This must be same in ecs module variables
variable "image_tag" {
  default     = "latest"
  description = "Default image-tag for all app-components"
}

