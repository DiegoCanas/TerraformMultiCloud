variable "name" {}
variable "region" { default = "eu-west-3" }
variable "zones" { default = ["eu-west-3a", "eu-west-3b"] }
variable "env" { default = "dev" }
variable "network_name" { default = "awsMC" }
variable "credentials" {}
variable "image" { default = "ami-0d2ca4d7e5645e504" }

variable "appserver_count" { default = 2 }
variable "instance_type" { default = "t3.micro" }
variable "no_of_db_instances" { default = 1 }
variable "create_default_vpc" { default = true }
variable "enable_autoscaling" { default = true }
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}