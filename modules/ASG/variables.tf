variable "vpc_id" {}
variable "public_subnet1_id" {}
variable "public_subnet2_id" {}

variable "secrets_manager_secret_arn" {}



# Launch Template
variable "security_groups" {}
variable "instance_type" {}
variable "image_id" {}
variable "ami_name" {
  description = "Name of the AMI"
  default     = "test"
}
variable "ami_owner" {
  description = "Owner of the AMI"
  default     = "self"
}


# Auto Scaling
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "health_check_type" {}
variable "target_group_arns" {}

# Load Balancer
variable "lb_name" {}
variable "lb_internal" {}
variable "lb_load_balancer_type" {}
variable "lb_enable_deletion_protection" {}
variable "lb_target_port" {}
variable "lb_protocol" {}
variable "lb_listener_port" {}
variable "lb_listener_protocol" {}
