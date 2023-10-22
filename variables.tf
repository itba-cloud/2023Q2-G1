#Domain
variable "base_domain" {
  description = "Base domain of the application"
}

#S3
variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
}
variable "bucket_budget_name" {
  description = "Name of the budget bucket"
  type        = string
}

#VPC
variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

#Lambda
variable "lambda_security_group_name" {
  type        = string
  description = "Name of the Lambda Security Group"
}

variable "lambda_functions_paths" {
  description = "Lambda functions paths info"
  type = object({
    source = string
    output = string
  })

  default = {
    source = "./resources/lambda/"
    output = "./resources/lambda/"
  }
}