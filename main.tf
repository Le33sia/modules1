terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region     = "us-west-2"
}
module "network" {
  source = "./modules/network"

  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "autoscaling_group_lb" {
  source         = "./modules/autoscaling_group_lb"
  public_snet_1  = module.network.public_subnets.public_snet_1
  public_snet_2  = module.network.public_subnets.public_snet_2
  vpc_id         = module.network.vpc_id
  public_subnets = var.public_subnets
  # Launch Template
  instance_type   = var.instance_type
  security_groups = module.autoscaling_group_lb.SGtemplate_id
  image_id        = module.autoscaling_group_lb.image_id
  # Auto Scaling
  max_size          = var.max_size
  min_size          = var.min_size
  desired_capacity  = var.desired_capacity
  health_check_type = var.health_check_type
  # Load Balancer
  lb_name                       = var.lb_name
  lb_internal                   = var.lb_internal
  lb_load_balancer_type         = var.lb_load_balancer_type
  lb_enable_deletion_protection = var.lb_enable_deletion_protection
  lb_target_port                = var.lb_target_port
  lb_protocol                   = var.lb_protocol
  lb_listener_port              = var.lb_listener_port
  lb_listener_protocol          = var.lb_listener_protocol
  secrets_manager_secret_arn    = module.database.secrets_manager_secret_arn
}

module "database" {
  source = "./modules/database"
<<<<<<< HEAD

  db_instances               = var.db_instances
  secrets_manager_secret_arn = module.database.secrets_manager_secret_arn
  security_groups            = module.autoscaling_group_lb.SGtemplate_id
  vpc_id                     = module.network.vpc_id
  private_subnets            = var.private_subnets
  private_snet_1             = module.network.private_subnets.private_snet_1
  private_snet_2             = module.network.private_subnets.private_snet_2
}



=======

  db_instances               = var.db_instances
  secrets_manager_secret_arn = module.database.secrets_manager_secret_arn
  security_groups            = module.autoscaling_group_lb.SGtemplate_id
  vpc_id                     = module.network.vpc_id
  private_subnets            = var.private_subnets
  private_snet_1             = module.network.private_subnets.private_snet_1
  private_snet_2             = module.network.private_subnets.private_snet_2
}
>>>>>>> 5a414d40ba8b957aa6985f554151a403a9647e3f
