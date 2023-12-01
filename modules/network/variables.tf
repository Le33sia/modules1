variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}
variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

#subnets
variable "public_subnet1_cidr" {
  description = "CIDR block for public 1st subnet"
  type        = string
  //type        = list(string)
}
variable "public_subnet2_cidr" {
  description = "CIDR block for public 2nd subnet"
  type        = string
}

variable "private_subnet1_cidr" {
  description = "CIDR blocks for 1st private subnet"
  type        = string
}
variable "private_subnet2_cidr" {
  description = "CIDR blocks for 2nd private subnet"
  type        = string
}


variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "vpc_id" {}
variable "public_subnet1_id" {}
variable "public_subnet2_id" {}
variable "private_subnet1_id" {}
variable "private_subnet2_id" {}