variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "vpc_azs" {
  description = "List of AZs the VPC lives in"
  type        = list(string)
  default     = []
}

variable "vpc_private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = []
}

variable "vpc_private_subnet_names" {
  description = "List of private subnet names"
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_service_name" {
  description = "VPC Endpoint Service Name"
  type        = string
}