provider "aws" {
  #credentials_file = file("${var.credentials}")
  region           = var.region

}

# Creación Microservicios
module "microservice-instance" {
  count           = var.appserver_count #Value depends on workload
  source          = "./modules/microservice-instance"
  appserver_count = var.appserver_count
  image           = var.image
  instance_type   = var.instance_type
  zones           = var.zones
}

# Load Balancer & Auto Scaling
module "lb" {
  count         = var.enable_autoscaling ? 1 : 0
  source        = "./modules/lb"
  region        = var.region
  zones         = var.zones
  image         = var.image
  instance_type = var.instance_type
  vpc-id        = module.vpc.vpc-id
}

#Creation VPC
module "vpc" {
  # count = var.create_default_vpc ? 1:0
  source = "./modules/vpc"
  region = var.region
  zones  = var.zones
}

#Creation SQL
module "database" {
  count  = var.no_of_db_instances
  source = "./modules/database"
  # nat_ip = module.microservice-instance.nat_ip
  no_of_db_instances = var.no_of_db_instances
  db_name            = var.db_name
  db_user            = var.db_user
  db_password        = var.db_password
}
