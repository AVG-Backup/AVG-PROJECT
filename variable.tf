# AWS Region
variable "aws_region" {
  description = "The AWS region to deploy into"
  default     = "us-east-1"
}

# VPC CIDR Block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "192.168.0.0/16"
}

# Public Subnets
variable "public_subnet_1_cidr" {
  description = "CIDR for Public Subnet 1 (AZ1)"
  default     = "192.168.0.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR for Public Subnet 2 (AZ2)"
  default     = "192.168.1.0/24"
}

# Private App Subnets
variable "private_subnet_1_cidr" {
  description = "CIDR for Private Subnet 1 (AZ1)"
  default     = "192.168.2.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR for Private Subnet 2 (AZ2)"
  default     = "192.168.3.0/24"
}

# Database Subnets
variable "db_subnet_1_cidr" {
  description = "CIDR for DB Subnet 1 (AZ1)"
  default     = "192.168.4.0/24"
}

variable "db_subnet_2_cidr" {
  description = "CIDR for DB Subnet 2 (AZ2)"
  default     = "192.168.5.0/24"
}
