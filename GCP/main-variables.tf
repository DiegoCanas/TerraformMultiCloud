variable name {default=""}
variable project {}
variable credentials {}
variable region {default = "e"}
variable zones { default = ["", ""] }
variable env { default = "" }
variable network_name {default = ""}
variable image {default=""}

variable appserver_count { default = 1 }
variable webserver_count { default = 2 }
variable app_image { default = "" }
variable instance_type { default = "" }
variable no_of_db_instances{ default = 1 }
# variable create_default_vpc{ default = true }
variable enable_autoscaling {default = true}
variable db_user {}
variable db_password {}