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
