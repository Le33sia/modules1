terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "network" {
  source = "./modules/network"
  vpc_id = module.network.vpc_id
  public_subnet1_id = module.network.public_subnet1_id
  public_subnet2_id = module.network.public_subnet2_id
  private_subnet1_id = module.network.private_subnet1_id
  private_subnet2_id = module.network.private_subnet2_id
  vpc_cidr_block              =  "172.16.0.0/16" 
  Public_subnet1_cidr         =  "172.16.0.0/26"
  Public_subnet2_cidr         =  "172.16.0.64/26"
  Private_subnet1_cidr        =  "172.16.0.128/26"
  Private_subnet2_cidr        =  "172.16.0.192/26"
  availability_zones          =  ["us-west-2a", "us-west-2b"]
}

module "ASG" {
  source = "./modules/ASG"

  # Launch Template
  instance_type = "t2.micro"
  security_groups = module.ASG.SGtemplate_id
  image_id = module.ASG.image_id

  # Auto Scaling
  max_size              = 1
  min_size              = 1
  desired_capacity      = 1
  health_check_type = "ELB"

  # Load Balancer
  lb_name                       = "LB"
  lb_internal                   = false
  lb_load_balancer_type         = "application"
  lb_enable_deletion_protection = false
  lb_target_port                = 80
  lb_protocol                   = "HTTP"
  lb_listener_port              = 80
  lb_listener_protocol          = "HTTP"

  vpc_id = module.network.vpc_id
  public_subnet1_id = module.network.public_subnet1_id
  public_subnet2_id = module.network.public_subnet2_id
  secrets_manager_secret_arn = module.database.secrets_manager_secret_arn
  

}

module "database" {
  source = "./modules/database"
  #database
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.33"
  instance_class       = "db.t3.micro"
  identifier           = "database-1"
  parameter_group_name = "default.mysql8.0"
  multi_az             = false
  storage_type         = "gp2"
  skip_final_snapshot  = true
  vpc_id = module.network.vpc_id
  private_subnet1_id = module.network.private_subnet1_id
  private_subnet2_id = module.network.private_subnet2_id
  #secret manager
  database_username  = "admin"
  database_dbname    = "demodb"
  secrets_manager_secret_arn = module.database.secrets_manager_secret_arn
  
  security_groups = module.ASG.SGtemplate_id  
}

