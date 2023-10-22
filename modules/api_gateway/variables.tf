variable "api_gateway_rest_api_info" {
  description = "API Gateway REST API info"
  type = object({
    name        = string
    description = string
    stage_name  = optional(string, "production")
    base_path   = optional(string, "api")
  })
}

variable "api_gateway_resources" {
  description = "API Gateway resources"
  type = map(object({
    path_part = string
  }))
}

variable "api_gateway_methods" {
  description = "API Gateway methods"
  type = map(object({
    resource      = string
    method        = string
    authorization = string
  }))
}

variable "lambda_functions_invoke_arn" {
  description = "Lambda functions invoke arn"
  type        = map(string)
}