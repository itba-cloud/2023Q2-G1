variable "lambda_functions_paths" {
  description = "Lambda functions paths info"
  type = object({
    source = string
    output = string
  })
}

variable "lambda_functions_source_files" {
  description = "Lambda functions source files (source paths and output paths)"
  type = list(object({
    source_path = string
    output_path = string
  }))
}

variable "lambda_functions_attributes" {
  description = "Lambda functions package name"
  type = map(object({
    function_name    = string
    filename         = string
    description      = string
    source_code_hash = string
    role             = string
    runtime          = string
    handler          = string
    timeout          = number
  }))
}

variable "api_gateway_source_arn" {
  description = "Source ARN to execute Lambda functions in API Gateway"
  type        = string
}

variable "vpc_subnets_ids" {
  description = "List of VPC subnets ids where the Lambda functions will live"
  type        = list(string)
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC where the Lambda lives"
}

variable "lambda_security_group_name" {
  type        = string
  description = "Name of the Lambda Security Group"
}

variable "lambda_security_group_description" {
  type        = string
  description = "Description of the Lambda Security Group"
}

variable "lambda_security_group_cidr_blocks" {
  type        = list(string)
  description = "CIDR Block of the Lambda Security Group"
}

