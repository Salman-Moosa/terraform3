variable "project_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "ecs_sg_id" {
  type = string
}

variable "tg_app1_arn" {
  type = string
}

variable "tg_ngnix_arn" {
  type = string
}

variable "db_endpoint" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
