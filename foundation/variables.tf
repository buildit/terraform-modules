variable "vpc_cidr_block" {
  description = "VPC CIDR block (i.e. 0.0.0.0/0)"
}

variable "public_subnet_a_cidr_block" {
  description = "Public Subnet A CIDR block (i.e. 0.0.0.0/0)"
}

variable "public_subnet_b_cidr_block" {
  description = "Public Subnet B CIDR block (i.e. 0.0.0.0/0)"
}

variable "private_subnet_a_cidr_block" {
  description = "Private Subnet A CIDR block (i.e. 0.0.0.0/0)"
}

variable "private_subnet_b_cidr_block" {
  description = "Private Subnet B CIDR block (i.e. 0.0.0.0/0)"
}

variable "app_lb_name" {
  description = "Name to give to the application load balancer (cannot be more than 18 characters and cannot include spaces)."
}

variable "owner" {
  description = "Name of the owner of the project. Could be your name or organization name for instance."
}

variable "project" {
  description = "Name for the project that this foundation is being setup for."
}

variable "environment" {
  description = "Either integration, staging or production"
}
