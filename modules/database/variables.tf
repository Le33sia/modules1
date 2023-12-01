variable "vpc_id" {}
variable "private_subnet1_id" {}
variable "private_subnet2_id" {}

variable "database_username" {
  type = string
}
variable "database_dbname" {
  type = string
}
variable "secrets_manager_secret_arn" {}
variable "security_groups" {}

variable "allocated_storage" {
  description = "Allocated storage"
  type        = number
}

variable "engine" {
  description = "Database engine"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "Instance class"
  type        = string
}

variable "identifier" {
  description = "Database identifier"
  type        = string
}

variable "parameter_group_name" {
  description = "Parameter group name"
  type        = string
}

variable "multi_az" {
  description = "Multi-AZ deployment"
  type        = bool
}

variable "storage_type" {
  description = "Storage type"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot"
  type        = bool
}
