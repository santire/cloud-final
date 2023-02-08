variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "pg_username" {
  type    = string
}

variable "pg_password" {
  type    = string
}

variable "pg_port" {
  type    = string
}

variable "pg_database" {
  type    = string
}

variable "lambdas_security_group_id" {
  type    = string
}
