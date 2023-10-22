variable "bucket_name" {
  type        = string
  description = "Domain name of the frontend S3 bucket"
}

variable "bucket_id" {
  type        = string
  description = "Id of the frontend S3 bucket"
}

variable "apigw_path" {
  type        = string
  description = "Path to the apigw"
}

variable "apigw_url" {
  type        = string
  description = "Url for Cloudfront to call the API-GW"
}

variable "apigw_stage" {
  type        = string
  description = "stage of the API-GW"
}

# variable "certificate_arn" {
#   description = "ARN of the certificate associated with domain name"
#   type = string
# }